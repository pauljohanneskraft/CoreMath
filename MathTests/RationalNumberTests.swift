//
//  RationalNumberTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

#if os(Linux)
    import Glibc
#endif

class RationalNumberTests: XCTestCase, TypeTest {
    
    static var allTests: [(String, (RationalNumberTests) -> () throws -> Void )] {
        return [
            ("testAddition", testAddition),
            ("testDivision", testDivision),
            ("testSubtraction", testSubtraction),
            ("testMultiplication", testMultiplication),
            ("testPrefixMinus", testPrefixMinus),
            ("testInits", testInits),
            ("testMinMax", testMinMax),
            ("testInteger", testInteger),
            ("testRemainder", testRemainder),
            ("testDoublesMid", testDoublesMid),
            ("testDoublesEasy", testDoublesEasy),
            ("testEasyFractionsUpTo45", testEasyFractionsUpTo45)
        ]
    }
    
	override func setUp() {
		for _ in 0 ..< 30 { elements.append(Q(Int.random % Int16.max.integer)) }
	}
	var elements: [RationalNumber] = []
	
	// basic arithmetic
	func testAddition() {
        forAll("+", assert: { (a: RationalNumber, b: RationalNumber, c: RationalNumber) -> Bool in
            ((a.double + b.double) - (c.double)) < 1e-10 }, +)
	}
	func testSubtraction() {
        forAll("-", assert: { (a: RationalNumber, b: RationalNumber, c: RationalNumber) -> Bool in
            ((a.double - b.double) - (c.double)).abs < 1e-10 }, -)
	}
	func testMultiplication() {
        forAll("*", assert: { (a: RationalNumber, b: RationalNumber, c: RationalNumber) -> Bool in
            ((a.double * b.double) - (c.double)).abs < 1e-10 }, *)

	}
	func testDivision() {
		forAll("/", assert: { (a: RationalNumber, b: RationalNumber, c: RationalNumber) -> Bool in
            ((a.double / b.double) - (c.double)).abs < 1e-10 }, /)
	}
	func testPrefixMinus() {
		forAll("-", assert: { (a: RationalNumber, b: RationalNumber) -> Bool in a.double == -b.double }, { -$0 })
	}
	func testRemainder() {
		forAll("%", assert: { (a: RationalNumber, b: RationalNumber, c: RationalNumber) -> Bool in
            a.double % b.double == c.double }, %)
	}
	
	private func doubles(values: [Double]) {
		// var time = 0.0
		for value in values {
			// print("value:", value)
			// let start = Time()
			let rat = Q(floatLiteral: value)
			let ratDouble = rat.double
			// let end = Time()
			// let _time = end.timeIntervalSince(start)
			let inacc = (ratDouble - value).abs
			XCTAssert(inacc < 1e-10, "\(ratDouble) != \(value)")
			// print(value, ratDouble, inacc, rat)// , "took", _time)
			// time += _time
		}
		// print("total", time, "per value:", time/Double(values.count))
	}
	
	func testDoublesEasy() {
        let testValues = [
            1.0/2, 1.0/3, 0.125, 0.00125, 2.0.sqrt,
            3.0.sqrt, 3e32.sqrt, nextafter(0.0, Double.greatestFiniteMagnitude)
        ]
		doubles(values: testValues)
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
	
	func testMinMax() {
		XCTAssert(Q.min.integer == Int.min)
		XCTAssert(Q.max.integer == Int.max)
	}
	
	func testInteger() {
		for _ in 0 ..< 10000 {
			let a = Math.random() & 0xFFFF * (Math.random() % 2 == 0 ? -1 : 1)
			let b = Math.random() & 0xFFFF + 1 // no division by 0 possible
			let q = Q(a, b).reduced
			let r = a / b
			XCTAssert(q.integer == r, "Q(\(a), \(b)).integer != \(r)")
			XCTAssert(q.sign == (q.double < 0),
                      "sign: \(q.sign) != \(r < 0), number \(q.double.reducedDescription): \(q) ?= \(r)")
		}
	}
	
	func testInits() {
		for _ in 0 ..< 100 {
			let r = Math.random() & 0xFFFF
			let q = Q(r)
			XCTAssert(q == Q(integerLiteral: r))
			XCTAssert(q == Q(r, 1))
			XCTAssert(q == RationalNumber(numerator: r, denominator: 1))
			XCTAssert(q.double == q.double)
		}
	}
}
