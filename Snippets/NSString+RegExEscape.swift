//
//  NSString+RegExEscape.swift
//  Snippets
//
//  Created by Philip Dow on 2/27/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Foundation

extension String {
    func stringByEscapingForRegularExpressionPattern() -> String {
        return stringByReplacingOccurrencesOfString("\\", withString: "\\\\")
              .stringByReplacingOccurrencesOfString("$", withString: "\\$")
              .stringByReplacingOccurrencesOfString("^", withString: "\\^")
              .stringByReplacingOccurrencesOfString("[", withString: "\\[")
              .stringByReplacingOccurrencesOfString("]", withString: "\\]")
              .stringByReplacingOccurrencesOfString("(", withString: "\\(")
              .stringByReplacingOccurrencesOfString(")", withString: "\\)")
              .stringByReplacingOccurrencesOfString("{", withString: "\\{")
              .stringByReplacingOccurrencesOfString("}", withString: "\\}")
              .stringByReplacingOccurrencesOfString("?", withString: "\\?")
              .stringByReplacingOccurrencesOfString("*", withString: "\\*")
              .stringByReplacingOccurrencesOfString("+", withString: "\\+")
              .stringByReplacingOccurrencesOfString(".", withString: "\\.")
    }
    
    func stringByRestoringCaptureGroups() -> String {
        return stringByReplacingOccurrencesOfString("\\(\\.\\*\\)", withString: "(.*)")
    }
}