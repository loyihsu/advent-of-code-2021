//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

// I worked out the results with help from https://www.reddit.com/r/adventofcode/comments/rnejv5/2021_day_24_solutions/ by hand
// The following codes are only used for checking the results are correct.

let commands = getIoFile(for: .question1).trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

class ALU {
    private var w = 0, x = 0, y = 0, z = 0
    private var register = 0
    let _input: Int
    var input: [Int]
    init(input: Int) {
        self.input = "\(input)".compactMap { Int("\($0)") }.reversed()
        _input = input
    }

    private func read(from selector: String) -> Int {
        switch selector {
        case "w":
            return w
        case "x":
            return x
        case "y":
            return y
        case "z":
            return z
        case "register":
            return register
        default:
            return -1
        }
    }

    private func write(value: Int, to selector: String) {
        switch selector {
        case "w":
            w = value
        case "x":
            x = value
        case "y":
            y = value
        case "z":
            z = value
        case "register":
            register = value
        default:
            break
        }
    }

    func inp(_ a: String) {
        write(value: input.removeLast(), to: a)
    }

    func add(_ a: String, _ b: String) {
        write(value: read(from: a) + read(from: b), to: a)
    }

    func mul(_ a: String, _ b: String) {
        write(value: read(from: a) * read(from: b), to: a)
    }

    func div(_ a: String, _ b: String) {
        write(value: read(from: a) / read(from: b), to: a)
    }

    func mod(_ a: String, _ b: String) {
        write(value: read(from: a) % read(from: b), to: a)
    }

    func eql(_ a: String, _ b: String) {
        write(value: read(from: a) == read(from: b) ? 1 : 0, to: a)
    }

    func run() -> Int? {
        for command in commands {
            let segments = command.components(separatedBy: .whitespaces)
            if segments[0] == "inp" {
                inp(segments[1])
            } else if segments[0] == "add" {
                if let b = Int(segments[2]) {
                    register = b
                    add(segments[1], "register")
                } else {
                    add(segments[1], segments[2])
                }
            } else if segments[0] == "mul" {
                if let b = Int(segments[2]) {
                    register = b
                    mul(segments[1], "register")
                } else {
                    mul(segments[1], segments[2])
                }
            } else if segments[0] == "div" {
                if let b = Int(segments[2]) {
                    register = b
                    div(segments[1], "register")
                } else {
                    div(segments[1], segments[2])
                }
            } else if segments[0] == "mod" {
                if let b = Int(segments[2]) {
                    register = b
                    mod(segments[1], "register")
                } else {
                    mod(segments[1], segments[2])
                }
            } else if segments[0] == "eql" {
                if let b = Int(segments[2]) {
                    register = b
                    eql(segments[1], "register")
                } else {
                    eql(segments[1], segments[2])
                }
            }
        }
        return z == 0 ? _input : nil
    }
}

let part1 = ALU(input: 91_897_399_498_995)
if let result = part1.run() {
    print(result)
}

let part2 = ALU(input: 51_121_176_121_391)
if let result = part2.run() {
    print(result)
}
