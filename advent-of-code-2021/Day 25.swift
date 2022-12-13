//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

var width = 0, height = 0

func move(idx: Int, jdx: Int, newMap: inout [[Character]], oldMap: [[Character]]) {
    guard oldMap[idx][jdx] != "." else { return }
    if oldMap[idx][jdx] == ">" {
        if jdx+1 < width {
            if oldMap[idx][jdx+1] == "." {
                (newMap[idx][jdx], newMap[idx][jdx+1]) = (oldMap[idx][jdx+1], oldMap[idx][jdx])
            }
        } else {
            if oldMap[idx][0] == "." {
                (newMap[idx][jdx], newMap[idx][0]) = (oldMap[idx][0], oldMap[idx][jdx])
            }
        }
    } else if oldMap[idx][jdx] == "v" {
        if idx+1 < height {
            if oldMap[idx+1][jdx] == "." {
                (newMap[idx][jdx], newMap[idx+1][jdx]) = (oldMap[idx+1][jdx], oldMap[idx][jdx])
            }
        } else {
            if oldMap[0][jdx] == "." {
                (newMap[idx][jdx], newMap[0][jdx]) = (oldMap[0][jdx], oldMap[idx][jdx])
            }
        }
    }
}

func solver(input: String) -> Int {
    var map = input.trimmingCharacters(in: .newlines).components(separatedBy: .newlines).map({ Array($0) })
    (height, width) = (map.count, map[0].count)

    var counter = 0

    while true {
        let originalMap = map
        var newMap = map
        for idx in 0..<height {
            for jdx in 0..<width {

                if map[idx][jdx] == ">" {
                    move(idx: idx, jdx: jdx, newMap: &newMap, oldMap: map)
                }
            }
        }
        map = newMap
        for idx in 0..<height {
            for jdx in 0..<width {
                if map[idx][jdx] == "v" {
                    move(idx: idx, jdx: jdx, newMap: &newMap, oldMap: map)
                }
            }
        }
        counter += 1
        if originalMap != newMap {
            map = newMap
        } else {
            break
        }
    }
    return counter
}

print(solver(input: getIoFile(for: .question1)))
