//
//  ViewController.swift
//  Snippets
//
//  Created by Philip Dow on 2/27/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import Cocoa

let LaTeXSnippet = "$$\\sum_{i=0}^{n}$1$$"
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

class ViewController: NSViewController {
    @IBOutlet private var textView: NSTextView!
   
    // Snippets! Get them from somewhere. The classes make no assumption about how you manage them
   
    let snippets: [Snippet] = [
        Snippet(content: loremSnippet, tabTrigger: "lorem", scope: nil, description: nil),
        Snippet(content: htmlSnippet, tabTrigger: "html", scope: nil, description: nil),
        Snippet(content: htmlReverseSnippet, tabTrigger: "htmlx", scope: nil, description: nil),
        Snippet(content: LaTeXSnippet, tabTrigger: "sumoveriton", scope: nil, description: nil)
    ]
    
    // All you need is this snippet helper. Set it up in viewDidLoad
    
    private var snippetHelper: SnippetTextViewHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the snippet helper and text view delegate
        // You can change the snippets available to the helper but not the text view
        
        snippetHelper = SnippetTextViewHelper(textView: textView, snippets: snippets)
        textView.delegate = self // (or in IB)
    }
}

extension ViewController: NSTextViewDelegate {
    
    // Implement the doCommandBySelector text view delegate method
    // Watch for insertTab: and insertBacktab: responder actions
    // Return handleTab(...)
    
    func textView(textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        // Return true to indicate that I handled the command, false otherwise
        let range = textView.selectedRange()
        
        switch commandSelector {
        case Selector("insertTab:"):
            return snippetHelper.handleTab(range, forward: true)
        case Selector("insertBacktab:"):
            return snippetHelper.handleTab(range, forward: false)
        default:
            return false
        }
    }
    
}
