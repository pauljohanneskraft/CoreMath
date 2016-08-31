//
//  ComplexTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class ComplexTests: XCTestCase, TypeTest {
	typealias N = R
	
	override func setUp() {
		for _ in 0 ..< 30 {
			var elem : N
			repeat {
				elem = N.random
			} while !elem.isNormal || elem < -1e6 || elem > 1e6 || elem.abs < 1
			let c = Complex(elem.integer.double)
			// print("added \(c)")
			XCTAssert(c != 0)
			elements.append(c)
		}
	}
	
	var elements : [Complex<N>] = []
	
	// basic arithmetic
	func testAddition() {
		forAll("+", assert: { $0.real + $1.real == $2.real }) { $0 + $1 }
	}
	
	func testSubtraction() {
		forAll("-", assert: { $0.real - $1.real == $2.real }) { $0 - $1 }
	}
	
	func testMultiplication()   {
		forAll("*", assert: { $0.real * $1.real == $2.real }) { $0 * $1 }
	}
	
	func testDivision()         {
		forAll("/", assert: { $0.real == 0.0 || $1.real == 0.0 || (($0.real / $1.real) - $2.real).isZero }) { $0 / $1 }
	}
	
	func testPrefix()         {
		forAll("-", assert: { $0.real == -$1.real && $0.imaginary == -$1.imaginary }) { -$0 }
	}
	
	func testPolarForm() {
		forAll("p", assert: { $0.real == $1.real && ($0.imaginary - $1.imaginary).abs <= 1e-9 }) { a -> Complex<N> in Complex<N>(polarForm: a.polarForm) }
	}
	
	func testHashValue() {
		hashValueTest(for: Int.self)
		hashValueTest(for: Int8.self)
	}
	
	func hashValueTest< T : Numeric >(for: T.Type) {
		print(Complex<T>(T(integerLiteral: 3)).hashValue)
	}
	
	func testReadmeExample() {
		let a : Complex<Int> = -4
		XCTAssert(a.sqrt == Complex<Int>(real: 0, imaginary: 2))
	}
	
	// specials
	func testConjugate()        { forAll("conj",assert: { $0.real == $1.real && $0.imaginary == -($1.imaginary) }) { $0.conjugate } }}
