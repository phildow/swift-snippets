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

    func testFieldCount() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual("".fieldCount(), 0)
        XCTAssertEqual("$".fieldCount(), 0)
        XCTAssertEqual("$1".fieldCount(), 1)
        XCTAssertEqual("$10".fieldCount(), 1)
        XCTAssertEqual("$1$2".fieldCount(), 2)
        XCTAssertEqual("$1$20".fieldCount(), 2)
        XCTAssertEqual("$1...$1".fieldCount(), 2)
        XCTAssertEqual("...$1...$2...".fieldCount(), 2)
    }
    
    func testContentWithoutFieldMarkers() {
        XCTAssertEqual("".contentWithoutFieldMarkers(), "")
        XCTAssertEqual("$".contentWithoutFieldMarkers(), "$")
        XCTAssertEqual("$1".contentWithoutFieldMarkers(), "")
        XCTAssertEqual("$1$2".contentWithoutFieldMarkers(), "")
        XCTAssertEqual("...$1...".contentWithoutFieldMarkers(), "......")
        XCTAssertEqual("a$10b$20c".contentWithoutFieldMarkers(), "abc")
    }
    
    func testContentReplacingFieldMarkersWithGroupExpressions() {
        XCTAssertEqual("".contentReplacingFieldMarkersWithGroupExpressions(), "")
        XCTAssertEqual("$".contentReplacingFieldMarkersWithGroupExpressions(), "$")
        XCTAssertEqual("$1".contentReplacingFieldMarkersWithGroupExpressions(), "(.*)")
        XCTAssertEqual("$1$2".contentReplacingFieldMarkersWithGroupExpressions(), "(.*)(.*)")
        XCTAssertEqual("...$1...".contentReplacingFieldMarkersWithGroupExpressions(), "...(.*)...")
        XCTAssertEqual("a$10b$20c".contentReplacingFieldMarkersWithGroupExpressions(), "a(.*)b(.*)c")
    }
    
    func testIndexOfField() {
        XCTAssertEqual("".indexOfField(1), nil)
        XCTAssertEqual("$1".indexOfField(1), 0)
        XCTAssertEqual("$1 $2".indexOfField(1), 0)
        XCTAssertEqual("$1 $2".indexOfField(2), 1)
        XCTAssertEqual("$2 $1".indexOfField(1), 1)
    }

}
