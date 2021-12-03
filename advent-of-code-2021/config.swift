//
//  config.swift
//  advent-of-code-2021
//
//  Created by Loyi Hsu on 2021/12/1.
//

import Foundation

let desktopPath = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.absoluteString
let projectPath = "\(desktopPath)advent-of-code-2021/"
let foldername = "advent-of-code-2021/io/"

enum Selector: String {
    case question1 = "question1-input.io", question2 = "question2-input.io", sample = "sample-input.io"
}

func getIoFile(for selector: Selector) -> String {
    guard let url = URL(string: "\(projectPath)\(foldername)\(selector.rawValue)") else {
        return ""
    }
    guard let content = try? String(contentsOf: url) else {
        return ""
    }
    return content
}

/// Quickly create integer list from the input file.
func getIntegerList(from input: String) -> [Int] {
    return input.components(separatedBy: .newlines)
        .filter({ !$0.isEmpty })
        .map { Int($0)! }
}

/// The input will be separated into lines, and each line will be further parsed into a String array separated by spaces.
func getParsedStringsFromLinesAndSpaces(from input: String) -> [[String]] {
    let lines = input.components(separatedBy: .newlines)
    return lines.map {
        $0.components(separatedBy: .whitespaces)
    }
}

// Get the input in plain text list form.
func getPlainStringList(from input: String) -> [String] {
    return input.components(separatedBy: .newlines)
        .filter({!$0.isEmpty })
}
