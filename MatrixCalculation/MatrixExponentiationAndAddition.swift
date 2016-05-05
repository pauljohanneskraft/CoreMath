//
//  ExponentiationAndAddition.swift
//  Math
//
//  Created by Paul Kraft on 04.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

class ExponentiationAndAddition: XCTestCase {

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

    func testPerformanceExample() {
        let a : [[Double]] = [[0, 1.0], [0, 0]]
        // This is an example of a performance test case.
        self.measureBlock {
            do {
                let b = try a ^+ 10
                print("b: ", b)
            } catch _ {}
            // Put the code you want to measure the time of here.
        }
    }

}
