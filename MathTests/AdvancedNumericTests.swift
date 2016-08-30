//
//  AdvancedNumericTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class AdvancedNumericTests: XCTestCase {
	// MID_PRIO
	
	func testConformanceToAdvancedNumeric() {
		conformsToAdvancedNumeric(Int   .self)
		conformsToAdvancedNumeric(Int8  .self)
		conformsToAdvancedNumeric(Int16 .self)
		conformsToAdvancedNumeric(Int32 .self)
		conformsToAdvancedNumeric(Int64 .self)
	}
	
	func conformsToAdvancedNumeric<N : AdvancedNumeric>(_ type: N.Type) {
		print(type, "\tconforms to AdvancedNumeric.")
	}
		
	func testMod() {
		mod(on: Int		.self)
		mod(on: Int8	.self)
		mod(on: Int16	.self)
		mod(on: Int32	.self)
		mod(on: Int64	.self)
		mod(on: Double	.self)
	}
	
	func mod< N : AdvancedNumeric >(on type: N.Type) {
		let a = N.init(integerLiteral: 20)
		let am = a.mod(5)
		// print(am)
		XCTAssert(am == 0)
		let b = N.init(integerLiteral: -10)
		let bm = b.mod(3)
		// print(bm)
		XCTAssert(bm == 2)
	}
}
