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
			if one.isNormal {
				let two = nextafter(one, DBL_MAX)
				let eq  = one == two
				let eqn = one =~ two
				XCTAssert(eqn)
				XCTAssert(!eq)
			}
		}
	}
	
	func testPrimeFactors() {
		for i in 0 ..< 100 {
			// print(i)
			let pf = i.primeFactors
			var v = 1
			for e in pf {
				v *= e
			}
			XCTAssert(v == i)
		}
	}
	
	func testPower() {
		for _ in 0 ..< 100 {
			let r = Double.random
			let p = Double.random
			let p1 = pow(r,p)
			let p2 = r.power(p)
			XCTAssert((!p1.isNormal && !p2.isNormal) || p1 == p2, "\(p1) != \(p2)")
		}
	}
		
}
