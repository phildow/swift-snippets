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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual("".snippetFieldCount(), 0)
        XCTAssertEqual("$".snippetFieldCount(), 0)
        XCTAssertEqual("$1".snippetFieldCount(), 1)
        XCTAssertEqual("$10".snippetFieldCount(), 1)
        XCTAssertEqual("$1$2".snippetFieldCount(), 2)
        XCTAssertEqual("$1$20".snippetFieldCount(), 2)
        XCTAssertEqual("$1...$1".snippetFieldCount(), 2)
        XCTAssertEqual("...$1...$2...".snippetFieldCount(), 2)
    }
    
    func testsnippetContentWithoutFieldMarkers() {
        XCTAssertEqual("".snippetContentWithoutFieldMarkers(), "")
        XCTAssertEqual("$".snippetContentWithoutFieldMarkers(), "$")
        XCTAssertEqual("$1".snippetContentWithoutFieldMarkers(), "")
        XCTAssertEqual("$1$2".snippetContentWithoutFieldMarkers(), "")
        XCTAssertEqual("...$1...".snippetContentWithoutFieldMarkers(), "......")
        XCTAssertEqual("a$10b$20c".snippetContentWithoutFieldMarkers(), "abc")
    }
    
    func testsnippetContentReplacingFieldMarkersWithGroupExpressions() {
        XCTAssertEqual("".snippetContentReplacingFieldMarkersWithGroupExpressions(), "")
        XCTAssertEqual("$".snippetContentReplacingFieldMarkersWithGroupExpressions(), "$")
        XCTAssertEqual("$1".snippetContentReplacingFieldMarkersWithGroupExpressions(), "(.*)")
        XCTAssertEqual("$1$2".snippetContentReplacingFieldMarkersWithGroupExpressions(), "(.*)(.*)")
        XCTAssertEqual("...$1...".snippetContentReplacingFieldMarkersWithGroupExpressions(), "...(.*)...")
        XCTAssertEqual("a$10b$20c".snippetContentReplacingFieldMarkersWithGroupExpressions(), "a(.*)b(.*)c")
    }
    
    func testsnippetIndexOfField() {
        XCTAssertEqual("".snippetIndexOfField(1), nil)
        XCTAssertEqual("$1".snippetIndexOfField(1), 0)
        XCTAssertEqual("$1 $2".snippetIndexOfField(1), 0)
        XCTAssertEqual("$1 $2".snippetIndexOfField(2), 1)
        XCTAssertEqual("$2 $1".snippetIndexOfField(1), 1)
    }

}
