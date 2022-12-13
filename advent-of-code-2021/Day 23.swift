//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

// I actually solved this manually, but here is a brute force solution using best first search (with heap).
// This shared solution is referenced when debugging/optimising this solution: https://github.com/Dav1dde/adventofcode/blob/master/2021/src/day23.rs
// This Heap implementation is from [Swift Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club/)
// - LICENSE: [MIT](https://github.com/raywenderlich/swift-algorithm-club/blob/master/LICENSE.txt)

// MARK: Move Commands

protocol Move {
    var fromIndex: Int { get set }
    var toIndex: Int { get set }
}

struct CaveToCave: Move {
    var fromIndex: Int
    var toIndex: Int
}

struct CaveToBuffer: Move {
    var fromIndex: Int
    var toIndex: Int
}

struct BufferToBuffer: Move {
    var fromIndex: Int
    var toIndex: Int
}

struct BufferToCave: Move {
    var fromIndex: Int
    var toIndex: Int
}

// MARK: Map Modelling

enum Pods: String {
    case A, B, C, D, Empty
}

class Map: Hashable {
    static func == (lhs: Map, rhs: Map) -> Bool {
        lhs.caves == rhs.caves && lhs.buffer == rhs.buffer && lhs.cost == rhs.cost
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(caves)
        hasher.combine(buffer)
        hasher.combine(cost)
    }
    var caves: [[Pods]]
    var buffer = [Pods](repeating: .Empty, count: 11)
    var cost = 0
    init(caves: [String], cost: Int = 0) {
        self.caves = caves.compactMap { item in
            item.compactMap { char in
                return Pods(rawValue: "\(char)")
            }
        }
        self.cost = cost
    }
    init(caves: [[Pods]], buffer: [Pods], cost: Int) {
        self.caves = caves
        self.buffer = buffer
        self.cost = cost
    }
    func isCaveDone(cave: Int) -> Bool {
        let mapper: [Int: Pods] = [0: .A, 1: .B, 2: .C, 3: .D]
        if let mapped = mapper[cave] {
            return !caves[cave].contains(where: { $0 != mapped })
        }
        return false
    }
    func isDone() -> Bool {
        for idx in caves.indices {
            if isCaveDone(cave: idx) == false {
                return false
            }
        }
        return true
    }
    func isBlocking(_ pod: Int, in cave: Int) -> Bool {
        if pod == caves[cave].endIndex - 1 {
            return false
        } else {
            let range = caves[cave][pod...]
            return range.contains(where: {
                $0 != podsByTarget[cave]
            })
        }
    }
    func isBlocked(_ pod: Int, in cave: Int) -> Bool {
        if pod == 0 {
            return false
        }
        return caves[cave][0..<pod].contains(where: { $0 != .Empty })
    }
    func isHome(item: Pods, cave: Int) -> Bool {
        return cave == target[item, default: 0]
    }
    func canMove(fromCave: Int, toAnotherCave: Int) -> Move? {
        // The cave is ready for input
        if !caves[toAnotherCave].contains(where: { !($0 == podsByTarget[toAnotherCave] || $0 == .Empty) }) {
            // There is nothing in the way
            let mover = (caveDoors[fromCave], caveDoors[toAnotherCave])
            let range = buffer[min(mover.0, mover.1)...max(mover.0, mover.1)]
            if !range.contains(where: { $0 != .Empty }) {
                return CaveToCave(fromIndex: fromCave, toIndex: toAnotherCave)
            }
        }
        return nil
    }
    func canMove(fromCave: Int, toBuffer: Int) -> Move? {
        guard !caveDoors.contains(toBuffer) else { return nil }
        let range = buffer[min(caveDoors[fromCave],toBuffer)...max(caveDoors[fromCave], toBuffer)]
        if !range.contains(where: { $0 != .Empty }) {
            return CaveToBuffer(fromIndex: fromCave, toIndex: toBuffer)
        }
        return nil
    }
    func canMove(fromBuffer: Int, toAnotherBuffer: Int) -> Move? {
        guard !caveDoors.contains(toAnotherBuffer) else { return nil }
        let mover = (min(fromBuffer, toAnotherBuffer)+1, max(fromBuffer, toAnotherBuffer)-1)
        let range = buffer[min(mover.0, mover.1)...max(mover.1, mover.0)]
        if !range.contains(where: { $0 != .Empty }) {
            return BufferToBuffer(fromIndex: min(mover.0, mover.1), toIndex: max(mover.1, mover.0))
        }
        return nil
    }
    func canMove(fromBuffer: Int, toCave: Int) -> Move? {
        if !caves[toCave].contains(where: { !($0 == podsByTarget[toCave] || $0 == .Empty) }) {
            var mover = (min(fromBuffer, caveDoors[toCave]), max(fromBuffer, caveDoors[toCave]))
            if mover.0 == fromBuffer {
                mover.0 += 1
            } else if mover.1 == fromBuffer {
                mover.1 -= 1
            }
            let range = buffer[mover.0...mover.1]
            if !range.contains(where: { $0 != .Empty }) {
                return BufferToCave(fromIndex: fromBuffer, toIndex: toCave)
            }
        }
        return nil
    }
    func generateMoves() -> [Move] {
        var output = [Move]()
        guard !isDone() else { return [] }
        for idx in caves.indices {
            guard !isCaveDone(cave: idx) else {
                continue
            }
            for jdx in caves[idx].indices where caves[idx][jdx] != .Empty {
                // Check if it is blocked
                guard !isBlocked(jdx, in: idx) else {
                    continue
                }

                if isHome(item: caves[idx][jdx], cave: idx) {
                    if !isBlocking(jdx, in: idx) {
                        continue
                    }
                } else {
                    if let move = canMove(fromCave: idx, toAnotherCave: target[caves[idx][jdx], default: 0]) {
                        output.append(move)
                    }
                }

                for buffer in buffer.indices {
                    if let move = canMove(fromCave: idx, toBuffer: buffer) {
                        output.append(move)
                    }
                }
            }
            for idx in buffer.indices where buffer[idx] != .Empty {
                if let move = canMove(fromBuffer: idx, toCave: target[buffer[idx], default: 0]) {
                    output.append(move)
                }
                for jdx in buffer.indices where idx != jdx {
                    if let move = canMove(fromBuffer: idx, toAnotherBuffer: jdx) {
                        output.append(move)
                    }
                }
            }
        }
        return output
    }
    func realise(move: Move) -> Map? {
        let newMap = Map(caves: caves, buffer: buffer, cost: cost)
        if let move = move as? CaveToCave {
            if let idx = newMap.caves[move.fromIndex].firstIndex(where: { $0 != .Empty }) {
                let temp = newMap.caves[move.fromIndex][idx]
                newMap.caves[move.fromIndex][idx] = .Empty
                if let destination = newMap.caves[move.toIndex].lastIndex(where: { $0 == .Empty}) {
                    newMap.caves[move.toIndex][destination] = temp
                    if let cost = costs[temp] {
                        let distance = idx + abs(caveDoors[move.fromIndex] - caveDoors[move.toIndex]) + destination + 3
                        newMap.cost = newMap.cost +  distance * cost
                    }
                }
            }
            return newMap
        } else if let move = move as? CaveToBuffer {
            if let idx = newMap.caves[move.fromIndex].firstIndex(where: { $0 != .Empty }) {
                let temp = newMap.caves[move.fromIndex][idx]
                newMap.caves[move.fromIndex][idx] = .Empty
                newMap.buffer[move.toIndex] = temp
                if let cost = costs[temp] {
                    let distance = idx + abs(caveDoors[move.fromIndex] - move.toIndex) + 1
                    newMap.cost = newMap.cost + distance * cost
                }
            }
            return newMap
        } else if let move = move as? BufferToCave {
            if let destination = newMap.caves[move.toIndex].lastIndex(where: { $0 == .Empty }) {
                let temp = newMap.buffer[move.fromIndex]
                newMap.buffer[move.fromIndex] = .Empty
                newMap.caves[move.toIndex][destination] = temp
                if let cost = costs[temp] {
                    let distance = abs(caveDoors[move.toIndex] - move.fromIndex) + destination + 1
                    newMap.cost = newMap.cost + distance * cost
                }
            }
            return newMap
        } else if let move = move as? BufferToBuffer {
            (buffer[move.fromIndex], buffer[move.toIndex]) = (buffer[move.toIndex], buffer[move.fromIndex])
            if let cost = costs[buffer[move.fromIndex]] {
                let distance = abs(move.fromIndex - move.toIndex)
                newMap.cost = newMap.cost + distance * cost
            }
            return newMap
        }
        return nil
    }
}

