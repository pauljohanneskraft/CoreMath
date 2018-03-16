//
//  EnhancedNumberTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class EnhancedNumberTests: XCTestCase, TypeTest {
    // swiftlint:disable:next type_name
	typealias N = Z
	
    static var allTests: [(String, (EnhancedNumberTests) -> () throws -> Void )] {
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
        super.setUp()
		elements.append(.infinity(sign: true))
		elements.append(.infinity(sign: false))
		elements.append(.nan)
        for _ in 0 ..< 10 {
            let n = N.random(inside: Int16.min.integer...Int16.max.integer)
            let num = Enhanced<N>(integerLiteral: n)
            elements.append(num)
            
        }
	}
	
	var elements: [Enhanced<N>] = []
	
	// basic arithmetic
	func testAddition() {
		forAll("+", assert: { !$0.isNormal || !$1.isNormal || $0.integer + $1.integer == $2.integer }, +)
	}
	func testSubtraction() {
		forAll("-", assert: { !$0.isNormal || !$1.isNormal || $0.integer - $1.integer == $2.integer }, -)
	}
	func testMultiplication() {
		forAll("*", assert: { !$0.isNormal || !$1.isNormal || $0.integer * $1.integer == $2.integer }, *)
	}
	func testDivision() {
		forAll("/", assert: { !$0.isNormal || !$1.isNormal || $0.integer / $1.integer == $2.integer }, /)
	}
	
	func testPrefixMinus() { forAll("-", assert: { $0 == -$1 }, { -$0 }) }
	
	func testReadmeExample() {
		let a: Enhanced<Int> = 5
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
            XCTAssertEqual(Enhanced<Int>(integerLiteral: r).hashValue, r)
		}
	}
	
	func testSign() {
		for _ in 0..<100 {
			let r = Math.random()
            XCTAssert((r < 0) == Enhanced<Int>(integerLiteral: r).sign)
		}
		XCTAssert(Enhanced<Int>.infinity(sign: false).sign == false)
		XCTAssert(Enhanced<Int>.infinity(sign: true).sign == true)
		XCTAssert(Enhanced<Int>.nan.sign == false)
	}
	
}
