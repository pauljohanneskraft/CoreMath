//
//  PolynomialTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class PolynomialTests: XCTestCase {
	// MID_PRIO
	
	func testDescription() {
        measure {
            for i in 1 ..< 100 {
                let a = Polynomial<Double>(integerLiteral: i)
                XCTAssert(a.description == i.description)
            }
        }
	}
    
    func testConstantZeros() {
        measure {
            for i in 1...20 {
                XCTAssertEqual(Polynomial<Double>(Double(i)).zeros, [])
            }
        }
    }
    
    func testComplexZeros() {
        measure {
            for _ in 0..<20 {
                let a = C((Int.random.abs % 20) + 1) * (Int.random % 2 == 0 ? -1 : 1)
                XCTAssertNotEqual(a, 0)
                let c = C(Int.random % 20)
                let b = C(Double(Int((a * c).double.abs.sqrt)))
                let poly = Polynomial<C>([c, b, a])
                
                let ds = (b*b - 4 * a * c).sqrt
                let zero0 = ( -b + ds ) / ( 2 * a )
                let zero1 = ( -b - ds ) / ( 2 * a )
                XCTAssertEqual(poly.zeros, [zero0, zero1])
            }
        }
    }
    
    func testFactorZeros() {
        measure {
            for _ in 0..<10 {
                let zeros = (0..<10).map { _ in Double(Int.random % 12) }
                let polynomial = zeros.reduce(into: Polynomial<Double>(1)) {
                    $0 *= Polynomial<Double>([-$1, 1])
                }
                // print(polynomial)
                XCTAssertEqual(zeros.sorted(), polynomial.zeros.sorted())
            }
        }
    }
	
	func testSubscript() {
        measure {
            for i in 1 ..< 30 {
                var array = [Int]()
                for _ in 0 ..< i {
                    array.append(Math.random())
                }
                let p = Polynomial(array)
                for j in 0 ..< i {
                    XCTAssert(p[j] == array[j])
                }
                var q = Polynomial<Int>()
                for j in Set(0..<i) {
                    q[j] = array[j]
                }
                XCTAssert(q == p)
            }
        }
	}
	
	func testReduced() {
        measure {
            var q = Polynomial<Int>()
            q[10] = 0
            XCTAssert(q.coefficients.count == 11)
            q.reduce()
            XCTAssert(q.coefficients.count == 1)
        }
	}
	
	func testLaTeX() {
		var equals = false
		var greater = false
		var less = false
		while !equals || !greater || !less {
			let a = Math.random() & 0xFF + 0xF
			let b = Math.random() & 0xFF + 0xF
			let c = Math.random() & 0xFF + 0xF
			let d = Math.random() & 0xFF + 0xF
			let latex = Polynomial<Int>((a, b), (c, d)).latex
			if b == d {
				equals = true
				// print("equals")
				XCTAssert(latex == "\(a + c)x^{\(b)}", latex)
			} else if b > d {
				greater = true
				// print("greater")
				XCTAssert(latex == "\(a)x^{\(b)} + \(c)x^{\(d)}", latex)
			} else {
				less = true
				// print("less")
				XCTAssert(latex == "\(c)x^{\(d)} + \(a)x^{\(b)}", latex)
			}
		}
		for i in 0 ..< 10 {
			XCTAssert(Polynomial<Int>(integerLiteral: i).latex == i.description)
		}
	}
	
	func testComparable() {
		for _ in 0..<0xF {
			var p = Polynomial<Int>()
			for j in 0..<10 { p[j] = Math.random() & 0xF }
			XCTAssert(!(p < p))
			var q = p
			q[0] = p[0] + 1
			XCTAssert(p < q && q > p)
			q = p
			q[10] = 1
			XCTAssert(q > p && p < q)
		}
	}
	
	func testAddition() {
		for _ in 0..<0xF {
			var p = Polynomial<Int>()
			for j in 0..<10 { p[j] = Math.random() & 0xF }
			XCTAssert((p * 2) == (p + p))
			XCTAssert(((p + p) - p) == p)
			XCTAssert(p - p == 0)
		}
	}
	
	func testFields() {
		for _ in 0..<100 {
			let rdm = Math.random() & 0xF
			XCTAssert(Double.x(rdm) == Polynomial<Double>((1.0, rdm)))
		}
	}
	
}
