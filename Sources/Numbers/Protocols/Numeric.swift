//
//  Numeric.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 04.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol Numeric : BasicArithmetic, Randomizable {
	var integer		: Int		{ get }
	var isInteger	: Bool		{ get }
	var double		: Double	{ get }
	var sqrt		: Self		{ get }
	func power(_ v: Double) -> Self
}

extension Numeric {
	public var sqrt : Self {
		return Self(floatLiteral: pow(self.double, 1.0/2))
	}
	
	public func power(_ v: Double) -> Self {
		return Self(floatLiteral: pow(self.double, v))
	}
	
	public var primeFactors : [Int] {
		guard self.isInteger else { return [] }
		var this = self.integer
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
	
	public static func getPrimes(upTo: Int) -> [Int] {
		// print("did start", upTo)
		if upTo <= 1 { return [] }
		
		var res = [2]
		var last = 1
		
		repeat {
			last = Int.getNextPrime(from: last)
			if last > upTo { return res }
			res.append(last)
		} while true
	}
	
	public static func getNextPrime(from: Int) -> Int {
		guard from > 3 else { return from < 2 ? 2 : from < 3 ? 3 : 5 }
		var candidate = from % 2 == 0 ? from - 1 : from
		var test = 3
		while true {
			test = 3
			candidate += 2
			// print("next prime candidate", candidate, "from", from)
			while candidate % test != 0 && test < candidate { test += 2 }
			if candidate == test { return candidate }
		}
	}
}
