//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

/// The winner checker for either horizontal or vertical bingo.
func checkWin(_ board: [[(String, Bool)]]) -> Bool {
    for idx in board.indices {
        if board[idx].map({ $0.1 }).filter({ $0 == true }).count == 5 {
            return true
        }
        if board.map({ $0[idx].1 }).filter({ $0 == true }).count == 5 {
            return true
        }
    }
    return false
}

/// Summing all the unmarked items on the board.
func sumAllUnmarked(_ board: [[(String, Bool)]]) -> Int {
    var sum = 0
    for idx in board.indices {
        for jdx in board[idx].indices where board[idx][jdx].1 == false {
            sum += Int(board[idx][jdx].0)!
        }
    }
    return sum
}

/// Quickly getting the call list and bingo boards.
func getCallListAndBoards(from input: String) -> ([String], [[[(String, Bool)]]]) {
    let partitions = input.components(separatedBy: "\n\n")
    let callList = partitions[0].components(separatedBy: ",")
    let boards = partitions[1...].map({
        $0.components(separatedBy: .newlines)
            .map({ $0.components(separatedBy: .whitespaces).map({ ($0, false) }).filter({ !$0.0.isEmpty }) })
            .filter({ !$0.isEmpty })
    })
    return (callList, boards)
}

func solver_1(input: String) -> Int? {
    var (callList, boards) = getCallListAndBoards(from: input)
    for call in callList {
        for board in boards.indices {
            // Marking the called number
            for line in boards[board].indices {
                if let idx = boards[board][line].firstIndex(where: { $0.0 == call }) {
                    boards[board][line][idx].1 = true
                    break
                }
            }
            if checkWin(boards[board]) {
                return sumAllUnmarked(boards[board]) * Int(call)!
            }
        }
    }
    return nil
}

func solver_2(input: String) -> Int? {
    var (callList, boards) =  getCallListAndBoards(from: input)
    var boardCompletion = [Bool](repeating: false, count: boards.count)
    for call in callList {
        for board in boards.indices {
            // Marking the called number
            for line in boards[board].indices {
                if let idx = boards[board][line].firstIndex(where: { $0.0 == call }) {
                    boards[board][line][idx].1 = true
                    break
                }
            }
            if checkWin(boards[board]) {
                boardCompletion[board] = true
                if !boardCompletion.contains(false) {
                    return sumAllUnmarked(boards[board]) * Int(call)!
                }
            }
        }
    }
    return nil
}

print(solver_1(input: getIoFile(for: .question1)) ?? 0)
print(solver_2(input: getIoFile(for: .question1)) ?? 0)
