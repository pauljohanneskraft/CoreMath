//
//  MatrixTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class MatrixTests: XCTestCase, TypeTest {
	
	override func setUp() {
		for _ in 0..<30 {
			let size = (columns: (random() & 0xF) + 1, rows: (random() & 0xF) + 1)
			var elem = [[Int]]()
			for _ in 0..<size.rows {
				var e = [Int]()
				for _ in 0..<size.columns {
					e.append(random() % Int8.max.integer)
				}
				elem.append(e)
			}
			elements.append(Matrix(elem))
		}
	}
	
	var elements : [Matrix<Int>] = []
	
	let abc = [[0,1,2], [3,4,5], [6,7,8]]
	
	func testIdentity() {
		for i in 1..<20 {
			print(i, "started")
			let a = Matrix<Int>.identity(i)
			for j in 0..<i {
				let aj = a[j]
				for k in 0..<i {
					if k == j { XCTAssert(aj[k] == 1) }
					else      { XCTAssert(aj[k] == 0) }
				}
			}
			XCTAssert(a.inverse == a)
		}
	}
	
	func testRowEchelonForm() {
		forAll(assert: { $1 == true }) { $0.rowEchelonForm.rank == $0.reducedRowEchelonForm.rank }
	}
	
	func testIsSquare() {
		XCTAssert( Matrix([[1]]).isSquare)
		XCTAssert( Matrix([[0,1],[2,3]]).isSquare)
		XCTAssert(!Matrix([[0,1,2],[3,4,5]]).isSquare)
	}
	
	func testInitArrayLiteral() {
		let a = [0,1,2]
		let m1 = Matrix(arrayLiteral: a)
		let m2 = Matrix([a])
		XCTAssert(m1 == m2)
	}
	
	func testDescriptions() {
		let a : Matrix<Int> = [[0]]
		let ao = a.oneLineDescription
		let ad = a.description
		XCTAssert(ao == ad.substring(to: ad.index(ad.endIndex, offsetBy: -1)))
	}
	
	func testSubscript() {
		var mabc = Matrix(abc)
		for i in abc.indices {
			XCTAssert(abc[i] == mabc[i])
		}
		for i in abc.indices {
			mabc[i] = abc[(abc.count - i) - 1]
		}
		for i in abc.indices {
			XCTAssert(mabc[i] == abc[(abc.count - i) - 1])
		}
	}
	
	func testRank() {
		let a = [
			[0,1,2],
			[0,1,2],
			[0,2,3]
		]
		XCTAssert(Matrix(a).rank == 2, "\(Matrix(a).rank) != 2")
		let b = [
			[0,1,2],
			[0,1,2],
			[0,1,2]
		]
		XCTAssert(Matrix(b).rank == 1, "\(Matrix(b).rank) != 2")
		let c = [
			[0,0,0], [0,0,0], [0,0,0]
		]
		XCTAssert(Matrix(c).rank == 0)
	}
	
	func testReducedRowEchelonForm() {
		print(Matrix(abc).reducedRowEchelonForm)
	}
	
	func testDeterminant() {
		XCTAssert(Matrix([[4]]).determinant == 4)
		XCTAssert(Matrix([[0,1], [1,0]]).determinant == -1)
		XCTAssert(Matrix([[1,2,3], [2,3,4], [5,6,8]]).determinant == -1)
		XCTAssert(Matrix([[4,5,6,7,8], [3,4,5,8,3], [7,3,4,5,6], [1,2,3,8,7], [3,7,9,0,4]]).determinant == 1240)
		
		let a = random() % 0xFFFF
		let b = random() % 0xFFFF
		let c = random() & 0xFFFF
		let d = random() & 0xFFFF
		XCTAssert(Matrix([[a,b],[c,d]]).determinant == a*d - b*c)
		
		for i in 1 ..< 9 {
			var id = Matrix<Double>.identity(i)
			var value = 1.0
			for j in 0..<i {
				let rdm = Double(random() % 0x4F)
				value *= rdm
				id[j][j] = rdm
			}
			let start = NSDate().timeIntervalSinceReferenceDate
			XCTAssert(value == id.determinant)
			let time = NSDate().timeIntervalSinceReferenceDate - start
			print(i, "time:", time)
		}
	}
	
	func testEigenvalues() {
		let b = Matrix<C>([[4,5], [3,4]]).eigenvalues!
		print(b)
		XCTAssert((b[0] - 7.87298334620742	).abs <= 1e-14	)
		XCTAssert((b[1] - 0.127016653792583	).abs <= 1e-14	)
	}

	func testOperators() {
		operatorTest({ $0 + $1 }) { $0 + $1 }
		operatorTest({ $0 - $1 }) { $0 - $1 }
		operatorTest({ $0 * $1 }) { $0 * $1 }
	}
	
	func operatorTest(_ op0: (Int, Int) -> Int, _ op1: (Matrix<Int>, Matrix<Int>) -> Matrix<Int>) {
		for i in 0..<10 {
			for j in 10..<20 {
				XCTAssert(op0(i,j) == op1(Matrix([[i]]), Matrix([[j]]))[0][0])
			}
		}
	}
	
	func testAddition() {
		forAll("+", assert: { a,b,c -> Bool in
			if c == nil { return true }
			let c = c!
			let s = c.size
			for i in 0..<s.rows {
				let ai = a[i]
				let bi = b[i]
				let ci = c[i]
				for j in 0..<s.columns {
					guard ci[j] == ai[j] + bi[j] else { return false }
				}
			}
			return true
		}) { a,b -> Matrix<Int>? in if a.size == b.size { return a + b } else { return nil } }
	}
	
	func testSubtraction() {
		forAll("-", assert: { a,b,c -> Bool in
			if c == nil { return true }
			let c = c!
			let s = c.size
			for i in 0..<s.rows {
				let ai = a[i]
				let bi = b[i]
				let ci = c[i]
				for j in 0..<s.columns {
					guard ci[j] == ai[j] - bi[j] else { return false }
				}
			}
			return true
		}) { a,b -> Matrix<Int>? in if a.size == b.size { return a - b } else { return nil } }
	}
	
	func testScalarMultiplication() {
		let rdm = random() % 1000
		print("rdm:", rdm)
		forAll("\(rdm) *", assert: { a,b -> Bool in
			let s = b.size
			for i in 0..<s.rows {
				let ai = a[i]
				let bi = b[i]
				for j in 0..<s.columns {
					guard ai[j] * rdm == bi[j] else { print(i,j); return false }
				}
			}
			return true
		}) { a -> Matrix<Int> in return rdm * a }
		
		forAll("\(rdm) *", assert: { a,b -> Bool in
			let s = b.size
			for i in 0..<s.rows {
				let ai = a[i]
				let bi = b[i]
				for j in 0..<s.columns {
					guard ai[j] * rdm == bi[j] else { print(i,j); return false }
				}
			}
			return true
		}) { a -> Matrix<Int> in return a * rdm }
	}
}
