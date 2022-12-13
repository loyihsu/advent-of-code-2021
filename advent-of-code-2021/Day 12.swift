//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func count(in path: [String], value: String) -> Int {
    return path.filter({ $0 == value }).count
}

func solver(input: String, smallCount: Int) -> Int {
    let lines = getPlainStringList(from: input)
    var router = [String: Set<String>]()
    var success = [[String]](), paths = [([String], String)]()
    for line in lines {
        let path = line.components(separatedBy: "-")
        if let source = path.first, let destination = path.last {
            router[source, default: []].insert(destination)
            router[destination, default: []].insert(source)
        }
    }
    paths.append((["start"], ""))
    while let path = paths.popLast(), let last = path.0.last {
        if last == "end" {
            success.append(path.0)
            continue
        }
        if let steps = router[last] {
            for possibility in steps where possibility != "start" {
                let count = path.0.filter({ $0 == possibility }).count
                let uppercased = possibility == possibility.uppercased()
                let beforeDupes = path.1.isEmpty && count < smallCount
                let otherThanDupes = !path.1.isEmpty && path.1 != possibility && count < 1
                if uppercased || beforeDupes || otherThanDupes {
                    var temp = path
                    temp.0.append(possibility)
                    if !uppercased && temp.0.filter({ $0 == possibility }).count == smallCount {
                        temp.1 = possibility
                    }
                    paths.append(temp)
                }
            }
        }
    }
    return success.count
}

print(solver(input: getIoFile(for: .question1), smallCount: 1))
print(solver(input: getIoFile(for: .question1), smallCount: 2))
