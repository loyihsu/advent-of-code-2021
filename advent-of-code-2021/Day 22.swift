//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation
import os.log

// This shared solution is referenced when solving this puzzle: https://github.com/arjanIng/advent2021/blob/main/src/advent/Day22.java

class Cube {
    var x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>, _mode: Int
    var mode: Bool { _mode == 1 }
    init(x: ClosedRange<Int>, y: ClosedRange<Int>, z: ClosedRange<Int>, mode: Bool) {
        (self.x, self.y, self.z, _mode) = (x, y, z, mode ? 1 : -1)
    }

    func intersection(with cube: Cube, isOn: Bool) -> Cube? {
        if x.overlaps(cube.x), y.overlaps(cube.y), z.overlaps(cube.z) {
            return Cube(x: max(x.lowerBound, cube.x.lowerBound) ... min(x.upperBound, cube.x.upperBound),
                        y: max(y.lowerBound, cube.y.lowerBound) ... min(y.upperBound, cube.y.upperBound),
                        z: max(z.lowerBound, cube.z.lowerBound) ... min(z.upperBound, cube.z.upperBound), mode: isOn)
        }
        return nil
    }
}

func solver(input: String, part2: Bool = false) -> Int {
    let lines = input.trimmingCharacters(in: .newlines).components(separatedBy: .newlines)
    var cubes = [Cube]()
    for idx in lines.indices {
        let line = lines[idx]
        let command = line.components(separatedBy: .whitespaces)
        let mode = command.first! == "on"
        let ranges = command.last!.components(separatedBy: ",").map { $0[$0.index($0.startIndex, offsetBy: 2)...].components(separatedBy: "..").compactMap { Int($0) } }
        // Part 1 is limited to -50 ~ 50, while Part 2 is not
        let xlowerbound = part2 ? ranges[0][0] : max(ranges[0][0], -50), xupperbound = part2 ? ranges[0][1] : min(ranges[0][1], 50)
        let ylowerbound = part2 ? ranges[1][0] : max(ranges[1][0], -50), yupperbound = part2 ? ranges[1][1] : min(ranges[1][1], 50)
        let zlowerbound = part2 ? ranges[2][0] : max(ranges[2][0], -50), zupperbound = part2 ? ranges[2][1] : min(ranges[2][1], 50)
        if xlowerbound <= xupperbound, ylowerbound <= yupperbound, zlowerbound <= zupperbound {
            let newCube = Cube(x: xlowerbound ... xupperbound, y: ylowerbound ... yupperbound, z: zlowerbound ... zupperbound, mode: mode)
            for cube in cubes {
                // If signal is to turn on: Cancel out the values of previous intersections to prevent duplicates.
                // If signal is to turn off: Only dim the ones that was lighted
                if let intersection = cube.intersection(with: newCube, isOn: !cube.mode) {
                    cubes.append(intersection)
                }
            }
            // Add the new ones after the intersection is resolved.
            if mode {
                cubes.append(newCube)
            }
        }
    }
    return cubes.map { cube -> Int in
        (cube.x.upperBound - cube.x.lowerBound + 1) * (cube.y.upperBound - cube.y.lowerBound + 1) * (cube.z.upperBound - cube.z.lowerBound + 1) * cube._mode
    }.reduce(0, +)
}

print(solver(input: getIoFile(for: .question1)))
print(solver(input: getIoFile(for: .question1), part2: true))
