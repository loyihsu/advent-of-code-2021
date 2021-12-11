//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func increaser(grid: inout [[Int]], idx: Int, jdx: Int, visited: inout Set<String>) {
    // Check within grid
    guard idx < grid.count && jdx < grid[0].count else { return }
    guard idx >= 0 && jdx >= 0 else { return }

    grid[idx][jdx] += 1

    // Check need to flash
    guard grid[idx][jdx] >= 10 && !visited.contains("\(idx),\(jdx)") else { return }

    visited.insert("\(idx),\(jdx)")

    let adj = [(idx-1, jdx-1), (idx-1, jdx), (idx-1, jdx+1),
               (idx, jdx-1), (idx, jdx+1),
               (idx+1, jdx-1), (idx+1, jdx), (idx+1, jdx+1)]

    for adj in adj {
        increaser(grid: &grid, idx: adj.0, jdx: adj.1, visited: &visited)
    }
}

func solver_1(input: String, step: Int) -> Int {
    var grid = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .map({ Array($0).compactMap({ Int("\($0)") }) })
    var sum = 0
    for _ in 0..<step {
        var visited = Set([String]())
        for idx in grid.indices {
            for jdx in grid[idx].indices {
                increaser(grid: &grid, idx: idx, jdx: jdx, visited: &visited)
            }
            // Make the flashed ones 0
            for item in visited {
                let pos = item.components(separatedBy: ",").compactMap({ Int($0) })
                grid[pos[0]][pos[1]] = 0
            }
        }
        // Add the flashed count
        sum += visited.count
    }

    return sum
}

func solver_2(input: String) -> Int {
    var idx = 0
    var grid = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .map({ Array($0).compactMap({ Int("\($0)") }) })
    while true {
        var visited = Set([String]())
        for idx in grid.indices {
            for jdx in grid[idx].indices {
                increaser(grid: &grid, idx: idx, jdx: jdx, visited: &visited)
            }
            for item in visited {
                let pos = item.components(separatedBy: ",").compactMap({ Int($0) })
                grid[pos[0]][pos[1]] = 0
            }
        }
        idx += 1
        // Continue doing this until all flashes
        if visited.count == grid.count * grid[0].count {
            break
        }
    }
    return idx
}

print(solver_1(input: getIoFile(for: .question1), step: 100))
print(solver_2(input: getIoFile(for: .question1)))
