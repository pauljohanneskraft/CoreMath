//
//  EquationTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class EquationTests: XCTestCase {
	// MID_PRIO
	
    static var allTests : [(String, (EquationTests) -> () throws -> () )] {
        return [
            ("testReduced", testReduced)
        ]
    }
    
	func testReduced() {
		let a = ((x^2) + (x^5))
		let b = ((x^3) + (x^4))
		let ab = (a * b)
		XCTAssert(ab.debugDescription == "Equation(x^5, x^6, x^8, x^9)")
	}
}
