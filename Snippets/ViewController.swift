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
"$0\n" +
"</body>\n" +
"</html>"

let LaTeXSnippet = "$$\\sum_{i=0}^{n}$0$$" // "$$\\sum_{i=0}^{n}$1$$" must be double escaped!

class ViewController: NSViewController {
    let snippets: [Snippet] = [
        Snippet(content: loremSnippet, tabTrigger: "lorem", scope: nil, description: nil),
        Snippet(content: htmlSnippet, tabTrigger: "html", scope: nil, description: nil),
        Snippet(content: LaTeXSnippet, tabTrigger: "sumoveriton", scope: nil, description: nil)
    ]
    
    private var currentSnippet: Snippet?
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
    
    func textView(textView: NSTextView, shouldChangeTextInRange affectedCharRange: NSRange,  replacementString: String?) -> Bool {
        guard let text = replacementString where text.characters.count > 0 else {
            return true
        }
        
        switch text {
        case "\n", "\r":
            return textViewShouldNewlineInRange(textView, affectedCharRange: affectedCharRange, replacementString: text)
        case "\t":
            return textViewShouldTabInRange(textView, affectedCharRange: affectedCharRange, replacementString: text)
        default:
            return true
        }
    }
    
//        let boundaries = NSCharacterSet.alphanumericCharacterSet().invertedSet
//        let string = textView.string!
//        
//        let startIndex = string.startIndex
//        let endIndex = string.rangeFromNSRange(affectedCharRange)!.endIndex
//        let searchRange = Range<String.Index>(start: startIndex, end: endIndex)
//        
//        var range = string.rangeOfCharacterFromSet(boundaries, options: .BackwardsSearch, range: searchRange)
//        
//        if range == nil {
//            // Want entire range
//            range = Range<String.Index>(start: string.startIndex, end: string.endIndex)
//        } else {
//            // Advance by one to ignore matched character
//            range!.startIndex = range!.startIndex.advancedBy(1)
//        }
//        
//        let triggerRange = Range<String.Index>(start: range!.startIndex, end: searchRange.endIndex)
//        let triggerString = string.substringWithRange(triggerRange)
    
    /// Takes the characters between the first non alphanumeric string before index and index.
    /// Returns the range of that string and the string itself.
    
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
    
//        guard textView.shouldChangeTextInRange(string.NSRangeFromRange(triggerRange), replacementString: content) else {
//            return true
//        }
//        
//        textView.textStorage?.beginEditing()
//        textView.textStorage?.replaceCharactersInRange(string.NSRangeFromRange(triggerRange), withString: content)
//        textView.textStorage?.endEditing()
        
//        return false
    
    /// Returns true if the range was replaced, false if not.
    
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
    
    func textViewShouldTabInRange(textView: NSTextView, affectedCharRange: NSRange, replacementString: String) -> Bool {
        
        guard let string = textView.string else {
            return true
        }
        
        guard let index = string.rangeFromNSRange(affectedCharRange)?.endIndex else {
            return true
        }
        
        // If we are already editing a snippet, advance to the next field or the end of the snippet
        
        if currentSnippet != nil {
            var finished: Bool = false
            if let fieldRange = currentSnippet!.rangeForNextField(fromField: fieldIndex, inString: textView.string!, atIndex: string.rangeFromNSRange(affectedCharRange)!.startIndex, finished: &finished) {
                textView.setSelectedRange(textView.string!.NSRangeFromRange(fieldRange))
                if (finished) {
                    currentSnippet = nil
                    fieldIndex = -1
                } else {
                    fieldIndex += 1
                }
                return false
            } else {
                currentSnippet = nil
                fieldIndex = -1
                return true
            }
        }
        
        // Determine trigger range and string
        
        let (triggerRange, triggerString) = triggerFor(string, index: index)
        
        // Match trigger string to snippet: indexOf with a predicate
        
        guard let snippet = snippetForTrigger(triggerString) else {
            return true
        }
        
        // Replace text in range
        
        let replaced = replaceText(textView, range: triggerRange, replacementString: snippet.text)
        var finished: Bool = false
        
        // Advance to the first field or the end of the string if there is none
        
        if let fieldRange = snippet.rangeForNextField(fromField: 0, inString: textView.string!, atIndex: triggerRange.startIndex, finished: &finished) {
            textView.setSelectedRange(textView.string!.NSRangeFromRange(fieldRange))
            if (finished) {
                currentSnippet = nil
                fieldIndex = -1
            } else {
                currentSnippet = snippet
                fieldIndex = 1
            }
        } else {
            currentSnippet = nil
            fieldIndex = -1
        }
        
        return !replaced
    }
    
    func textViewShouldNewlineInRange(textView: NSTextView, affectedCharRange: NSRange,  replacementString: String) -> Bool {
        return true
    }
}
