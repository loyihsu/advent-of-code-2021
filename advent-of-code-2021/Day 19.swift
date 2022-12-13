//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

// This solution references this shared solution: https://www.reddit.com/r/adventofcode/comments/rjpf7f/2021_day_19_solutions/hp51bza/

import Foundation
import os.log

func hash(for value: [Int]) -> Int {
    return value[0] * 10000 + value[1] * 100 + value[2]
}

func hash(for value: (Int, Int)) -> Int {
    return value.0 * 1000 + value.1
}

func hash(for value: (Int, Int, Int)) -> Int {
    return value.0 * 1_000_000 + value.1 * 1000 + value.2
}

let negations = [(1, 1, 1), (1, 1, -1), (1, -1, 1), (-1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1), (-1, -1, -1)]
let remaps = [(0, 1, 2), (1, 0, 2), (1, 2, 0), (0, 2, 1), (2, 0, 1), (2, 1, 0)]

func apply(negation: (Int, Int, Int), remap: (Int, Int, Int), to points: [[Int]]) -> [[Int]] {
    return points.map { point in
        [point[remap.0] * negation.0, point[remap.1] * negation.1, point[remap.2] * negation.2]
    }
}

var locations = [(0, 0, 0)] // For part 2
func find_alignment(this: [[Int]], another: [[Int]]) -> [[Int]]? {
    let insides = Set(this.map { hash(for: $0) })
    for remap in remaps {
        for negation in negations {
            let first = this, second = apply(negation: negation, remap: remap, to: another)
            for firstItem in first {
                for secondItem in second {
                    let temp = [secondItem[0] - firstItem[0], secondItem[1] - firstItem[1], secondItem[2] - firstItem[2]]
                    var matches = 0, all_remapped = [[Int]]()
                    for others in second {
                        let remapped = [others[0] - temp[0], others[1] - temp[1], others[2] - temp[2]]
                        if insides.contains(hash(for: remapped)) {
                            matches += 1
                        }
                        all_remapped.append(remapped)
                    }
                    if matches >= 12 {
                        locations.append((temp[0], temp[1], temp[2]))
                        return all_remapped
                    }
                }
            }
        }
    }
    return nil
}

func solver_1(input: String) -> Int {
    var scanners = input.trimmingCharacters(in: .newlines).components(separatedBy: "\n\n")
        .map { line in
            line.components(separatedBy: .newlines).map { item in
                item.components(separatedBy: ",").compactMap { value in
                    Int(value)
                }
            }
        }
    for idx in scanners.indices {
        scanners[idx].removeFirst()
    }
    var noalign = Set<Int>()
    var aligned: [Int: [[Int]]] = [:]
    aligned[0] = scanners[0]
    var all_aligned: Set<Int> = []

    // Scanner 0 is considered all aligned by default.
    for item in scanners[0] {
        all_aligned.insert(hash(for: (item[0], item[1], item[2])))
    }

    while aligned.count < scanners.count {
        for idx in scanners.indices where !aligned.keys.contains(idx) {
            for jdx in aligned.keys where !noalign.contains(hash(for: (idx, jdx))) {
                os_log("Exploring idx: \(idx) jdx: \(jdx) (\(aligned.keys.count)/\(scanners.count))")
                if let remap = find_alignment(this: aligned[jdx, default: []], another: scanners[idx]) {
                    aligned[idx] = remap
                    for item in remap {
                        all_aligned.insert(hash(for: (item[0], item[1], item[2])))
                    }
                    break
                }
                noalign.insert(hash(for: (idx, jdx)))
            }
        }
    }
    return all_aligned.count
}

func solver_2() -> Int {
    var distance = [Int]()
    for idx in locations.indices {
        for jdx in locations.indices where idx != jdx {
            let first = locations[idx], second = locations[jdx]
            distance.append(abs(first.0 - second.0) + abs(first.1 - second.1) + abs(first.2 - second.2))
        }
    }
    return distance.max() ?? 0
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2())
