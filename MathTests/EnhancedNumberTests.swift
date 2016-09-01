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
		for _ in 0 ..< 10 { elements.append(Enhanced<N>(integerLiteral: N.random % Int16.max.integer)) }
	}
	
	var elements : [Enhanced<N>] = []
	
	// basic arithmetic
	func testAddition()         { forAll("+")	{ $0 + $1 } }
	func testSubtraction()      { forAll("-")	{ $0 - $1 } }
	func testMultiplication()   { forAll("*")	{ $0 * $1 } }
	func testDivision()         { forAll("/")	{ $0 / $1 } }
	
	func testPrefix()			{ forAll("-", assert: { $0 == -$1 })	{ -$0 } }
	
	func testReadmeExample() {
		let a : Enhanced<Int> = 5
		print( a / 0 )
		XCTAssert( a / 0 == Enhanced<Int>.infinity(sign: false))
	}
	
}
