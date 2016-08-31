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
		for i in 0..<100 {
			let a = Matrix<Int>.identity(i)
			for j in 0..<i {
				let aj = a[j]
				for k in 0..<i {
					if k == j { XCTAssert(aj[k] == 1) }
					else      { XCTAssert(aj[k] == 0) }
				}
			}
		}
	}
	
	func testRowEchelonForm() {
		let a = Matrix(abc)
		let aref = a.rowEchelonForm
		let asref = a.strictRowEchelonForm
		XCTAssert(aref.rank == 2 && asref.rank == 2)
	}
	
}
