//
//  StringTest.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

@testable import Math

class StringTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMultiplication() {
        let a = "hello"
        var b = ""
        let num : UInt = UInt(2)
        print(a, " * ", num, "=>")
        measureBlock {
            b = a * num
        }
        print(b)
    }
}

