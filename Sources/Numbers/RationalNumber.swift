//
//  RationalNumber.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 06.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public typealias Q = RationalNumber

// to create a rational number simply initialize using:
//
// var myRationalNumber = Q(1,2)    /* 1/2 */
//

public struct RationalNumber : AdvancedNumeric, Ordered {
	public fileprivate(set) var numerator   : Int
	public fileprivate(set) var denominator : Int
	
	public init(numerator: Int, denominator: Int) {
		self.numerator   =   numerator
		self.denominator = denominator
	}
	
	public init(_ numerator: Int, _ denominator: Int) { self.init(numerator: numerator	, denominator: denominator	) }
	public init(_ value:	 Int					) { self.init(numerator: value		, denominator: 1			) }
	
	mutating func reduce() {
		let gcd = numerator.greatestCommonDivisor(with: denominator)
		self.numerator   /= gcd
		self.denominator /= gcd
		if self.denominator.sign {
			numerator   =   -numerator
			denominator = -denominator
		}
	}
	
	public var integer	: Int		{ return numerator			/ denominator			}
	public var double	: Double	{ return Double(numerator)	/ Double(denominator)	}
	public var isInteger: Bool		{ return self.reduced.denominator == 1 }
	
	public static var min	: RationalNumber { return Q(Int.min, 1) }
	public static var max	: RationalNumber { return Q(Int.max, 1) }
	public static var random: RationalNumber { return Q(Math.random(), Math.random()).reduced }
	
	public var reduced : RationalNumber {
		var this = self
		this.reduce()
		return this
	}
	
	public var sign			: Bool				{ return numerator < 0 ? denominator >= 0 : denominator < 0 }
	public var hashValue	: Int				{ return Double(self).hashValue								}
	public var abs			: RationalNumber	{ return Q(numerator.abs, denominator.abs)					}
}

extension RationalNumber : ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Int) {
		self.numerator = value
		self.denominator = 1
	}
}

extension RationalNumber : Equatable {}

extension RationalNumber : CustomStringConvertible {
	public var description: String {
		if denominator == 1 { return "\(numerator)" }
		if denominator == 0 { return "nan" }
		return "(\(numerator)/\(denominator))"
	}
}

extension RationalNumber : ExpressibleByFloatLiteral {
	public init(floatLiteral value: Double) {
		self.init(readable: value)
		/*
		let e = -(value.inaccuracy.exponent)
		var result : Q
		if e < 60 {
		let den = 1 << e
		let num = Int(Double(den)*value)
		result = Q(num, den)
		// print("calculated", Double(result))
		} else {
		var num : Int
		var den = 1
		repeat {
		num = Int(value * Double(den))
		result = Q(num, den)
		den *= 10
		} while (Double(result) - value).abs > value.inaccuracy
		}
		result.reduce()
		self = result
		*/
	}
}

extension Double {
	public var inaccuracy : Double {
		return nextafter(self, DBL_MAX) - self
	}
}

extension RationalNumber {
	
	// source: http://stackoverflow.com/questions/95727/how-to-convert-floats-to-human-readable-fractions
	private init(_ value: Double) {
		assert(value.isNormal)
		
		let sign        = value < 0
		var value       = value.abs
		var numerator   = 0
		var denominator = 1
		
		while value > 0 {
			let intValue = Int(value)
			value       -= Double(intValue)
			numerator   += intValue
			value       *= 2
			numerator   *= 2
			denominator *= 2
		}
		if sign { numerator = -numerator }
		self = RationalNumber(numerator: numerator, denominator: denominator)
	}
	
	// source: http://stackoverflow.com/questions/95727/how-to-convert-floats-to-human-readable-fractions
	fileprivate init(readable value: Double) {
		assert(value <= Double(Int.max))
		let accuracy = [value.inaccuracy, 1e-11].min()!
		
		let sign = value < 0
		let val = sign ? -value : value
		var n = Double(Int(val))
		var d = 1.0
		var frac = n / d
		var inacc = (frac - val).abs
		
		while inacc > accuracy {
			if frac < val {
				let a = (n / 10).integer.double
				n += a < 1 ? 1 : a
			}
			else {
				let a = (d / 10).integer.double
				d += a < 1 ? 1 : a
				n = Double(Int(val * d))
			}
			frac = n / d
			inacc = (frac - val).abs
			let maxInt = Int.max.double
			if d > maxInt || n > maxInt { break }
			// print(value, "?", frac, "=", n.reducedDescription, "/", d.reducedDescription)
		}
		
		self = RationalNumber(numerator: sign ? -n.integer : n.integer, denominator: d.integer)
		self.reduce()
	}
}

extension Numeric {
	var sign : Bool { return self < 0 }
}

public func *= (lhs: inout RationalNumber, rhs: RationalNumber) {
	let rhs = rhs.reduced
	lhs.reduce()
	lhs.denominator = rhs.denominator * lhs.denominator
	lhs.numerator = lhs.numerator * rhs.numerator
	lhs.reduce()
}

public func * (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
	var lhs = lhs
	lhs *= rhs
	return lhs
}

public func /= (lhs: inout RationalNumber, rhs: RationalNumber) {
	let rhs = rhs.reduced
	lhs.reduce()
	lhs.denominator = rhs.numerator * lhs.denominator
	lhs.numerator = lhs.numerator * rhs.denominator
	lhs.reduce()
}

public func / (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
	var lhs = lhs
	lhs /= rhs
	return lhs
}

public func += (lhs: inout RationalNumber, rhs: RationalNumber) {
	let rhs = rhs.reduced
	lhs.reduce()
	lhs.numerator = lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator
	lhs.denominator = rhs.denominator * lhs.denominator
	lhs.reduce()
}

public func + (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
	var lhs = lhs
	lhs += rhs
	return lhs
}

public func -= (lhs: inout RationalNumber, rhs: RationalNumber) {
	let rhs = rhs.reduced
	lhs.reduce()
	lhs.numerator = lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator
	lhs.denominator = rhs.denominator * lhs.denominator
	lhs.reduce()
}

prefix public func - (lhs: RationalNumber) -> RationalNumber {
	var lhs = lhs
	if lhs.denominator < 0 { lhs.denominator = -lhs.denominator }
	else { lhs.numerator = -lhs.numerator }
	return lhs
}

public func - (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
	var lhs = lhs
	lhs -= rhs
	return lhs
}

public func == (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
	guard lhs.sign == rhs.sign else { return false }
	guard lhs.numerator != rhs.numerator || lhs.denominator != rhs.denominator else { return true }
	return lhs.numerator == -rhs.numerator && lhs.denominator == -rhs.denominator
}

public func < (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
	return lhs.double < rhs.double
}

public func % (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
	var lhs = lhs; lhs %= rhs; return lhs
}

public func %= (lhs: inout RationalNumber, rhs: RationalNumber) {
	lhs -= rhs * Q( (lhs / rhs).integer )
}

extension Double {
	public init(_ rat: RationalNumber) { self = rat.double }
}
