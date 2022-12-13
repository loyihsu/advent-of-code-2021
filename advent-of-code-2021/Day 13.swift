//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver(input: String) -> Int {
    let input = input.components(separatedBy: "\n\n")
    var maxWidth = 0, maxHeight = 0
    var counter: Int?
    let dots = input[0].components(separatedBy: .newlines).map { input -> (Int, Int) in
        let list = input.components(separatedBy: ",").compactMap { item in Int(item) }
        maxWidth = max(list[0], maxWidth)
        maxHeight = max(list[1], maxHeight)
        return (list[0], list[1])
    }
    let instructions = input[1].trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
    var map = [[Bool]](repeating: [Bool](repeating: false, count: maxWidth + 1), count: maxHeight + 1)

    for dot in dots {
        map[dot.1][dot.0] = true
    }

    for instruction in instructions {
        if let hor = Int(instruction.components(separatedBy: "fold along y=").last!) {
            var newMap = [[Bool]](repeating: [Bool](repeating: false, count: map[0].count), count: hor)
            for idx in map.indices {
                let newIdx = idx >= hor ? 2 * hor - idx : idx
                for jdx in map[idx].indices {
                    if map[idx][jdx] == true {
                        newMap[newIdx][jdx] = true
                    }
                }
            }
            map = newMap
        }
        if let ver = Int(instruction.components(separatedBy: "fold along x=").last!) {
            var newMap = [[Bool]](repeating: [Bool](repeating: false, count: ver), count: map.count)
            for idx in map.indices {
                for jdx in map[idx].indices {
                    let newJdx = jdx >= ver ? 2 * ver - jdx : jdx
                    if map[idx][jdx] == true {
                        newMap[idx][newJdx] = true
                    }
                }
            }
            map = newMap
        }
        var temp = 0
        for map in map {
            for item in map {
                if item == true {
                    print("#", terminator: "")
                    temp += 1
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }
        if counter == nil {
            counter = temp
        }
        print("")
    }

    return counter ?? 0
}

print(solver(input: getIoFile(for: .question1)))
