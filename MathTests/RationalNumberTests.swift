//
//  RationalNumberTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class RationalNumberTests: XCTestCase, TypeTest {
    
    override func setUp() {
        for _ in 0 ..< 30 { elements.append(Q.random / Q.random) }
    }
    var elements : [RationalNumber] = []
    
    // basic arithmetic
    func testAddition()         {
        forAll("+"/*, assert: { a,b,c in return ((a.double! + b.double!) ~= (c.double!)) }*/) { $0 + $1 }
    }
    func testSubtraction()      { forAll("-") { $0 - $1 } }
    func testMultiplication()   { forAll("*") { $0 * $1 } }
    func testDivision()         { forAll("/") { $0 / $1 } }
}

