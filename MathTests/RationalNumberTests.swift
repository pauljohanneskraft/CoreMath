//
//  RationalNumberTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class RationalNumberTests: XCTestCase, TypeTest {
	
	override func setUp() {
		for _ in 0 ..< 30 { elements.append(Q.random / Q.random) }
	}
	var elements : [RationalNumber] = []
	
	// basic arithmetic
	func testAddition()         {
		forAll("+", assert: { a,b,c in return ((a.double + b.double) - (c.double)) < 1e-10 } ) { $0 + $1 }
	}
	func testSubtraction()      {
		forAll("-") { $0 - $1 }
	}
	func testMultiplication()   {
		// forAll("*", assert: { a,b,c in return ((a.double! * b.double!) - (c.double!)) < 1e-10 } ) { $0 * $1 }
	}
	func testDivision()         {
		// forAll("/", assert: { a,b,c in return ((a.double! / b.double!) - (c.double!)) < 1e-10 } ) { $0 / $1 }
	}
	
	private func doubles(values: [Double]) {
		var time = 0.0
		for value in values {
			print("value:", value)
			let start = NSDate().timeIntervalSinceReferenceDate
			let rat = Q(floatLiteral: value)
			let end = NSDate().timeIntervalSinceReferenceDate
			let ratDouble = rat.double
			let _time = end - start
			print(rat, ratDouble, ratDouble =~ value, "took", _time)
			time += _time
		}
		print("total", time, "per value:", time/Double(values.count))
	}
	
	func testDoublesEasy() {
		doubles(values: [0.125, 0.00125, 2.0.sqrt, 3.0.sqrt, 3e32.sqrt, nextafter(0.0, DBL_MAX) ])
	}
}



















