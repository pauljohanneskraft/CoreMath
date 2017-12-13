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
	
    static var allTests: [(String, (MatrixTests) -> () throws -> Void )] {
        return [
            ("testSubtraction", testSubtraction),
            ("testAddition", testAddition),
            ("testDet2", testDet2),
            ("testRank", testRank),
            ("testIdentity", testIdentity),
            ("testIsSquare", testIsSquare),
            ("testOperators", testOperators),
            ("testSubscript", testSubscript),
            ("testDeterminant", testDeterminant),
            ("testEigenvalues", testEigenvalues),
            ("testDescriptions", testDescriptions),
            ("testRowEchelonForm", testRowEchelonForm),
            ("testInitArrayLiteral", testInitArrayLiteral),
            ("testScalarMultiplication", testScalarMultiplication),
            ("testReducedRowEchelonForm", testReducedRowEchelonForm)
        ]
    }
    
	override func setUp() {
		for _ in 0..<30 {
			let size = (columns: (Math.random() & 0xF) + 1, rows: (Math.random() & 0xF) + 1)
			var elem = [[Int]]()
			for _ in 0..<size.rows {
				var e = [Int]()
				for _ in 0..<size.columns {
					e.append(Math.random() % Int8.max.integer)
				}
				elem.append(e)
			}
			elements.append(DenseMatrix(elem))
		}
	}
	
	var elements: [DenseMatrix<Int>] = []
	
	let abc = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
	
	func testIdentity() {
		for i in 1..<20 {
			print(i, "started")
			let a = DenseMatrix<Int>.identity(i)
			for j in 0..<i {
				let aj = a[j]
				for k in 0..<i {
					if k == j { XCTAssertEqual(aj[k], 1) } else { XCTAssertEqual(aj[k], 0) }
				}
			}
			XCTAssert(a.inverse == a)
		}
	}
	
	func testRowEchelonForm() {
		forAll("rowEchelonFormRanksEqual", assert: { $1 == true }, {
            $0.rowEchelonForm.rank == $0.reducedRowEchelonForm.rank
        })
	}
	
	func testIsSquare() {
		XCTAssert( DenseMatrix([[1]]).isSquare)
		XCTAssert( DenseMatrix([[0, 1], [2, 3]]).isSquare)
		XCTAssert(!DenseMatrix([[0, 1, 2], [3, 4, 5]]).isSquare)
	}
	
	func testInitArrayLiteral() {
		let a = [0, 1, 2]
		let m1 = DenseMatrix(arrayLiteral: a)
		let m2 = DenseMatrix([a])
		XCTAssert(m1 == m2)
	}
	
	func testDescriptions() {
		let a: DenseMatrix<Int> = [[0]]
		let ao = a.oneLineDescription
		let ad = a.description
		XCTAssert(ao == ad.dropLast())
	}
	
	func testSubscript() {
		var mabc = DenseMatrix(abc)
		for i in abc.indices {
			XCTAssertEqual(abc[i], mabc[i])
		}
		for i in abc.indices {
			mabc[i] = abc[(abc.count - i) - 1]
		}
		for i in abc.indices {
			XCTAssertEqual(mabc[i], abc[(abc.count - i) - 1])
		}
	}
	
	func testRank() {
		let a = [
			[0, 1, 2],
			[0, 1, 2],
			[0, 2, 3]
		]
		XCTAssert(DenseMatrix(a).rank == 2, "\(DenseMatrix(a).rank) != 2")
		let b = [
			[0, 1, 2],
			[0, 1, 2],
			[0, 1, 2]
		]
		XCTAssert(DenseMatrix(b).rank == 1, "\(DenseMatrix(b).rank) != 1")
		let c = [
			[0, 0, 0], [0, 0, 0], [0, 0, 0]
		]
		XCTAssert(DenseMatrix(c).rank == 0)
	}
	
	func testReducedRowEchelonForm() {
		print(DenseMatrix(abc).reducedRowEchelonForm)
	}
    
    func testDet2() {
        let a = DenseMatrix([[0, 0], [0, 0]]).eigenvalues
        print(a!)
        
    }
	
	func testDeterminant() {
		XCTAssert(DenseMatrix([[4]]).determinant == 4)
		XCTAssert(DenseMatrix([[0, 1], [1, 0]]).determinant == -1)
		XCTAssert(DenseMatrix([[1, 2, 3], [2, 3, 4], [5, 6, 8]]).determinant == -1)
        let matr = [[4, 5, 6, 7, 8], [3, 4, 5, 8, 3], [7, 3, 4, 5, 6], [1, 2, 3, 8, 7], [3, 7, 9, 0, 4]]
		XCTAssert(DenseMatrix(matr).determinant == 1240)
		
		let a = Math.random() % 0xFFFF
		let b = Math.random() % 0xFFFF
		let c = Math.random() & 0xFFFF
		let d = Math.random() & 0xFFFF
		XCTAssert(DenseMatrix([[a, b], [c, d]]).determinant == a*d - b*c)
		
		for i in 1 ... 9 {
			var id = DenseMatrix<Double>.identity(i)
			var value = 1.0
			for j in 0..<i {
				let rdm = Double(Math.random() % 0x4F)
				value *= rdm
				id[j][j] = rdm
			}
			let start = Time()
			XCTAssert(value == id.determinant)
			let time = Time().timeIntervalSince(start)
			print(i, "time:", time)
		}
	}
	
	func testEigenvalues() {
		let b = DenseMatrix<C>([[4, 5], [3, 4]]).eigenvalues!
		print(b)
		XCTAssert((b[0] - 7.87298334620742	).abs <= 1e-14	)
		XCTAssert((b[1] - 0.127016653792583	).abs <= 1e-14	)
	}

	func testOperators() {
		operatorTest(+, +)
		operatorTest(-, -)
		operatorTest(*, *)
	}
	
	func operatorTest(_ op0: (Int, Int) -> Int, _ op1: (DenseMatrix<Int>, DenseMatrix<Int>) -> DenseMatrix<Int>) {
		for i in 0..<10 {
			for j in 10..<20 {
				XCTAssert(op0(i, j) == op1(DenseMatrix([[i]]), DenseMatrix([[j]]))[0, 0])
			}
		}
	}
	
	func testAddition() {
		forAll("+", assert: { a, b, c -> Bool in
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
		}, { a, b -> DenseMatrix<Int>? in if a.size == b.size { return a + b } else { return nil } })
	}
	
	func testSubtraction() {
		forAll("-", assert: { a, b, c -> Bool in
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
		}, { a, b -> DenseMatrix<Int>? in if a.size == b.size { return a - b } else { return nil } })
	}
	
	func testScalarMultiplication() {
		let rdm = Math.random() % 1000
		print("rdm:", rdm)
        forAll("\(rdm) *", assert: { a, b in
			let s = b.size
			for i in 0..<s.rows {
				let ai = a[i]
				let bi = b[i]
				for j in 0..<s.columns {
					guard ai[j] * rdm == bi[j] else { print(i, j); return false }
				}
			}
			return true
        }, { a -> DenseMatrix<Int> in a * rdm })
		
        forAll("\(rdm) *", assert: { a, b in
			let s = b.size
			for i in 0..<s.rows {
				let ai = a[i]
				let bi = b[i]
				for j in 0..<s.columns {
					guard ai[j] * rdm == bi[j] else { print(i, j); return false }
				}
			}
			return true
        }, { a -> DenseMatrix<Int> in rdm * a })
	}
}
