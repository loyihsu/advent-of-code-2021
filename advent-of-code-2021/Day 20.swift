//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver(input: String, roundNumber: Int) -> Int {
    let sections = input.trimmingCharacters(in: .newlines).components(separatedBy: "\n\n")
    let improvementAlgorithm = Array(sections[0].map({ $0 == "#" }))
    var image = sections[1].components(separatedBy: .newlines).map({ Array($0.map({ $0 == "#" })) })
    var output = 0
    for round in 0..<roundNumber {
        var temp = [[Bool]](repeating: [Bool](repeating: false, count: image[0].count+2), count: image.count+2)
        for idx in -1..<image.count+1 {
            for jdx in -1..<image[0].count+1 {
                let range = (x: idx-1...idx+1, y: jdx-1...jdx+1)
                var value = 0
                for xdx in range.x {
                    for ydx in range.y {
                        var current = improvementAlgorithm[0] && round % 2 == 0 ? improvementAlgorithm[511] : improvementAlgorithm[0]
                        if image.indices.contains(xdx) && image[0].indices.contains(ydx) {
                            current = image[xdx][ydx]
                        }
                        value = value * 2 + (current ? 1 : 0)
                    }
                }
                temp[idx+1][jdx+1] = improvementAlgorithm[value]
            }
        }
        image = temp
    }
    for line in image {
        output += line.filter({ $0 }).count
    }
    return output
}

print(solver(input: getIoFile(for: .question1), roundNumber: 2))
print(solver(input: getIoFile(for: .question1), roundNumber: 50))
