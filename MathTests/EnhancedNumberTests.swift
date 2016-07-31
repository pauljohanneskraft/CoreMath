//
//  EnhancedNumberTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class EnhancedNumberTests: XCTestCase, TypeTest {
    typealias N = Z
    
    override func setUp() {
        elements.append(.infinity(sign: true))
        elements.append(.infinity(sign: false))
        elements.append(.nan)
        for _ in 0 ..< 10 { elements.append(Enhanced<N>.random) }
    }
    
    var elements : [Enhanced<N>] = []
    
    // basic arithmetic
    func testAddition()         { forAll("+") { $0 + $1 } }
    func testSubtraction()      { forAll("-") { $0 - $1 } }
    func testMultiplication()   { forAll("*") { $0 * $1 } }
    func testDivision()         { forAll("/") { $0 / $1 } }
    
}
