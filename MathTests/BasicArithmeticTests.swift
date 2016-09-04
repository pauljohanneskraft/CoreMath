//
//  BasicArithmeticTests.swift
//  Math
//
//  Created by Paul Kraft on 25.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Foundation
import Math

class BasicArithmeticTests: XCTestCase {
	
	func testAbs() {
		for _ in 0..<100 {
			XCTAssert(random().abs >= 0)
		}
	}
	
	func testReducedDescription() {
		for _ in 0..<10000 {
			let a = Double.random
			XCTAssert(!a.isInteger || !a.reducedDescription.hasSuffix(".0"), "\(a)")
		}
	}
	
	func testZ_() {
		
		for _ in 0..<20 {
			let a = random() & 0xFF
			let z = Z_(a)
			let range = 0..<a
			for _ in 0..<100 {
				let r = random() & 0xFFF
				XCTAssert(range.contains(r) ? z.contains(r) : !z.contains(r))
			}
		}
		
		
	}
	
}
