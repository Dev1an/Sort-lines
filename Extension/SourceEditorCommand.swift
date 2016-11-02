//
//  SourceEditorCommand.swift
//  Extension
//
//  Created by Damiaan on 01-11-16.
//  Copyright © 2016 Damiaan. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        for selection in invocation.buffer.selections as! [XCSourceTextRange] {
            var lines = invocation.buffer.lines.subarray(with: NSRange(selection.start.line ..< selection.end.line+1)) as! [String]
            let textLineIndices = Set(lines.indices
                .filter { !lines[$0].isWhiteSpace() }
                .map { $0+selection.start.line })
            lines.sort()
            lines.removeFirst(lines.count - textLineIndices.count)
            
            for (relativeIndex, absoluteIndex) in Set(selection.start.line ... selection.end.line).intersection(textLineIndices).sorted().enumerated() {
                invocation.buffer.lines[absoluteIndex] = lines[relativeIndex]
            }
        }

        // Invoke the completion handler when done. Pass it nil on success, and an NSError on failure.
        completionHandler(nil)
    }
    
}

extension String {
    func isWhiteSpace() -> Bool {
        for character in self.unicodeScalars {
            if !CharacterSet.whitespacesAndNewlines.contains(character) {
                return false
            }
        }
        return true
    }
}
