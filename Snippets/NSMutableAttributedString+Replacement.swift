//
//  NSMutableAttributedString+Replacement.swift
//  Snippets
//
//  Created by Philip Dow on 2/28/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    func replaceCharactersInRanges(ranges: [Range<String.Index>], withStrings replacementStrings: [String]) {
        // guard no overlap in the ranges
        // guard ranges are sorted
        // work backwards
        
        for (range, replacement) in zip(ranges, replacementStrings).reverse() {
            replaceCharactersInRange(string.NSRangeFromRange(range), withString: replacement)
        }
    }
    
}