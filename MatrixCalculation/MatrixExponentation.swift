//
//  Exponentation.swift
//  Math
//
//  Created by Paul Kraft on 04.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

@testable import Math

class Exponentation: XCTestCase {

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
        // This is an example of a performance test case.
        var mat : [[Double]] = []
        for _ in 0..<100 {
            var arr : [Double] = []
            for j in 0..<100 {
                arr.append(1/Double(j+1))
            }
            mat.append(arr)
        }
        print(mat.count, "x", mat[0].count)
        self.measureBlock {
            // Put the code you want to measure the time of here.
            /* do {
                let b = try mat ^ 10
                print(b)
            } catch _ {} */
        }
    }

}
