//
//  String+NSRange.swift
//  South Lake
//
//  Created by Philip Dow on 2/26/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//
//  http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index

import Foundation

extension String {
    
    func entireRange() -> Range<String.Index> {
        return Range<String.Index>(start: startIndex, end: endIndex)
    }
    
    func entireNSRange() -> NSRange {
        return NSRangeFromRange(entireRange())
    }
    
    func rangeFrom(index: String.Index) -> Range<String.Index> {
        return Range<String.Index>(start: index, end: endIndex)
    }
    
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
    
    func NSRangeFromRange(range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.startIndex, within: utf16view)
        let to = String.UTF16View.Index(range.endIndex, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distanceTo(from), from.distanceTo(to))
    }
}
