//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver(input: String, max: Int) -> Int {
    let contents = input.components(separatedBy: "\n\n")
    let string = Array(contents[0])
    let rules = contents[1].trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
    var map = [String: String](), pairCounter = [String: Int](), sum = [Character: Int]()

    // Parse the rules
    for rule in rules {
        let rule = rule.components(separatedBy: " -> ")
        map[rule[0]] = rule[1]
    }

    // Count the initial pairs
    for idx in 0 ..< string.count - 1 {
        pairCounter[String(string[idx ... idx + 1]), default: 0] += 1
    }

    // Update pair counters each round
    for _ in 0 ..< max {
        var newPair = [String: Int]()
        for (pair, occurrence) in pairCounter {
            if let found = map[pair], let first = pair.first, let last = pair.last {
                ["\(first)\(found)", "\(found)\(last)"].forEach { newPair[$0, default: 0] += occurrence }
            }
        }
        pairCounter = newPair
    }

    // Add up occurence
    // Only add the first item to avoid dupes
    for (pair, occurrence) in pairCounter {
        if let first = pair.first {
            sum[first, default: 0] += occurrence
        }
    }
    // Add back the last character so everything is counted
    if let last = string.last {
        sum[last, default: 0] += 1
    }

    // Sort the counter and return the difference of the max & min
    let sorted = sum.sorted { before, after in
        before.value < after.value
    }

    if let less = sorted.first?.value, let more = sorted.last?.value {
        return more - less
    }

    fatalError("Oops, something went wrong.")
}

print(solver(input: getIoFile(for: .question1), max: 10))
print(solver(input: getIoFile(for: .question1), max: 40))
