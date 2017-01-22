//
//  ConstantFunctionTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class ConstantFunctionTests: XCTestCase {
	// MID_PRIO
	
    static var allTests : [(String, (ConstantFunctionTests) -> () throws -> () )] {
        return [
            ("testOperators", testOperators)
        ]
    }
    
	func testOperators() {
		
		// +, -
		let a = -5 + (x^3)
		// print(a)
		let b = -5 - (-(x^3))
		// print(b)
		let c = (x^3) - 5
		// print(c)
		let d = (x^3) + -5
		// print(d)
		
		XCTAssert(a == b && b == a)
		XCTAssert(b == c && c == b)
		XCTAssert(c == d && d == c)
		
		// as == should be transitive, this is just used for checking
		XCTAssert(a == d && d == a)
		XCTAssert(b == d && d == b)
		XCTAssert(a == c && c == a)
		
		// *
		let e = 3 * x
		// print(e)
		let f = x * 3
		// print(f)
		
		XCTAssert(e == f && f == e)
	}
}
