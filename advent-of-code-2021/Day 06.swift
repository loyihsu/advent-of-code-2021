//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver(input: String, days: Int) -> Int {
    let list = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: ",")
        .compactMap { Int($0) }
    var book = [Int](repeating: 0, count: 9)
    for item in list {
        book[item + 1] += 1
    }
    for idx in 0 ... days {
        book[(idx + 7) % 9] += book[idx % 9]
    }
    return book.reduce(0, +)
}

print(solver(input: getIoFile(for: .question1), days: 80))
print(solver(input: getIoFile(for: .question1), days: 256))
