//
//  TermTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class TermTests: XCTestCase {
	
	func testPolynomial() {
		let one = 5*(x^2)
		let two = x^3
		// let three = 4.4^x
		let a = (one + two) * 3 + (4^x) // * Trigonometric.sin//  + three
		print(a)
		// print(a.latex)
		print(a.derivative)
		print(a.integral)
		let id = a.integral.derivative
		let di = a.derivative.integral
		print(id, "=?=", di)
		XCTAssert(di == id)
		print(a.call(x: 1).reducedDescription)
		print(type(of: a))
		print(5.0 == Double(5.0))
	}
}
