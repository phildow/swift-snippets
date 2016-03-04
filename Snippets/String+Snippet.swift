//
//  NSString+Snippets.swift
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

//  Regex: (\$\d+|\{\$\d+:.*?\})  (?:\{\$\d+:(.*?)\})|(?:\$\d+)
//  Match either a basic field or a placeholder field, but only capture the content of the placeholder

import Foundation

extension String {
    
    /// Returns the number of fields in a string
    func snippetFieldCount() -> Int {
        do {
            let regex = try NSRegularExpression(pattern: "(?:\\{\\$\\d+:(.*?)\\})|(?:\\$\\d+)", options: [])
            let range = entireNSRange()
            
            let matches = regex.matchesInString(self, options: [], range: range)
            return matches.count
        } catch {
            print(error)
            return 0
        }
    }
    
    /// Removes the field markers from a string
    func snippetContentWithoutFieldMarkers() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "(?:\\{\\$\\d+:(.*?)\\})|(?:\\$\\d+)", options: [])
            let range = entireNSRange()
            let template = "$1"
            
            return regex.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: template)
        } catch {
            print(error)
            return self
        }
    }
    
    /// Replaces the field markers in a string with capture groups
    func snippetContentReplacingFieldMarkersWithGroupExpressions() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "(?:\\{\\$\\d+:(.*?)\\})|(?:\\$\\d+)", options: [])
            let range = entireNSRange()
            let template = "(.*)"
            
            return regex.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: template)
        } catch {
            print(error)
            return self
        }
    }
    
    /// Returns the index of a field in a string
    func snippetIndexOfField(field: Int) -> Int? {
        do {
            let regex = try NSRegularExpression(pattern: "(?:\\{\\$\\d+:(.*?)\\})|(?:\\$\\d+)", options: [])
            let range = entireNSRange()
            let marker1 = "$\(field)"
            let marker2 = "{$\(field):"
            
            let matches = regex.matchesInString(self, options: [], range: range)
            
            return matches.indexOf({ (result: NSTextCheckingResult) -> Bool in
                // would prefer to use $0 here but get an ambiguous context eror
                guard let matchRange = rangeFromNSRange(result.range) else {
                    return false
                }
                let substring = substringWithRange(matchRange)
                return substring == marker1 || substring.hasPrefix(marker2)
            })
            
        } catch {
            print(error)
            return nil
        }
    }

}