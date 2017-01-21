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
	
    var allTests : [(String, () throws -> () )] {
        return [
            ("testAddition", testAddition),
            ("testSign", testSign),
            ("testInits", testInits),
            ("testDivision", testDivision),
            ("testHashValue", testHashValue),
            ("testPrefixMinus", testPrefixMinus),
            ("testSubtraction", testSubtraction),
            ("testReadmeExample", testReadmeExample),
            ("testMultiplication", testMultiplication)
        ]
    }
    
	override func setUp() {
		elements.append(.infinity(sign: true))
		elements.append(.infinity(sign: false))
		elements.append(.nan)
		for _ in 0 ..< 10 { elements.append(Enhanced<N>(integerLiteral: N.random % Int16.max.integer)) }
	}
	
	var elements : [Enhanced<N>] = []
	
	// basic arithmetic
	func testAddition()         {
		forAll("+", assert: { !$0.isNormal || !$1.isNormal || $0.integer + $1.integer == $2.integer })	{ $0 + $1 }
	}
	func testSubtraction()      {
		forAll("-", assert: { !$0.isNormal || !$1.isNormal || $0.integer - $1.integer == $2.integer })	{ $0 - $1 }
	}
	func testMultiplication()   {
		forAll("*", assert: { !$0.isNormal || !$1.isNormal || $0.integer * $1.integer == $2.integer })	{ $0 * $1 }
	}
	func testDivision()         {
		forAll("/", assert: { !$0.isNormal || !$1.isNormal || $0.integer / $1.integer == $2.integer })	{ $0 / $1 }
	}
	
	func testPrefixMinus()		{ forAll("-", assert: { $0 == -$1 })	{ -$0 } }
	
	func testReadmeExample()	{
		let a : Enhanced<Int> = 5
		print( a / 0 )
		XCTAssert( a / 0 == Enhanced<Int>.infinity(sign: false))
	}
	
	func testInits() {
		let p_inf = Enhanced<Int>(floatLiteral: Double.infinity)
		XCTAssert(p_inf == Enhanced<Int>.infinity(sign: false))
		let m_inf = Enhanced<Int>(floatLiteral: -Double.infinity)
		XCTAssert(m_inf == Enhanced<Int>.infinity(sign: true))
		let nan = Enhanced<Int>(floatLiteral: Double.nan)
		XCTAssert(nan == Enhanced<Int>.nan)
		let m_nan = Enhanced<Int>(floatLiteral: -Double.nan)
		XCTAssert(m_nan == Enhanced<Int>.nan)
	}
	
	func testHashValue() {
		XCTAssert(Double.nan.hashValue == Enhanced<Int>.nan.hashValue)
		XCTAssert(Double.infinity.hashValue == Enhanced<Int>.infinity(sign: false).hashValue)
		XCTAssert((-Double.infinity).hashValue == Enhanced<Int>.infinity(sign: true).hashValue)
		for _ in 0 ..< 10 {
			let r = Math.random()
			XCTAssert(Enhanced<Int>(r).hashValue == r)
		}
	}
	
	func testSign() {
		for _ in 0..<100 {
			let r = Math.random()
			XCTAssert((r < 0) == Enhanced<Int>(r).sign)
		}
		XCTAssert(Enhanced<Int>.infinity(sign: false).sign == false)
		XCTAssert(Enhanced<Int>.infinity(sign: true).sign == true)
		XCTAssert(Enhanced<Int>.nan.sign == false)
	}
	
}
