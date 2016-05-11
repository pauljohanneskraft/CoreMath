//
//  NumberTest.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

@testable import Math

class NumberTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testExponentiation() {
        var a : Int = 1
        measureBlock {
            // a = 5 ^^ 2 //ambigous use of operator '^^'
        }
        print(a)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
