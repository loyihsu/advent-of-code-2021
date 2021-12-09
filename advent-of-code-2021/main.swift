//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver_1(input: [[Int]]) -> [(Int, Int)] {
    var output = [(Int, Int)]()
    for idx in map.indices {
        for jdx in map[idx].indices {
            let directions = [(idx+1, jdx), (idx-1, jdx), (idx, jdx+1), (idx, jdx-1)]
            let current = map[idx][jdx]
            var counter = (0, 0)
            for direction in directions where (0..<map.count).contains(direction.0) && (0..<map[idx].count).contains(direction.1) {
                counter = current < map[direction.0][direction.1] ? (counter.0 + 1, counter.1 + 1) : (counter.0 + 0, counter.1 + 1)
            }
            if counter.0 == counter.1 {
                output.append((idx, jdx))
            }
        }
    }
    return output
}

func solver_2(map: [[Int]], lowestPoints: [(Int, Int)]) -> Int {
    var areas = [Int]()
    for lowest in lowestPoints {
        var searchStack = [(lowest.0, lowest.1)], explored = Set<String>()
        while let last = searchStack.popLast() {
            explored.insert("\(last)")
            let (idx, jdx) = last
            let directions = [(idx+1, jdx), (idx-1, jdx), (idx, jdx+1), (idx, jdx-1)]
            for direction in directions where (0..<map.count).contains(direction.0) && (0..<map[idx].count).contains(direction.1) {
                if map[direction.0][direction.1] < 9 && !explored.contains("\(direction)") {
                    searchStack.append(direction)
                }
            }
        }
        areas.append(explored.count)
    }
    return areas.sorted(by: >)[0..<3].reduce(1, *)
}

let map = getIoFile(for: .question1).trimmingCharacters(in: .newlines)
    .components(separatedBy: .newlines)
    .map({ Array($0).compactMap({ Int("\($0)") }) })

let solution1 = solver_1(input: map)

print(solution1.map({ map[$0.0][$0.1] + 1 }).reduce(0, +))
print(solver_2(map: map, lowestPoints: solution1))
