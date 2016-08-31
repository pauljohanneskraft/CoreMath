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
		for _ in 0 ..< 30 { elements.append(Q(Int.random % Int16.max.integer)) }
	}
	var elements : [RationalNumber] = []
	
	// basic arithmetic
	func testAddition()         {
		forAll("+", assert: { a,b,c in return ((a.double + b.double) - (c.double)) < 1e-10 } ) { $0 + $1 }
	}
	func testSubtraction()      {
		forAll("-", assert: { a,b,c in return ((a.double - b.double) - (c.double)).abs < 1e-10 }) { $0 - $1 }
	}
	func testMultiplication()   {
		forAll("*", assert: { a,b,c in return ((a.double * b.double) - (c.double)).abs < 1e-10 } ) { $0 * $1 }
	}
	func testDivision()         {
		forAll("/", assert: { a,b,c in return ((a.double / b.double) - (c.double)).abs < 1e-10 } ) { $0 / $1 }
	}
	
	private func doubles(values: [Double]) {
		// var time = 0.0
		for value in values {
			// print("value:", value)
			// let start = NSDate().timeIntervalSinceReferenceDate
			let rat = Q(floatLiteral: value)
			let ratDouble = rat.double
			// let end = NSDate().timeIntervalSinceReferenceDate
			// let _time = end - start
			let inacc = (ratDouble - value).abs
			XCTAssert(inacc < 1e-10, "\(ratDouble) != \(value)")
			print(value, ratDouble, inacc, rat)// , "took", _time)
			// time += _time
		}
		// print("total", time, "per value:", time/Double(values.count))
	}
	
	func testDoublesEasy() {
		doubles(values: [1/2, 1/3, 0.125, 0.00125, 2.0.sqrt, 3.0.sqrt, 3e32.sqrt, nextafter(0.0, DBL_MAX) ])
	}
	
	func testDoublesMid() {
		doubles(values: [1e-10])
	}
	
	func testEasyFractionsUpTo45() {
		for i in 1..<45 {
			for j in 1..<45 {
				let rat = Q(floatLiteral: i.double/j.double)
				XCTAssert(rat.numerator <= i && rat.denominator <= j, "\(rat.description) != \(i.double) / \(j.double)")
				// values.append(i.double/j.double)
			}
		}
		// doubles(values: values)
	}
}



















