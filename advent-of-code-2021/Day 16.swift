//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

extension String {
    mutating func cutPartialString(range: Range<Int>) -> String {
        let range = index(startIndex, offsetBy: range.lowerBound) ..< index(startIndex, offsetBy: range.upperBound)
        let temp = String(self[range])
        removeSubrange(range)
        return temp
    }
}

func hexToBinary(_ hex: String) -> String {
    let converter = "0 = 0000,1 = 0001,2 = 0010,3 = 0011,4 = 0100,5 = 0101,6 = 0110,7 = 0111,8 = 1000,9 = 1001,A = 1010,B = 1011,C = 1100,D = 1101,E = 1110,F = 1111"
    var mapper = [String: String](), output = ""
    let lines = converter.components(separatedBy: ",").map { $0.components(separatedBy: " = ") }
    for line in lines {
        mapper[line[0]] = line[1]
    }
    for char in hex {
        output += mapper[String(char), default: ""]
    }
    return output
}

func binaryConverter(_ value: String) -> Int {
    var output = 0
    for char in value {
        output = output * 2 + (char == "1" ? 1 : 0)
    }
    return output
}

func binaryProcessor(input: inout String, sum: inout Int) -> Int {
    let version = binaryConverter("0\(input.cutPartialString(range: 0 ..< 3))")
    let typeId = binaryConverter("0\(input.cutPartialString(range: 0 ..< 3))")
    sum += version
    return typeId == 4 ? binaryLiteral(input: &input) : binaryOperator(input: &input, typeId: typeId, sum: &sum)
}

func binaryLiteral(input: inout String) -> Int {
    var temp = "", last = false
    while !last {
        if let first = input.first, first == "0" {
            last = true
        }
        var item = input.cutPartialString(range: 0 ..< 5)
        _ = item.removeFirst()
        temp.append(contentsOf: item)
    }
    return binaryConverter(temp)
}

func binaryOperator(input: inout String, typeId: Int, sum: inout Int) -> Int {
    var found = [Int](), result = 0
    if let lengthId = input.first {
        input.removeFirst()
        if lengthId == "0" {
            let length = binaryConverter(String(input.cutPartialString(range: 0 ..< 15)))
            var subpackets = input.cutPartialString(range: 0 ..< length)
            while !subpackets.isEmpty {
                found.append(binaryProcessor(input: &subpackets, sum: &sum))
            }
        } else if lengthId == "1" {
            let length = binaryConverter(String(input.cutPartialString(range: 0 ..< 11)))
            for _ in 0 ..< length {
                found.append(binaryProcessor(input: &input, sum: &sum))
            }
        }
        if typeId == 0 {
            result = found.reduce(0, +)
        } else if typeId == 1 {
            result = found.reduce(1, *)
        } else if typeId == 2 {
            result = found.min() ?? 0
        } else if typeId == 3 {
            result = found.max() ?? 0
        } else if typeId == 5 {
            result = found[0] > found[1] ? 1 : 0
        } else if typeId == 6 {
            result = found[0] < found[1] ? 1 : 0
        } else if typeId == 7 {
            result = found[0] == found[1] ? 1 : 0
        }
    }
    return result
}

func solver(input: String) -> (Int, Int) {
    var sum = 0, binary = hexToBinary(input)
    let result = binaryProcessor(input: &binary, sum: &sum)
    return (sum, result)
}

print(solver(input: getIoFile(for: .question1)))
