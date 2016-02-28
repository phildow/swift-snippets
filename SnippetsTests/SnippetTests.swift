//
//  SnippetTests.swift
//  Snippets
//
//  Created by Philip Dow on 2/28/16.
//  Copyright © 2016 Phil Dow. All rights reserved.
//

import XCTest
@testable import Snippets

class SnippetTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFieldCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(Snippet.fieldCount(""), 0)
        XCTAssertEqual(Snippet.fieldCount("$"), 0)
        XCTAssertEqual(Snippet.fieldCount("$1"), 1)
        XCTAssertEqual(Snippet.fieldCount("$10"), 1)
        XCTAssertEqual(Snippet.fieldCount("$1$2"), 2)
        XCTAssertEqual(Snippet.fieldCount("$1$20"), 2)
        XCTAssertEqual(Snippet.fieldCount("$1...$1"), 2)
        XCTAssertEqual(Snippet.fieldCount("...$1...$2..."), 2)
    }
    
    func testContentWithoutFieldMarkers() {
        XCTAssertEqual(Snippet.contentWithoutFieldMarkers(""), "")
        XCTAssertEqual(Snippet.contentWithoutFieldMarkers("$"), "$")
        XCTAssertEqual(Snippet.contentWithoutFieldMarkers("$1"), "")
        XCTAssertEqual(Snippet.contentWithoutFieldMarkers("$1$2"), "")
        XCTAssertEqual(Snippet.contentWithoutFieldMarkers("...$1..."), "......")
        XCTAssertEqual(Snippet.contentWithoutFieldMarkers("a$10b$20c"), "abc")
    }
    
    func testContentReplacingFieldMarkersWithGroupExpressions() {
        XCTAssertEqual(Snippet.contentReplacingFieldMarkersWithGroupExpressions(""), "")
        XCTAssertEqual(Snippet.contentReplacingFieldMarkersWithGroupExpressions("$"), "$")
        XCTAssertEqual(Snippet.contentReplacingFieldMarkersWithGroupExpressions("$1"), "(.*)")
        XCTAssertEqual(Snippet.contentReplacingFieldMarkersWithGroupExpressions("$1$2"), "(.*)(.*)")
        XCTAssertEqual(Snippet.contentReplacingFieldMarkersWithGroupExpressions("...$1..."), "...(.*)...")
        XCTAssertEqual(Snippet.contentReplacingFieldMarkersWithGroupExpressions("a$10b$20c"), "a(.*)b(.*)c")
    }
    
    func testIndexOfField() {
        XCTAssertEqual(Snippet.indexOfField(1, inContent: ""), nil)
        XCTAssertEqual(Snippet.indexOfField(1, inContent: "$1"), 0)
        XCTAssertEqual(Snippet.indexOfField(1, inContent: "$1 $2"), 0)
        XCTAssertEqual(Snippet.indexOfField(2, inContent: "$1 $2"), 1)
        XCTAssertEqual(Snippet.indexOfField(1, inContent: "$2 $1"), 1)
        XCTAssertEqual(Snippet.indexOfField(0, inContent: "$2 $1 $0"), 2)
    }

}
