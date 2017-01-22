//
//  ComplexTests.swift
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

class ComplexTests: XCTestCase, TypeTest {
	
    static var allTests : [(String, (ComplexTests) -> () throws -> () )] {
        return [
            ("testAddition", testAddition),
            ("testDivision", testDivision),
            ("testHashValue", testHashValue),
            ("testPrefix", testPrefix),
            ("testSubtraction", testSubtraction),
            ("testReadmeExample", testReadmeExample),
            ("testMultiplication", testMultiplication),
            ("testConjugate", testConjugate),
            ("testPower", testPower),
            ("testPolarForm", testPolarForm),
            ("testDescription", testDescription),
            ("testRandom", testRandom)
        ]
    }
    
	override func setUp() {
        elements = []
		for _ in 0 ..< 30 {
			let c = Complex((Int.random & 0xFFFFFF).double)
			// print("added \(c)")
			XCTAssert(c != 0)
			elements.append(c)
		}
	}
	
	var elements : [Complex<Double>] = []
	
	// basic arithmetic
	func testAddition() {
		forAll("+", assert: { $0.real + $1.real == $2.real }) { $0 + $1 }
	}
	
	func testSubtraction() {
		forAll("-", assert: { $0.real - $1.real == $2.real }) { $0 - $1 }
	}
	
	func testMultiplication() {
		forAll("*", assert: { $0.real * $1.real == $2.real }) { $0 * $1 }
	}
	
	func testDivision() {
		forAll("/", assert: { ($0.real / $1.real) == $2.real }) { $0 / $1 }
	}
	
	func testPrefix() {
		forAll("-", assert: { $0.real == -$1.real && $0.imaginary == -$1.imaginary }) { -$0 }
	}
	
	func testPolarForm() {
		forAll("p", assert: { $0.real == $1.real && $0.imaginary == $1.imaginary }) { a -> Complex<Double> in
			return Complex<Double>(polarForm: a.polarForm)
		}
	}
	
	func testHashValue() {
		hashValueTest(for: Int	.self)
		hashValueTest(for: Int8	.self)
	}
	
	func hashValueTest < T : Numeric > (for: T.Type) {
		print(Complex<T>(T(integerLiteral: 3)).hashValue)
	}
	
	func testReadmeExample() {
		let a : Complex<Int> = -4
		XCTAssert(a.sqrt == Complex<Int>(real: 0, imaginary: 2))
	}
	
	// specials
	func testConjugate() {
		forAll("conj",assert: { $0.real == $1.real && $0.imaginary == -($1.imaginary) }) { $0.conjugate }
	}
	
	func testRandom() {
		for _ in 0..<100 {
			let r = Complex<Double>.random
			XCTAssert(r.real == r.double)
			XCTAssert(r.real.integer == r.integer)
		}
	}
	
	func testDescription() {
		XCTAssert(Complex<Double>(0).description == "0")
		XCTAssert(Complex<Int>(0).description == "0")
		for _ in 0 ..< 1000 {
			let r = Math.random() & 0xFFFF_FFFF_FFFF + 2
			let c = Complex<Int>(real: 0, imaginary: r)
			XCTAssert(c.description == "\(r)i", "\(c)")
			XCTAssert(Complex<Int>(r).description == r.reducedDescription)
			let i = Math.random() & 0xFFFF_FFFF_FFFF + 2 // 0, 1 is impossible
			let c1 = Complex<Int>(real: r, imaginary: i)
			XCTAssert(c1.description == "(\(r) + \(i)i)", "\(c1)")
			let c2 = Complex<Int>(real: r, imaginary: -i)
			XCTAssert(c2.description == "(\(r) - \(i)i)", "\(c2)")
		}
	}
	
	func testPower() {
        // print(Math.pow(0xFFF, 0xF))
        for _ in 0 ..< 10000 {
            let a = (Math.random() & 0xFFF).double
            let c = Complex(a)
            let p = (Math.random() & 0xF).double
            let p0 = c.power(p)
            let p1 = p0.real
            let p2 = a.power(p)
            let dp0 = "\(p0)"
            let dp2 = p2.reducedDescription
            // print(dp0, "?=", dap, "?=", dp2)
            XCTAssert(dp0 == dp2, "\(dp0) != \(dp2)")
            XCTAssert(!p0.imaginary.isNormal || p0.imaginary =~ 0, "Imaginary part != 0: \(p0)")
            XCTAssert((!p1.isNormal && !p2.isNormal) || p1 =~ p2, "\(p1) != \(p2)")
        }
	}
}
