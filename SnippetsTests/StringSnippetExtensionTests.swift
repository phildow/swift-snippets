//
//  StringSnippetTests.swift
//  Snippets
//
//  Created by Philip Dow on 2/28/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import XCTest
@testable import Snippets

class StringSnippetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testsnippetFieldCount() {
    
        // Fakes
        
        XCTAssertEqual("".snippetFieldCount(), 0)
        XCTAssertEqual("$".snippetFieldCount(), 0)
        
        // Basic Fields
        
        XCTAssertEqual("$1".snippetFieldCount(), 1)
        XCTAssertEqual("$10".snippetFieldCount(), 1)
        XCTAssertEqual("$1$2".snippetFieldCount(), 2)
        XCTAssertEqual("$1$20".snippetFieldCount(), 2)
        XCTAssertEqual("$1...$1".snippetFieldCount(), 2)
        XCTAssertEqual("...$1...$2...".snippetFieldCount(), 2)
        
        // Placeholder Fields
        
        XCTAssertEqual("{$1:this}".snippetFieldCount(), 1)
        XCTAssertEqual("{$10:foo}".snippetFieldCount(), 1)
        XCTAssertEqual("{$1:bar}{$2:baz}".snippetFieldCount(), 2)
        XCTAssertEqual("{$1:100}{$20:200}".snippetFieldCount(), 2)
        XCTAssertEqual("{$1:foo}...{$1:bar}".snippetFieldCount(), 2)
        XCTAssertEqual("...{$1:foo}...{$2:bar}...".snippetFieldCount(), 2)
    }
    
    func testsnippetContentWithoutFieldMarkers() {
        
        // Fakes
        
        XCTAssertEqual("".snippetContentWithoutFieldMarkers(), "")
        XCTAssertEqual("$".snippetContentWithoutFieldMarkers(), "$")
        
        // Basic Snippets
        
        XCTAssertEqual("$1".snippetContentWithoutFieldMarkers(), "")
        XCTAssertEqual("$1$2".snippetContentWithoutFieldMarkers(), "")
        XCTAssertEqual("...$1...".snippetContentWithoutFieldMarkers(), "......")
        XCTAssertEqual("a$10b$20c".snippetContentWithoutFieldMarkers(), "abc")
        
        // Placeholder Fields
        
        XCTAssertEqual("{$1:this}".snippetContentWithoutFieldMarkers(), "this")
        XCTAssertEqual("{$1:bar}{$2:baz}".snippetContentWithoutFieldMarkers(), "barbaz")
        XCTAssertEqual("...{$1:100}...".snippetContentWithoutFieldMarkers(), "...100...")
        XCTAssertEqual("a-{$10:foo}-b-{$20:baz}-c".snippetContentWithoutFieldMarkers(), "a-foo-b-baz-c")

    }
    
    func testsnippetContentReplacingFieldMarkersWithGroupExpressions() {
        
        // Fakes
        
        XCTAssertEqual("".snippetContentReplacingFieldMarkersWithGroupExpressions(), "")
        XCTAssertEqual("$".snippetContentReplacingFieldMarkersWithGroupExpressions(), "$")
        
        // Basic Snippets
        
        XCTAssertEqual("$1".snippetContentReplacingFieldMarkersWithGroupExpressions(), "(.*)")
        XCTAssertEqual("$1$2".snippetContentReplacingFieldMarkersWithGroupExpressions(), "(.*)(.*)")
        XCTAssertEqual("...$1...".snippetContentReplacingFieldMarkersWithGroupExpressions(), "...(.*)...")
        XCTAssertEqual("a$10b$20c".snippetContentReplacingFieldMarkersWithGroupExpressions(), "a(.*)b(.*)c")
        
        // Placeholder Fields
        
        XCTAssertEqual("{$1:this}".snippetContentReplacingFieldMarkersWithGroupExpressions(), "(.*)")
        XCTAssertEqual("{$1:bar}{$2:baz}".snippetContentReplacingFieldMarkersWithGroupExpressions(), "(.*)(.*)")
        XCTAssertEqual("...{$1:100}...".snippetContentReplacingFieldMarkersWithGroupExpressions(), "...(.*)...")
        XCTAssertEqual("a{$10:foo}b{$20:baz}c".snippetContentReplacingFieldMarkersWithGroupExpressions(), "a(.*)b(.*)c")
        
    }
    
    func testsnippetIndexOfField() {
        
        // Fakes
        
        XCTAssertEqual("".snippetIndexOfField(1), nil)
        XCTAssertEqual("$".snippetIndexOfField(1), nil)
        
        // Basic Snippets
        
        XCTAssertEqual("$1".snippetIndexOfField(1), 0)
        XCTAssertEqual("$1 $2".snippetIndexOfField(1), 0)
        XCTAssertEqual("$1 $2".snippetIndexOfField(2), 1)
        XCTAssertEqual("$2 $1".snippetIndexOfField(1), 1)
        
        // Placeholder Fields
        
        XCTAssertEqual("{$1:foo}".snippetIndexOfField(1), 0)
        XCTAssertEqual("{$1:this} {$2:bar}".snippetIndexOfField(1), 0)
        XCTAssertEqual("{$1:100} {$2:200}".snippetIndexOfField(2), 1)
        XCTAssertEqual("{$2:wards} {$1:back}".snippetIndexOfField(1), 1)
    }

}
