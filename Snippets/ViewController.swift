//
//  ViewController.swift
//  Snippets
//
//  Created by Philip Dow on 2/27/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Cocoa

let loremSnippet = "lorem ipsum etc"

let htmlSnippet =
"<html>\n" +
"<head>\n" +
"  <title>$1</title>\n" +
"</head>\n" +
"<body>\n" +
"$2\n" +
"</body>\n" +
"</html>"

let htmlReverseSnippet =
"<html>\n" +
"<head>\n" +
"  <title>$2</title>\n" +
"</head>\n" +
"<body>\n" +
"$1\n" +
"</body>\n" +
"</html>"

let LaTeXSnippet = "$$\\sum_{i=0}^{n}$1$$"

class ViewController: NSViewController {
    let snippets: [Snippet] = [
        Snippet(content: loremSnippet, tabTrigger: "lorem", scope: nil, description: nil),
        Snippet(content: htmlSnippet, tabTrigger: "html", scope: nil, description: nil),
        Snippet(content: htmlReverseSnippet, tabTrigger: "htmlx", scope: nil, description: nil),
        Snippet(content: LaTeXSnippet, tabTrigger: "sumoveriton", scope: nil, description: nil)
    ]
    
    // TODO: Track this information in a "SnippetMatching" class that mediates between a string and a snippet
    
    private var currentSnippet: Snippet?
    private var startIndex: String.Index?
    private var fieldIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension ViewController: NSTextViewDelegate {
    
    func textView(textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        // Return true to indicate that I handled the command, false otherwise
        let range = textView.selectedRange()
        
        switch commandSelector {
        case Selector("insertTab:"):
            print("insertTab:")
            return textViewShouldTabInRange(textView, affectedCharRange: range, forward: true)
        case Selector("insertBacktab:"):
            print("insertBacktab:")
            return textViewShouldTabInRange(textView, affectedCharRange: range, forward: false)
        default:
            return false
        }
    }
    
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
    
    func replaceText(textView: NSTextView, range: Range<String.Index>, replacementString: String) -> Bool {
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
    
    func replaceText(textView: NSTextView, ranges: [Range<String.Index>], replacementStrings: [String]) -> Bool {
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
    
//        guard let i = snippets.indexOf({$0.tabTrigger == triggerString}) else {
//            return true
//        }
//        
//        let snippet = snippets[i]
//        let content = snippet.content
    
    /// Belongs in a snippets exentsion manager
    
    func snippetForTrigger(triggerString: String) -> Snippet? {
        if let i = snippets.indexOf({$0.tabTrigger == triggerString}) {
            return snippets[i]
        } else {
            return nil
        }
    }
    
    /// Returns true if we were able to advance to the next field, false otherwise
    
//    func advanceFromField(field: Int, inSnippet snippet: Snippet, inString string: String, atIndex index: String.Index) -> Bool {
//        if let fieldRange = snippet.rangeForNextField(fromField: field, inString: string, atIndex: index) {
//            textView.setSelectedRange(textView.string!.NSRangeFromRange(fieldRange))
//            return true
//        } else {
//            return false
//        }
//    }
    
    func textViewShouldTabInRange(textView: NSTextView, affectedCharRange: NSRange, forward: Bool) -> Bool {
        
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
        
        let replaced = replaceText(textView, range: triggerRange, replacementString: snippet.text)
        
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
    
    func textViewShouldNewlineInRange(textView: NSTextView, affectedCharRange: NSRange) -> Bool {
        return true
    }
}
