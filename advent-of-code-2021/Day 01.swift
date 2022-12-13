//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver_1(input: String) -> Int {
    let numbers = getIntegerList(from: input)
    var output = 0
    // Compare with the previous item. (Therefore idx cannot be 0)
    for idx in numbers.indices where idx > 0 {
        if numbers[idx] > numbers[idx-1] {
            output += 1
        }
    }
    return output
}

func solver_2(input: String) -> Int {
    let numbers = getIntegerList(from: input)
    var prev: Int? = nil        // Use nil as signal for the first item.
    var output = 0

    for idx in numbers.indices where idx >= 2 {
        let sliderSum = numbers[idx-2...idx].reduce(0, +)   // Slider sum
        // If not the first item, compare with the previous slider sum.
        if let prev = prev, sliderSum > prev {
            output += 1
        }
        // Update the previous slider sum.
        prev = sliderSum
    }
    return output
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
