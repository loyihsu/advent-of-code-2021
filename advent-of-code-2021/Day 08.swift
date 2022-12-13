//
//  main.swift
//  advent-of-code-2021
//
//  Created by Yu-Sung Loyi Hsu on 01/12/2021.
//

import Foundation

func returnObvious(_ string: String) -> Int? {
    if string.count == 2 {
        return 1
    } else if string.count == 3 {
        return 7
    } else if string.count == 4 {
        return 4
    } else if string.count == 7 {
        return 8
    }
    return nil
}

func solver_1(input: String) -> Int {
    input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .compactMap { $0.components(separatedBy: " | ").last }
        .map { item -> Int in
            item.components(separatedBy: .whitespaces)
                .filter { returnObvious($0) != nil }
                .count
        }
        .reduce(0, +)
}

func solver_2(input: String) -> Int {
    let lists = input.trimmingCharacters(in: .newlines)
        .components(separatedBy: .newlines)
        .compactMap {
            $0.components(separatedBy: " | ")
        }

    var output = 0

    for list in lists {
        if let first = list.first, let last = list.last {
            let array = first.components(separatedBy: .whitespaces)
            var translate = [String: Int](), temp = 0
            var translator = array.map { item -> (String, Int?) in
                if let obvious = returnObvious(item) {
                    return (item, obvious)
                } else if item.count == 5 {
                    if let one = first.components(separatedBy: .whitespaces).first(where: { $0.count == 2 }) {
                        if one.filter({ item.contains($0) }).count == 2 {
                            return (item, 3)
                        }
                    }
                    return (item, nil)
                } else if item.count == 6 {
                    if let one = first.components(separatedBy: .whitespaces).first(where: { $0.count == 2 }) {
                        if one.filter({ item.contains($0) }).count != 2 {
                            return (item, 6)
                        }
                    }
                    if let four = first.components(separatedBy: .whitespaces).first(where: { $0.count == 4 }) {
                        if four.filter({ item.contains($0) }).count == 4 {
                            return (item, 9)
                        }
                    }
                    return (item, 0)
                } else {
                    return (item, nil)
                }
            }
            if let six = translator.first(where: { $1 == 6 }) {
                for item in translator.filter({ $0.1 == nil }) {
                    if item.0.filter({ six.0.contains($0) }).count == 5,
                       let idx = translator.firstIndex(where: { item.0 == $0.0 })
                    {
                        translator[idx].1 = 5
                    } else if let idx = translator.firstIndex(where: { item.0 == $0.0 }) {
                        translator[idx].1 = 2
                    }
                }
            }
            for (str, translation) in translator.map({ ($0.0, $0.1!) }) {
                translate[String(str.sorted())] = translation
            }
            for item in last.components(separatedBy: .whitespaces) {
                temp = temp * 10 + (translate[String(item.sorted())] ?? 0)
            }
            output += temp
        }
    }
    return output
}

print(solver_1(input: getIoFile(for: .question1)))
print(solver_2(input: getIoFile(for: .question1)))