// MARK: Constants

let target: [Pods: Int] = [.A: 0, .B: 1, .C: 2, .D: 3]
let podsByTarget: [Pods] = [.A, .B, .C, .D]
let costs: [Pods: Int] = [.A: 1, .B: 10, .C: 100, .D: 1000]
let caveDoors: [Int] = [2, 4, 6, 8]

// MARK: Runner

func solve(input: [String]) -> Int? {
    // Parse input
    var caves = [String](repeating: "", count: 4), idx = 0

    for line in input {
        for char in line where "ABCD".contains(char) {
            caves[idx].append(char)
            idx = (idx + 1) % 4
        }
    }

    // Create tools
    var heap = Heap(array: [Map(caves: caves)], sort: { $0.cost < $1.cost })
    var book = Set<Map>()

    // Do the work until the first in found.
    while let map = heap.remove() {
        if map.isDone() {
            return map.cost
        }
        let moves = map.generateMoves()
        for move in moves {
            if let createdMap = map.realise(move: move) {
                if !book.contains(createdMap) {
                    book.insert(createdMap)
                    heap.insert(createdMap)
                }
            }
        }
    }
    return nil
}

print(solve(input: getIoFile(for: .question1).components(separatedBy: .newlines)) ?? -1)
print(solve(input: getIoFile(for: .question2).components(separatedBy: .newlines)) ?? -1)
