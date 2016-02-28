//
//  Snippet.swift
//  Snippets
//
//  Created by Philip Dow on 2/27/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Foundation

class Snippet {
    
    /// The content of the snippet, including field markets, placeholders, etc...
    private(set) var content: String
    
    /// The text which triggers the snippet on a tab
    private(set) var tabTrigger: String?
    
    /// User provided description of the snippet
    var description: String?
    
    /// Unused
    private(set) var scope: String? = nil
    
    /// The user facing version of the content without field markers
    private(set) var text: String
    
    /// The number of fields in the snippet: is this actually needed?
    private var fieldCount: Int = 0
    
    /// Initialize a snippet without a tab trigger
    init(content: String) {
        self.content = content
        self.text = content
    }
    
    /// Fully initialize a snippet
    init(content: String, tabTrigger: String?, scope: String?, description: String?) {
        self.content = content
        self.tabTrigger = tabTrigger
        self.scope = scope
        self.description = description
        
        self.text = contentWithoutFieldMarkers(content)
    }
    
    /// Return the range for the next field or nil if unavilable
    func rangeForNextField(fromField field: Int, inString string: String, atIndex index: String.Index, inout finished: Bool) -> Range<String.Index>? {
        
        // Take the content from the end of the current field, or the whole string if 0
        
        let marker = "$\(field)"
        var subcontent: String = ""
        
        if field == 0 {
            subcontent = content
        } else {
            guard let range = content.rangeOfString(marker) else {
                print("could not find range of current marker for field \(field)")
                return nil
            }
            subcontent = content.substringFromIndex(range.endIndex)
        }
        
        // Turn the subcontent into a regular expression replacing field markers with group captures
        // Before creating the regex, escape the subcontent (it may contain reserved regex characters)
        
        var regex: NSRegularExpression!
        
        do {
            let pattern = contentReplacingFieldMarkersWithGroupExpressions(subcontent)
                .stringByEscapingForRegularExpressionPattern()
                .stringByRestoringCaptureGroups()
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            print(error)
            return nil
        }
        
        // Starting from the index at inString, locate the next available group 
        // capture match and return its location
        
        let indexRange = Range<String.Index>(start: index, end: string.endIndex)
        let range = string.NSRangeFromRange(indexRange)
        
        let matches = regex.matchesInString(string, options: [], range: range)
        
        guard matches.count > 0 else {
            print("no match found")
            return nil
        }
        
        let match = matches[0]
        
        // The zeroeth match is the entire string itself, the oneth match is the group
        
        guard match.numberOfRanges >= 2 else {
            print("no match found")
            return nil
        }
        
        let matchedRange = match.rangeAtIndex(1)
        
        // If there are only two matches or less, no more are available
        
        finished = match.numberOfRanges <= 2
        
        return string.rangeFromNSRange(matchedRange)
    }
}

private func contentWithoutFieldMarkers(content: String) -> String {
    do {
        let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
        let indexRange = Range<String.Index>(start: content.startIndex, end: content.endIndex)
        let range = content.NSRangeFromRange(indexRange)
        
        return regex.stringByReplacingMatchesInString(content, options: [], range: range, withTemplate: "")
    } catch {
        print(error)
        return content
    }
}

private func contentReplacingFieldMarkersWithGroupExpressions(content: String) -> String {
    do {
        let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
        let template = "(.*)"
        
        let indexRange = Range<String.Index>(start: content.startIndex, end: content.endIndex)
        let range = content.NSRangeFromRange(indexRange)
        
        return regex.stringByReplacingMatchesInString(content, options: [], range: range, withTemplate: template)
    } catch {
        print(error)
        return content
    }
}