//
//  NumericTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class NumericTests: XCTestCase, TypeTest {
	
	typealias Number = Int
	
	var elements: [Number] = []
	
	func testPrettyMuchEquals() {
		for _ in  0 ..< 1000 {
			let one = Double.random
			let two = nextafter(one, DBL_MAX)
			let eq  = one == two
			let eqn = one =~ two
			XCTAssert(eqn)
			XCTAssert(!eq)
		}
	}
	
}
