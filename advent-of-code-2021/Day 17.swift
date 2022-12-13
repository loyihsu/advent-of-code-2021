//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func solver(input: String) -> (Int, Int) {
    let area = input.trimmingCharacters(in: .newlines).components(separatedBy: "target area: ").joined().components(separatedBy: ", ")
        .compactMap({ $0.components(separatedBy: "=").last })
        .compactMap({ $0.components(separatedBy:"..") .compactMap({ Int($0) }) })
    let targetArea = (x: area[0][0]...area[0][1], y: area[1][0]...area[1][1])
    var max = Int.min, counter = 0

    for x in 1...(targetArea.x.upperBound * 2) {
        for y in (targetArea.y.lowerBound * 2)...(-targetArea.y.upperBound * 2) {
            var highestY = Int.min, velocity = (x: x, y: y), point = (x: 0, y: 0)
            while point.x <= targetArea.x.upperBound && point.y >= targetArea.y.lowerBound {
                point = (point.x + velocity.x, point.y + velocity.y)
                highestY = point.y > highestY ? point.y : highestY      // Update local max
                // Update velocity
                velocity.x = velocity.x - 1 <= 0 ? 0 : velocity.x - 1
                velocity.y = velocity.y - 1
                if targetArea.x.contains(point.x) && targetArea.y.contains(point.y) {
                    max = highestY > max ? highestY : max   // Update global max
                    counter += 1                            // Count distinct velocity that falls into the target area
                    break
                }
            }
        }
    }
    return (max, counter)
}

print(solver(input: getIoFile(for: .question1)))
