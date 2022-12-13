//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func expand(map: [[Int]], by value: Int) -> [[Int]] {
    guard value != 1 else { return map }
    let value = value - 1
    var input = map, res = input
    // Expand horizontally
    for idx in input.indices {
        for enhance in 1 ... value {
            res[idx].append(contentsOf: input[idx].map { ($0 + enhance) % 9 == 0 ? 9 : ($0 + enhance) % 9 })
        }
    }
    input = res
    // Expand vertically
    for enhance in 1 ... value {
        for line in input {
            res.append(line.map { ($0 + enhance) % 9 == 0 ? 9 : ($0 + enhance) % 9 })
        }
    }
    return res
}

func solver(input: String, extend: Int = 1) -> Int {
    var input = input.trimmingCharacters(in: .newlines).components(separatedBy: .newlines).map { Array($0.compactMap(({ Int("\($0)") }))) }
    input = expand(map: input, by: extend)

    var queue = [(position: (x: Int, y: Int), cost: Int)]()
    var costmap = [[Int]](repeating: [Int](repeating: Int.max, count: input[0].count), count: input.count)

    queue.append((position: (x: 0, y: 0), cost: 0))
    costmap[0][0] = 0

    while let last = queue.popLast() {
        // Arrived at the destination
        if last.position.x == input.count - 1, last.position.y == input[0].count - 1 {
            break
        }
        // Go for four directions
        for difference in [(x: -1, y: 0), (x: 0, y: -1), (x: 1, y: 0), (x: 0, y: 1)] {
            let x = last.position.x + difference.x, y = last.position.y + difference.y
            // Skip if not inside ranges
            if !input.indices.contains(x) || !input[0].indices.contains(y) {
                continue
            }
            // Update costmap and append the next points to the traversal queue
            let cost = input[x][y] + last.cost, oldCost = costmap[x][y]
            if oldCost > cost {
                costmap[x][y] = cost
                queue.append((position: (x: x, y: y), cost: cost))
            }
        }
        queue.sort(by: { $0.cost > $1.cost }) // Soft the queue so the items of min cost are at the last item - O(N log N)
    }
    return costmap[costmap.count - 1][costmap[0].count - 1]
}

print(solver(input: getIoFile(for: .question1)))
print(solver(input: getIoFile(for: .question1), extend: 5))
