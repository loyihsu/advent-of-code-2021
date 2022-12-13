//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver(input: String, question2: Bool = false) -> Int {
    let list = getIntegerList(from: input.trimmingCharacters(in: .newlines), separator: ",")
    var min = Int.max
    if let left = list.min(), let right = list.max() {
        for destination in left ... right {
            var tmp = 0
            for item in list {
                let distance = abs(item - destination)
                // Select formula by mode
                tmp += question2 ? (1 + distance) * distance / 2 : abs(item - destination)
            }
            min = tmp < min ? tmp : min
        }
    }
    return min
}

print(solver(input: getIoFile(for: .question1)))
print(solver(input: getIoFile(for: .question1), question2: true))
