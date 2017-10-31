//
//  NumericTests.swift
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

class NumericTests: XCTestCase, TypeTest {
	
	typealias Number = Int
	
	var elements: [Number] = []
    
    static var allTests : [(String, (NumericTests) -> () throws -> () )] {
        return [
            ("testPrettyMuchEquals", testPrettyMuchEquals),
            ("testPower", testPower),
            ("testPrimeFactors", testPrimeFactors)
        ]
    }
	
	func testPrettyMuchEquals() {
		for _ in  0 ..< 1000 {
			let one = Double.random
			if one.isNormal {
				let two = nextafter(one, Double.greatestFiniteMagnitude)
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
			let p1 = Math.pow(r,p)
			let p2 = r.power(p)
			XCTAssert((!p1.isNormal && !p2.isNormal) || p1 == p2, "\(p1) != \(p2)")
		}
	}
	/*
	func testPrimeFactorVariants() {
		func one(_ number: Int) -> [Int] {
			var this = number
			var factors = [Int]()
			
			if this < 0 {
				factors.append(-1)
				this = -this
			}
			
			while this % 2 == 0 {
				factors.append(2)
				this /= 2
			}
			
			var i = 3
			
			while i <= number.sqrt {
				while this % i == 0 {
					factors.append(i)
					this /= i
				}
				i += 2
			}
			
			if this != 1 { factors.append(this) }
			
			return factors
		}
		
		func two (_ this: Int) -> [Int] {
			var this = this
			var i = 0
			var primes = Int.getPrimes(upTo: this.sqrt)
			var factors = [Int]()
			while this > 1 && primes.count > i {
				let p = primes[i]
				if this % p == 0 {
					this /= p
					factors.append(p)
				} else { i += 1 }
			}
			if this != 1 { factors.append(this) }
			return factors
		}
		
		func three (_ number: Int) -> [Int] {
			var this = number
			var factors = [Int]()
			
			var i = 2
			while i <= number.sqrt {
				while this % i == 0 {
					factors.append(i)
					this /= i
				}
				i = Int.getNextPrime(from: i)
			}
			
			if this != 1 { factors.append(this) }
			
			return factors
		}
		
		var t1 = 0.0
		var t2 = 0.0
		var t3 = 0.0
		
		for _ in 0..<10 {
			let rdm = Int(Math.random() & 0xFFFF)
			let start = Time()
			let r1 = one(rdm)
			let mid1 = Time()
			let r2 = two(rdm)
			let mid2 = Time()
			let r3 = three(rdm)
			let end = Time()
			// print(rdm)
			let t1r = mid1.timeIntervalSince(start)
			t1 += t1r
			// print("\t", t1r, r1)
			let t2r = mid2.timeIntervalSince(mid1)
			t2 += t2r
			// print("\t", t2r, r2)
			let t3r = end.timeIntervalSince(mid2)
			t3 += t3r
			// print("\t", t3r, r3)
			XCTAssert(r1 == r2 && r2 == r3)
		}
		
		print("total: ", t1, t2, t3)
		
		// (real) example results:
		// total:  0.0500999689102173 9.89606004953384 9.95908206701279 // --> one(_:) is way faster!
		
	}
		*/
}
