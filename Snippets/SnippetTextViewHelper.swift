//
//  SnippetTextViewHelper.swift
//  Snippets
//
//  Created by Philip Dow on 2/28/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

/*
Copyright (c) 2016 Philip Dow

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import Cocoa

class SnippetTextViewHelper {
    
    /// The text view being helped
    private let textView: NSTextView
    
    /// The snippets
    var snippets: [Snippet]
    
    /// Tracks the snippet currently responding to tab triggers
    private var currentSnippet: Snippet?
    
    /// Tracks the start index in the text view where the snippet first triggered
    private var startIndex: String.Index?
    
    /// Tracks the field last triggered
    private var fieldIndex: Int = -1
    
    // MARK: - Initialization
    
    /// - parameter textView: unowned reference
    
    init(textView: NSTextView, snippets: [Snippet]) {
        self.textView = textView
        self.snippets = snippets
    }
    
    // MARK: - Core Function
    
    /// Returns true if we were able to insert a snippet or advance to the next field, false otherwise
    func handleTab(affectedCharRange: NSRange, forward: Bool) -> Bool {
        
        guard let string = textView.string else {
            return false
        }
        
        guard let index = string.rangeFromNSRange(affectedCharRange)?.startIndex else { // endIndex
            return false
        }
        
        // If we are already editing a snippet, advance to the next field or the end of the snippet
        // If there is no additional field, reset and let it fall through to another tab trigger
        
        if currentSnippet != nil {
            if let fieldRange = currentSnippet!.rangeForNextField(fromField: fieldIndex, forward: forward, inString: textView.string!, atIndex: startIndex!) {
                textView.setSelectedRange(textView.string!.NSRangeFromRange(fieldRange))
                fieldIndex += forward ? 1 : -1
                return true
            } else {
                currentSnippet = nil
                startIndex = nil
                fieldIndex = -1
            }
        }
        
        // Determine trigger range and string: it's the word up to index at non-alphnumeric boundaries
        
        let (triggerRange, triggerString) = triggerFor(string, index: index)
        
        // Match trigger string to snippet: indexOf with a predicate
        
        guard let snippet = snippetForTrigger(triggerString) else {
            return false
        }
        
        // Note the start of the trigger range for later field matching
        
        startIndex = triggerRange.startIndex
        
        // Replace text in range
        
        let replaced = replaceText(triggerRange, replacementString: snippet.text)
        
        // Advance to the first field or the end of the string if there is none
        
        if let fieldRange = snippet.rangeForNextField(fromField: Snippet.NewSnippetField, forward: forward, inString: textView.string!, atIndex:startIndex!) {
            textView.setSelectedRange(textView.string!.NSRangeFromRange(fieldRange))
            currentSnippet = snippet
            fieldIndex = 1
        } else {
            currentSnippet = nil
            startIndex = nil
            fieldIndex = -1
        }
        
        return replaced
    }
    
    // MARK: - Utilities
    
    /// Returns the trigger word and range from a particular index into a string
    func triggerFor(string: String, index: String.Index) -> (range: Range<String.Index>, string: String) {
        let boundaries = NSCharacterSet.alphanumericCharacterSet().invertedSet
        let searchRange = Range<String.Index>(start: string.startIndex, end: index)
        
        var range = string.rangeOfCharacterFromSet(boundaries, options: .BackwardsSearch, range: searchRange)
        
        if range == nil {
            // Want entire range
            range = Range<String.Index>(start: string.startIndex, end: string.endIndex)
        } else {
            // Advance by one to ignore matched character
            range!.startIndex = range!.startIndex.advancedBy(1)
        }
        
        let triggerRange = Range<String.Index>(start: range!.startIndex, end: searchRange.endIndex)
        let triggerString = string.substringWithRange(triggerRange)
        
        return (triggerRange, triggerString)
    }
    
    /// Utility method to replace text in a text view over a particular range
    func replaceText(range: Range<String.Index>, replacementString: String) -> Bool {
        guard let string = textView.string else {
            return false
        }
        
        guard textView.shouldChangeTextInRange(string.NSRangeFromRange(range), replacementString: replacementString) else {
            return false
        }
        
        textView.textStorage?.beginEditing()
        textView.textStorage?.replaceCharactersInRange(string.NSRangeFromRange(range), withString: replacementString)
        textView.textStorage?.endEditing()
        
        return true
    }
    
    /// Utility method to replace text in a text view over many ranges, currently unused
    func replaceText(ranges: [Range<String.Index>], replacementStrings: [String]) -> Bool {
        guard let string = textView.string else {
            return false
        }
        
        guard ranges.count > 0 && ranges.count == replacementStrings.count else {
            return false
        }
        
        let rangeValues = ranges.map({NSValue(range: string.NSRangeFromRange($0))})
        
        guard textView.shouldChangeTextInRanges(rangeValues, replacementStrings: replacementStrings) else {
            return false
        }
        
        textView.textStorage?.beginEditing()
        textView.textStorage?.replaceCharactersInRanges(ranges, withStrings: replacementStrings)
        textView.textStorage?.endEditing()
        
        return false
    }
    
    /// Identifies the snippet for a trigger word
    func snippetForTrigger(triggerString: String) -> Snippet? {
        if let i = snippets.indexOf({$0.tabTrigger == triggerString}) {
            return snippets[i]
        } else {
            return nil
        }
    }

}