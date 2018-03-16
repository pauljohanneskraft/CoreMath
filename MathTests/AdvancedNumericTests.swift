//
//  AdvancedNumericTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

#if os(Linux)
import Glibc
#endif

class AdvancedNumericTests: XCTestCase {
	// MID_PRIO
	
    static var allTests: [(String, (AdvancedNumericTests) -> () throws -> Void )] {
        return [
            ("testDoubleRemainder", testDoubleRemainder),
            ("testMod", testMod),
            ("testNearlyEquals", testNearlyEquals),
            ("testConformanceToAdvancedNumeric", testConformanceToAdvancedNumeric)
        ]
    }
    
	func testConformanceToAdvancedNumeric() {
		conformsToAdvancedNumeric(Int   .self)
		conformsToAdvancedNumeric(Int8  .self)
		conformsToAdvancedNumeric(Int16 .self)
		conformsToAdvancedNumeric(Int32 .self)
		conformsToAdvancedNumeric(Int64 .self)
	}
	
	func conformsToAdvancedNumeric<N: AdvancedNumeric>(_ type: N.Type) {
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
	
	func mod< N: AdvancedNumeric >(on type: N.Type) {
		XCTAssertEqual(N(20).mod(5), 0)
		XCTAssertEqual(N(-10).mod(3), 2)
	}
	
	func testDoubleRemainder() {
		for _ in 0 ..< 100 {
            let r = Double.random(inside: -1_000...1_000)
            let q = Double.random(inside: -1_000...1_000)
            if q == 0.0 { continue }
			var p = r
			p %= q
			XCTAssertEqual(p, p % q)
		}
	}
	
	func testNearlyEquals() {
		XCTAssert(!(0.0 =~ 1.0))
		let m = 0xFFFF_FFFF_FFFF.double
		XCTAssert(!(m =~ m + 1), "\(m)")
		for _ in 0 ..< 100 {
            let a = Int.random(inside: 0...0xFFFF_FFFF_FFFF).double
			XCTAssert(!(a =~ a + 1), "\(a) == \(a + 1)")
		}
	}
	
    /*
	func testDecimal() {
		let d = Decimal()
		print(d)
		var total = Decimal()
		for _ in 0..<100 {
			// print(Decimal(Double.random))
			let dec = Decimal(Double.random)
			let one = (dec.nextUp - dec)/dec
			total += one
		}
		print(total / 100)
		print(total.nextUp - total)
		let a = Double("\(total)")!
		print(a)
		print(nextafter(a, DBL_MAX) - a)
	}
     */
}
