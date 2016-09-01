//
//  _PolynomialTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class _PolynomialTests: XCTestCase {
	// MID_PRIO
	
	func testEqualsToPolynomial() {
		for _ in 0..<20 {
			var coefficients = [Double]()
			for _ in 0 ..< (random() & 0xF + 0xF) {
				coefficients.append((random() & 0xF + 0xF).double)
			}
			var p = Polynomial<Double>()
			var f : Function = ConstantFunction(0)
			for i in coefficients.indices.reversed() {
				p[i] = coefficients[i]
				f += coefficients[i].double * (x^i.double)
			}
			XCTAssert(p.description == f.description, "Polynomial: \(p), Function: \(f)")
			for _ in 0..<100 {
				let r = Double.random
				var pc = p.call(x: r)!.description
				var fc = f.call(x: r).description
				if pc == fc { continue }
				if pc.characters.count > 7 { pc = pc.substring(to: pc.index(pc.startIndex, offsetBy: 5)) }
				if fc.characters.count > 7 { fc = fc.substring(to: fc.index(fc.startIndex, offsetBy: 5)) }
				XCTAssert(pc == fc)
			}
		}
	}
}
