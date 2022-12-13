//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

// This shared solution is referenced when doing part 2 of this puzzle: https://www.reddit.com/r/adventofcode/comments/rl6p8y/2021_day_21_solutions/hpebyzq/?utm_source=reddit&utm_medium=web2x&context=3

func solver_1(input: String) -> Int {
    let lines = input.components(separatedBy: .newlines)
    var positions = (one: 0, two: 0), die = 1, scores = (one: 0, two: 0), counter = 0
    for line in lines {
        if let rawPos = line.components(separatedBy: "Player 1 starting position: ").last, let pos = Int(rawPos) {
            positions.one = pos - 1
        } else if let rawPos = line.components(separatedBy: "Player 2 starting position: ").last, let pos = Int(rawPos) {
            positions.two = pos - 1
        }
    }
    while scores.one < 1000, scores.two < 1000 {
        for round in 0 ... 1 where scores.one < 1000 && scores.two < 1000 {
            counter += 1
            let dieRow = (die ... die + 2).map { $0 % 100 }.reduce(0, +)
            die = (die + 3) % 100
            if round == 0 {
                positions.one = (positions.one + dieRow) % 10
                scores.one += positions.one + 1
            } else {
                positions.two = (positions.two + dieRow) % 10
                scores.two += positions.two + 1
            }
        }
    }
    return min(scores.one, scores.two) * counter * 3
}

func expand(positions: (one: Int, two: Int), scores: (one: Int, two: Int), turn: Bool, value: Int) -> (Int, Int) {
    var newPositions = positions, newScores = scores
    if !turn {
        newPositions = ((positions.one + value) % 10, positions.two)
        newScores = (scores.one + newPositions.one + 1, scores.two)
    } else {
        newPositions = (positions.one, (positions.two + value) % 10)
        newScores = (scores.one, scores.two + newPositions.two + 1)
    }
    if newScores.one >= 21 || newScores.two >= 21 {
        return (newScores.one > newScores.two ? 1 : 0, newScores.two > newScores.one ? 1 : 0)
    }
    return forker(positions: newPositions, scores: newScores, turn: !turn)
}

func forker(positions: (one: Int, two: Int), scores: (one: Int, two: Int), turn: Bool) -> (Int, Int) {
    var sum = (0, 0)
    let resultWeight = [3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1] // Count possibilities of each roll combination
    for roll in resultWeight.keys {
        let res = expand(positions: positions, scores: scores, turn: turn, value: roll)
        sum = (sum.0 + res.0 * resultWeight[roll, default: 1], sum.1 + res.1 * resultWeight[roll, default: 1])
    }
    return sum
}

func solver_2(input: String) -> Int {
    let lines = input.components(separatedBy: .newlines)
    var positions = (one: 0, two: 0), scores = (one: 0, two: 0)
    for line in lines {
        if let rawPos = line.components(separatedBy: "Player 1 starting position: ").last, let pos = Int(rawPos) {
            positions.one = pos - 1
        } else if let rawPos = line.components(separatedBy: "Player 2 starting position: ").last, let pos = Int(rawPos) {
            positions.two = pos - 1
        }
    }
    let res = forker(positions: positions, scores: scores, turn: false)
    return max(res.0, res.1)
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
