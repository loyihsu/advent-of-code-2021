//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

// This solution references arjanIng's Java solution from: https://github.com/arjanIng/advent2021/blob/dad1b07063254d364301cbee80d38ef8b87b0ad3/src/advent/Day18.java

import Foundation

class SnailNumber: Equatable {
    static func == (lhs: SnailNumber, rhs: SnailNumber) -> Bool {
        lhs.id == rhs.id
    }
    var id = UUID()
    var value: Int?
    var parent: SnailNumber?, left: SnailNumber?, right: SnailNumber?
    init(left: SnailNumber?, right: SnailNumber?) {
        self.left = left
        self.right = right
        left?.parent = self
        right?.parent = self
    }
    init(value: Int) {
        self.value = value
    }
    func reduce() {
        var flag = true
        while flag {
            flag = false
            while explode() {
                flag = true
            }
            flag = flag || split()
        }
    }
    func explode() -> Bool {
        if value == nil {
            if depth >= 4 {
                let nearests = nearestOnes(to: self)
                if let nearestLeft = nearests.left, let left = left {
                    nearestLeft.value! += left.value!
                }
                if let nearestRight = nearests.right, let right = right {
                    nearestRight.value! += right.value!
                }
                (value, left, right) = (0, nil, nil)
                return true
            } else {
                // Go deeper
                if let res = left?.explode(), res {
                    return true
                }
                if let res = right?.explode(), res {
                    return true
                }
            }
        }
        return false
    }
    func split() -> Bool {
        if let current = value {
            if current >= 10 {
                let half = current / 2
                (value, left, right) = (nil, SnailNumber(value: half), SnailNumber(value: current-half))
                left?.parent = self
                right?.parent = self
                return true
            }
        } else {
            // Go deeper
            if let res = left?.split(), res {
                return true
            }
            if let res = right?.split(), res {
                return true
            }
        }
        return false
    }

    var origin: SnailNumber {
        var temp = self
        while let parent = temp.parent {
            temp = parent
        }
        return temp
    }

    func nearestOnes(to number: SnailNumber) -> (left: SnailNumber?, right: SnailNumber?) {
        let all = origin.allSnailNumbers
        var output: (SnailNumber?, SnailNumber?)
        if let idx = all.firstIndex(where: { $0 == number.left }), idx != 0 {
            output.0 = all[idx - 1]
        }
        if let idx = all.firstIndex(where: { $0 == number.right }), idx != all.count - 1 {
            output.1 = all[idx + 1]
        }
        return output
    }

    var allSnailNumbers: [SnailNumber] {
        if value != nil {
             return [self]
        }
        var all = [SnailNumber]()
        if let left = left {
            all.append(contentsOf: left.allSnailNumbers)
        }
        if let right = right {
            all.append(contentsOf: right.allSnailNumbers)
        }
        return all
    }

    var depth: Int {
        guard let parent = parent else { return 0 }
        return parent.depth + 1
    }
    static func parser(_ input: String) -> SnailNumber? {
        // If it is already a digit only, return the snail number created from it.
        guard input.count > 1 else { return SnailNumber(value: Int(input)!) }
        // Find the split point of this level and parse recursively.
        var stack = "", splitPos: String.Index?
        for (idx, char) in input.enumerated() where splitPos == nil {
            if char == "[" {
                stack.append(char)
            } else if char == "]" {
                _ = stack.removeLast()
            } else if char == "," && stack.count == 1 {
                splitPos = input.index(input.startIndex, offsetBy: idx)
            }
        }
        guard let splitPos = splitPos else {
            return nil
        }
        return SnailNumber(left: parser(String(input[input.index(after: input.startIndex)..<splitPos])),
                           right: parser(String(input[input.index(after: splitPos)..<input.index(before: input.endIndex)])))
    }
    var magnitude: Int {
        if let value = value {
            return value
        }
        if let left = left, let right = right {
            return 3 * left.magnitude + 2 * right.magnitude
        }
        fatalError("Magnitude cannot be found.")
    }
}

func solver_1(input: String) -> Int {
    var lines = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)

    var tree = SnailNumber.parser(lines.removeFirst())

    for line in lines {
        let newTree = SnailNumber.parser(line)
        tree = SnailNumber(left: tree, right: newTree)
        tree?.reduce()
    }
    return tree?.magnitude ?? 0
}

func solver_2(input: String) -> Int {
    let lines = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
    var combinations = [(String, String)]()
    var sum = [Int]()
    for idx in lines.indices {
        for jdx in lines.indices where idx != jdx {
            combinations.append((lines[idx], lines[jdx]))
        }
    }
    for (first, second) in combinations {
        let firstTree = SnailNumber.parser(first)
        let secondTree = SnailNumber.parser(second)
        let tree = SnailNumber(left: firstTree, right: secondTree)
        tree.reduce()
        sum.append(tree.magnitude)
    }
    return sum.max() ?? 0
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
