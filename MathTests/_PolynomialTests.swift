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
    
    static var allTests: [(String, (_PolynomialTests) -> () throws -> Void )] {
        return [
            ("testEqualsToPolynomial", testEqualsToPolynomial)
        ]
    }
	
	func testEqualsToPolynomial() {
		for _ in 0..<200 {
			// print(".", terminator: "")
			var coefficients = [Int]()
			for _ in 0 ..< (Math.random() & 0xF) {
				coefficients.append((Math.random() & 0xF))
			}
			var p = Polynomial<Double>()
			var f: Function = ConstantFunction(0)
			for i in coefficients.indices.reversed() {
				p[i] = coefficients[i].double
				f += coefficients[i].double * (x^i.double)
			}
			XCTAssert(p.description == f.description, "Polynomial: \(p), Function: \(f)")
			for _ in 0..<100 {
				let r = (Math.random() & 0xF).double
				let pc = p.call(x: r)!.integer
				let fc = f.call(x: r).integer
				if pc < 0xFFF { XCTAssert(pc == fc, "\(pc) != \(fc)") }
			}
			let pd = p.derivative
			let fd = f.derivative
			XCTAssert(pd.description == fd.description, "\n\(pd)\n != \n\(fd)")
		}
		// print()
	}
}
