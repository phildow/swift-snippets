//
//  NSString+Snippets.swift
//  Snippets
//
//  Created by Philip Dow on 2/28/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns the number of fields in a string
    func snippetFieldCount() -> Int {
        do {
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
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
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
            let range = entireNSRange()
            let template = ""
            
            return regex.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: template)
        } catch {
            print(error)
            return self
        }
    }
    
    /// Replaces the field markers in a string with capture groups
    func snippetContentReplacingFieldMarkersWithGroupExpressions() -> String {
        do {
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
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
            let regex = try NSRegularExpression(pattern: "\\$\\d+", options: [])
            let range = entireNSRange()
            let marker = "$\(field)"
            
            let matches = regex.matchesInString(self, options: [], range: range)
            
            return matches.indexOf({ (result: NSTextCheckingResult) -> Bool in
                // would prefer to use $0 here but get an ambiguous context eror
                guard let matchRange = rangeFromNSRange(result.range) else {
                    return false
                }
                return substringWithRange(matchRange) == marker
            })
            
        } catch {
            print(error)
            return nil
        }
    }

}