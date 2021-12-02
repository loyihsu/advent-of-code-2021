//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

enum CommandDirections: String {
    case forward, up, down
}

func solver_1(input: String) -> Int {
    let parsedInput = getParsedStringsFromLinesAndSpaces(from: input)
    var position = (horizontal: 0, vertical: 0)
    for line in parsedInput {
        if let command = line.first, let last = line.last, let value = Int(last) {
            if command == CommandDirections.forward.rawValue {
                position.horizontal += value
            } else if command == CommandDirections.up.rawValue {
                position.vertical -= value
            } else if command == CommandDirections.down.rawValue {
                position.vertical += value
            }
        }
    }
    return position.0 * position.1
}

func solver_2(input: String) -> Int {
    let parsedInput = getParsedStringsFromLinesAndSpaces(from: input)
    var position = (horizontal: 0, vertical: 0), aim = 0
    for line in parsedInput {
        if let command = line.first, let last = line.last, let value = Int(last) {
            if command == CommandDirections.forward.rawValue {
                position.horizontal += value
                position.vertical += aim * value
            } else if command == CommandDirections.up.rawValue {
                aim -= value
            } else if command == CommandDirections.down.rawValue {
                aim += value
            }
        }
    }
    return position.0 * position.1
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
