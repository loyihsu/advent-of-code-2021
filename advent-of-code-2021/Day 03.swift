//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func count(list: [[Character]], row: Int) -> (one: Int, zero: Int) {
    var counter = (one: 0, zero: 0)
    for jdx in list.indices {
        // Count the ones and zeros of the row.
        counter = (list[jdx][row] == "1" ? counter.one + 1 : counter.one,
                   list[jdx][row] == "0" ? counter.zero + 1 : counter.zero)
    }
    return counter
}

func gamma(of list: [[Character]]) -> String {
    var output = ""
    for idx in list[0].indices {
        let count = count(list: list, row: idx)
        // Attach the more common bits
        output += count.one > count.zero ? "1" : "0"
    }
    return output
}

func filter(_ list: [[Character]], most: Bool) -> String {
    var list = list
    for idx in list[0].indices where list.count > 1 {
        let count = count(list: list, row: idx)
        // Get condition by execution mode
        let condition = most ? count.one >= count.zero : count.zero > count.one
        list = list.filter { condition ? $0[idx] == "1" : $0[idx] == "0" }
    }
    return String(list[0])
}

func decimal(of binary: String) -> Int {
    var output = 0
    // Convert binary to decimal with linear complexity
    binary.forEach { output = 2 * output + ($0 == "1" ? 1 : 0) }
    return output
}

func solver_1(input: String) -> Int {
    let list = getPlainStringList(from: input)
        .map { Array($0) }
    let gamma = gamma(of: list)
    // Epsilon is the inverted gamma
    let epsilon = String(gamma.map { $0 == "0" ? "1" : "0" })
    return decimal(of: gamma) * decimal(of: epsilon)
}

func solver_2(input: String) -> Int {
    let list = getPlainStringList(from: input)
        .map { Array($0) }
    let oxygen = filter(list, most: true)
    let co2 = filter(list, most: false)
    return decimal(of: oxygen) * decimal(of: co2)
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
