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
    
    /// The number of fields in the snippet
    private var fieldCount: Int = 0
    
    // MARK: - Initialization
    
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
        
        self.text = Snippet.contentWithoutFieldMarkers(content)
        self.fieldCount = Snippet.fieldCount(content)
    }
    
    // MARK: - Field Ranges
    
    /// Return the range for the next field or nil if unavilable
    func rangeForNextField(fromField field: Int, forward: Bool, inString string: String, atIndex index: String.Index, inout finished: Bool) -> Range<String.Index>? {
        
        // Default to finished so that we don't have keep setting it when we bail
        
        finished = true
        
        guard fieldCount > 0 else {
            return nil
        }
        
        // The target field is the next available field or the zero field if there are none
        // Depending on whether we're moving forwards or backwards
        
        let targetField = forward ? ( field + 1 < fieldCount ? field + 1 : 0 )
                                  : ( field - 1 > 0 ? field - 1 : fieldCount )
        
        // Find the index of the targetField in the content
        
        guard let targetFieldIndex = Snippet.indexOfField(targetField, inContent: content) else {
            print("unable to locate field: \(targetField)")
            return nil
        }
        
        // Find the matches in the string using content with field markers replaced by capture groups
        
        var regex: NSRegularExpression!
        
        do {
            let pattern = Snippet.contentReplacingFieldMarkersWithGroupExpressions(content)
                .stringByEscapingForRegularExpressionPattern()
                .stringByRestoringCaptureGroups()
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            print(error)
            return nil
        }
        
        let fromRange = string.NSRangeFromRange(string.rangeFrom(index))
        let matches = regex.matchesInString(string, options: [], range: fromRange)
        
        guard let match = matches[safe: 0] else {
            print("content not found in string")
            return nil
        }
        
        // Ensure that our match contains a capture group at the target field index
        // The first result in the match is always the content itself
        
        guard match.numberOfRanges >= targetFieldIndex + 1 else {
            print("field not found in string")
            return nil
        }
        
        // Otherwise we have what we want, wrap it up
        
        let targetFieldRange = string.rangeFromNSRange(match.rangeAtIndex(targetFieldIndex + 1))
        
        if targetField != 0 {
            finished = false
        }
        
        return targetFieldRange
    }
    
//    func rangeForNextField(fromField field: Int, inString string: String, atIndex index: String.Index, inout finished: Bool) -> Range<String.Index>? {
//        
//        // Take the content from the end of the current field, or the whole string if 0
//        
//        let marker = "$\(field)"
//        var subcontent: String = ""
//        
//        if field == 0 {
//            subcontent = content
//        } else {
//            guard let range = content.rangeOfString(marker) else {
//                print("could not find range of current marker for field \(field)")
//                return nil
//            }
//            subcontent = content.substringFromIndex(range.endIndex)
//        }
//        
//        // Turn the subcontent into a regular expression replacing field markers with group captures
//        // Before creating the regex, escape the subcontent (it may contain reserved regex characters)
//        
//        var regex: NSRegularExpression!
//        
//        do {
//            let pattern = Snippet.contentReplacingFieldMarkersWithGroupExpressions(subcontent)
//                .stringByEscapingForRegularExpressionPattern()
//                .stringByRestoringCaptureGroups()
//            regex = try NSRegularExpression(pattern: pattern, options: [])
//        } catch {
//            print(error)
//            return nil
//        }
//        
//        // Starting from the index at inString, locate the next available group 
//        // capture match and return its location
//        
//        let indexRange = Range<String.Index>(start: index, end: string.endIndex)
//        let range = string.NSRangeFromRange(indexRange)
//        
//        let matches = regex.matchesInString(string, options: [], range: range)
//        
//        guard matches.count > 0 else {
//            print("no match found")
//            return nil
//        }
//        
//        let match = matches[0]
//        
//        // The zeroeth match is the entire string itself, the oneth match is the group
//        
//        guard match.numberOfRanges >= 2 else {
//            print("no match found")
//            return nil
//        }
//        
//        let matchedRange = match.rangeAtIndex(1)
//        
//        // If there are only two matches or less, no more are available
//        
//        finished = match.numberOfRanges <= 2
//        
//        return string.rangeFromNSRange(matchedRange)
//    }
    
    // MARK: - Utilities
    
    /// Returns the number of fields in a string
    class func fieldCount(content: String) -> Int {
        do {
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
            let range = content.entireNSRange()
            
            let matches = regex.matchesInString(content, options: [], range: range)
            return matches.count
        } catch {
            print(error)
            return 0
        }
    }
    
    /// Removes the field markers from a string
    class func contentWithoutFieldMarkers(content: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
            let range = content.entireNSRange()
            let template = ""
            
            return regex.stringByReplacingMatchesInString(content, options: [], range: range, withTemplate: template)
        } catch {
            print(error)
            return content
        }
    }
    
    /// Replaces the field markers in a string with capture groups
    class func contentReplacingFieldMarkersWithGroupExpressions(content: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
            let range = content.entireNSRange()
            let template = "(.*)"
            
            return regex.stringByReplacingMatchesInString(content, options: [], range: range, withTemplate: template)
        } catch {
            print(error)
            return content
        }
    }
    
    /// Returns the index of a field in a string
    class func indexOfField(field: Int, inContent content: String) -> Int? {
        do {
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
            let range = content.entireNSRange()
            let marker = "$\(field)"
            
            let matches = regex.matchesInString(content, options: [], range: range)
            
            return matches.indexOf({ (result: NSTextCheckingResult) -> Bool in
                // would prefer to use $0 here but get an ambiguous context eror
                guard let matchRange = content.rangeFromNSRange(result.range) else {
                    return false
                }
                return content.substringWithRange(matchRange) == marker
            })
            
        } catch {
            print(error)
            return nil
        }
    }
}
