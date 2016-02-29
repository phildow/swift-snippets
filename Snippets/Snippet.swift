//
//  Snippet.swift
//  Snippets
//
//  Created by Philip Dow on 2/27/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Foundation

class Snippet {
    
    /// Use this constant when seeking the range for next field in a newly entered snippet
    static var NewSnippetField: Int = 0
    
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
    private var snippetFieldCount: Int = 0
    
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
        
        self.text = content.snippetContentWithoutFieldMarkers()
        self.snippetFieldCount = content.snippetFieldCount()
    }
    
    // MARK: - Field Ranges
    
    // TODO: make it work with multiple ranges for mirrored fields
    
    /// Return the range for the next field or nil if unavilable
    /// - parameter fromField:  The field from which to locate the next or
    ///                         pevious field. Use `NewSnippetField` to advance 
    ///                         to the first field
    /// - parameter forward:    Find the range for the next field (`true`) or 
    ///                         previous field (`false`).
    /// - parameter inString:   The user text being scanned.
    /// - parameter atIndex:    The location at inString from which to look for 
    ///                         the next field.
    
    func rangeForNextField(fromField field: Int, forward: Bool, inString string: String, atIndex index: String.Index) -> Range<String.Index>? {
        
        // Done if there are no fields
        
        guard snippetFieldCount > 0 else {
            return nil
        }
        
        // Done if the last field wants to move forward
        
        if field == snippetFieldCount && forward {
            return nil
        }
        
        // Done if the first field wants to move backwards
        
        if field == 1 && !forward {
            return nil
        }
        
        // The target field is the next available field forward or backwards
        
        let targetField = forward ? field + 1 : field - 1
        
//        print("field is \(field) and target field is \(targetField), field count is \(snippetFieldCount)")
        
        // Find the index of the targetField in the content
        
        guard let targetFieldIndex = content.snippetIndexOfField(targetField) else {
            print("unable to locate field: \(targetField)")
            return nil
        }
        
        // Find the matches in the string using content with field markers replaced by capture groups
        
        var regex: NSRegularExpression!
        
        do {
            let pattern = content
                .snippetContentReplacingFieldMarkersWithGroupExpressions()
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
        return targetFieldRange
    }

}
