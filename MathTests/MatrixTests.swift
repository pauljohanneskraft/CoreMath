//
//  MatrixTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class MatrixTests: XCTestCase {
	
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
		let a = Matrix(abc)
		let aref = a.rowEchelonForm
		let asref = a.reducedRowEchelonForm
		XCTAssert(aref.rank == 2 && asref.rank == 2)
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
	
	func testStrictRowEchelonForm() {
		print(Matrix(abc).reducedRowEchelonForm)
	}
	
	func testDeterminant() {
		XCTAssert(Matrix([[4]]).determinant == 4)
		XCTAssert(Matrix([[0,1], [1,0]]).determinant == -1)
		XCTAssert(Matrix([[1,2,3], [2,3,4], [5,6,8]]).determinant == -1)
		XCTAssert(Matrix([[4,5,6,7,8], [3,4,5,8,3], [7,3,4,5,6], [1,2,3,8,7], [3,7,9,0,4]]).determinant == 1240)
	}
	
	func testEigenvalues() {
		let b = Matrix<C>([[4,5], [3,4]]).eigenvalues!
		print(b)
		XCTAssert((b[0] - 7.87298334620742	).abs <= 1e-14	)
		XCTAssert((b[1] - 0.127016653792583	).abs <= 1e-14	)
	}
	
}
