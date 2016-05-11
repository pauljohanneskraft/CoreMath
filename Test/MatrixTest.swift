//
//  MatrixTest.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

@testable import Math

class MatrixTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMultiplication() {
        let a = [[1,2,3], [4,5,6], [7,8,9]]
        let b = [[9,8,7], [6,5,4], [3,2,1]]
        var c = []
        measureThrowingBlock {
            // c = try a * b // ambigous use of operator '*'
        }
        print(c)
    }
    
    func testScalarMultiplication() {
        let a = [[1,2,3], [4,5,6], [7,8,9]]
        let b = 5
        var c = []
        measureBlock {
            // c = a * b // ambigous use of operator '*'
        }
        print(c)
    }
    
    func testAddition() {
        let a = [[1,2,3], [4,5,6], [7,8,9]]
        let b = [[9,8,7], [6,5,4], [3,2,1]]
        var c = []
        measureThrowingBlock {
            // c = try a + b // ambigous use of operator '+'
        }
        print(c)
    }
    
    func testExponentiation() {
        let a = [[1,2,3], [4,5,6], [7,8,9]]
        let b = 5
        var c = []
        measureThrowingBlock {
            // c = try a ^ b // ambigous use of operator '^'
        }
        print(c)
    }
    
    func testExponentiationAndAddition() {
        let a = [[1,2,3], [4,5,6], [7,8,9]]
        let b : UInt = 5
        var c = []
        measureThrowingBlock {
            // c = try a ^+ b // ambigous use of operator '^+'
        }
        print(c)
    }
    
    func testModulo() {
        let a  = [[1,2,3], [4,5,6], [7,8,9]]
        let b = 2
        var c = []
        measureBlock {
            // c = a % b // ambigous use of operator '%'
        }
        print(c)
    }
}



