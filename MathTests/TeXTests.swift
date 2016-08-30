//
//  TeXTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class TeXTests: XCTestCase {
	func testNecessaryTypes() {
		conformsToLaTeXConvertible(
			Int  (1),
			Int8 (1),
			Int16(1),
			Int32(1),
			Int64(1)
			)
	}
	
	func conformsToLaTeXConvertible(_ array: Any...) {
		for type in array {
			XCTAssert(type is LaTeXConvertible, "\(type(of: type)): \(type)")
		}
	}
	
	func testLaTeXOutputs() {
		XCTAssert( (x^12)			.latex	== "x^{12}"			)
		XCTAssert(((x^12) + (x^15))	.latex	== "x^{12} + x^{15}")
		XCTAssert(( (x^6) *  (x^6))	.latex	== "x^{12}"			)
		XCTAssert(Q(1,2).latex == "\\frac{1}{2}")
		XCTAssert(Enhanced<Int>(integerLiteral: 1).latex == "1")
		XCTAssert(Complex <Int>(integerLiteral: 1).latex == "1")
	}
}
