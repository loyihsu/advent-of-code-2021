//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func handler(for input: String) -> [[(Int, Int)]] {
    getPlainStringList(from: input)
        .map({
            $0.components(separatedBy: " -> ")
                .map({ item -> (x: Int, y: Int) in
                    let separated = item.components(separatedBy: ",")
                        .compactMap({ Int($0) })
                    return (separated[0], separated[1])
                })
        })
}

func createBook(_ lines: [[(x: Int, y: Int)]], diagonal: Bool = false) -> [String: Int] {
    var book = [String: Int]()
    for line in lines {
        // Check for horizontal and vertical lines
        let horOrVerCheck = line[0].x == line[1].x || line[0].y == line[1].y
        // Check for diagnal lines
        let diagonalCheck = abs(line[0].x - line[1].x) == abs(line[0].y - line[1].y)
        // Pick condition by execution mode
        let condition = diagonal ? horOrVerCheck || diagonalCheck : horOrVerCheck
        if condition {
            // List all the points' x and y position
            var xrange = Array(min(line[0].x, line[1].x)...max(line[0].x, line[1].x))
            var yrange = Array(min(line[0].y, line[1].y)...max(line[0].y, line[1].y))
            // Correct them if the line is reversed (for diagonal especially)
            xrange = line[0].x > line[1].x ? xrange.reversed() : xrange
            yrange = line[0].y > line[1].y ? yrange.reversed() : yrange
            // Get the range of the line (for non diagonal especially)
            let range = xrange.count < yrange.count ? yrange.indices : xrange.indices
            for idx in range {
                // If the line is not diagonal, the position is handled here.
                let (xpos, ypos) = (xrange.count == 1 ? 0 : idx, yrange.count == 1 ? 0 : idx)
                book["(\(xrange[xpos]),\(yrange[ypos]))", default: 0] += 1
            }
        }
    }
    return book
}

func solver_1(input: String) -> Int {
    createBook(handler(for: input))
        .filter({ $1 >= 2 })
        .count
}

func solver_2(input: String) -> Int {
    createBook(handler(for: input), diagonal: true)
        .filter({ $1 >= 2 })
        .count
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
