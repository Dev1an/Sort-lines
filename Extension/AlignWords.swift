//
//  AlignWords.swift
//  Sort Lines
//
//  Created by Damiaan on 06-11-16.
//  Copyright © 2016 Damiaan. All rights reserved.
//

import Foundation
import XcodeKit

class AlignWords: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        for selection in invocation.buffer.selections as! [XCSourceTextRange] {
            let lines = invocation.buffer.lines.subarray(with: NSRange(selection.start.line ..< selection.end.line+1)) as! [String]
            
            let wordsPerLine = lines.map { line -> [String] in
                var words = line.components(separatedBy: .whitespaces).filter {$0.characters.count != 0}
                if let leadingSpaceEndIndex = line.unicodeScalars.index(where: { !CharacterSet.whitespaces.contains($0) }) {
                    let leadingScalars = line.unicodeScalars[line.unicodeScalars.startIndex..<leadingSpaceEndIndex]
                    words[0].insert(contentsOf: leadingScalars.map {Character($0)}, at: words[0].startIndex)
                }
                return words
            }
            var maxWordLengts = [Int]()
            
            for words in wordsPerLine {
                for (wordNumber, word) in words.enumerated() {
                    var wordLength = word.characters.count
                    if wordNumber == 0 {
                        wordLength += word.characters.filter { $0 == Character("\t") }.count * invocation.buffer.tabWidth
                    }
                    if wordNumber < maxWordLengts.count {
                        maxWordLengts[wordNumber] = max(wordLength, maxWordLengts[wordNumber])
                    } else {
                        maxWordLengts.append(wordLength)
                    }
                }
            }
            
            for (lineNumber, words) in wordsPerLine.enumerated() {
                invocation.buffer.lines[lineNumber+selection.start.line] = words.dropFirst().enumerated().reduce(words.first ?? "") { text, next in
                    var newText = text
                    newText.append(contentsOf: Array(repeating: Character(" "), count: maxWordLengts[next.offset] - words[next.offset].characters.count + 1))
                    newText.append(contentsOf: next.element.characters)
                    return newText
                }
            }
        }
        
        completionHandler(nil)
    }
}
