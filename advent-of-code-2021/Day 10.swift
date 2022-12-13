//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver_1(input: String) -> (errorScore: Int, stacks: [[Character]]) {
    let list = getPlainStringList(from: input)
    let pairs: [Character: Character] = ["(": ")", "[": "]", "{": "}", "<": ">"]
    let scores: [Character: Int] = [")": 3, "]": 57, "}": 1197, ">": 25137]
    var points = 0, stacks = [[Character]]()
    for item in list {
        var flag = false, stack = [Character]()
        for char in item {
            if "[({<".contains(char) {
                stack.append(char)
            } else if let last = stack.last {
                if let pair = pairs[last], char == pair {
                    stack.removeLast()
                } else if let score = scores[char] {
                    points += score
                    flag = true
                    break
                }
            }
        }
        if !flag {
            stacks.append(stack)
        }
    }
    return (points, stacks)
}

func solver_2(input: [[Character]]) -> Int {
    let scores: [Character: Int] = ["(": 1, "[": 2, "{": 3, "<": 4]
    var values = [Int]()
    for line in input {
        var temp = line, item = 0
        while let last = temp.popLast(), let score = scores[last] {
            item = item * 5 + score
        }
        values.append(item)
    }
    return values.sorted()[values.count / 2]
}

let res = solver_1(input: getIoFile(for: .question1))
print(res.errorScore)
print(solver_2(input: res.stacks))
