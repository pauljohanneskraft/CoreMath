//
//  AdvancedNumericTypeExtensions.swift
//  Math
//
//  Created by Paul Kraft on 25.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol IntegerAdvancedNumeric : AdvancedNumeric, Integer, Ordered {
	init(_: Int)
}

public extension IntegerAdvancedNumeric {
	init(integerLiteral: Int) { self.init(integerLiteral) }
	init(floatLiteral: Double) {
		self.init(integerLiteral: Int(floatLiteral))
	}
	public var double : Double { return Double(self.integer) }
	public var integer : Int { return hashValue }
	public var isInteger : Bool { return true }
	public static var random : Self {
		return Self(integerLiteral: Math.random() % Self.max.integer)
	}
}

extension Int   : IntegerAdvancedNumeric {}
extension Int8	: IntegerAdvancedNumeric {}
extension Int16	: IntegerAdvancedNumeric {}
extension Int32 : IntegerAdvancedNumeric {}
extension Int64 : IntegerAdvancedNumeric {}

extension Double : AdvancedNumeric, Ordered {
	public init(integerLiteral: Int) {
		self.init(integerLiteral)
	}
	
	public var sqrt : Double { return pow(self, 1.0/2) }
	
	public static var random : Double {
		return unsafeBitCast(Math.random(), to: Double.self)
	}
	
	public var reducedDescription : String {
		guard !isInteger	else { return integer.description }
		return description
	}
	
	public var isInteger : Bool {
		return isNormal && Double(integerLiteral: self.integer) == self
	}
	
	public var integer : Int    {
		precondition(self != Double.nan, "Cannot return an Int-value for Double.nan.")
		if self > Double(Int.max)	{ return Int.max }
		if self < Double(Int.min)	{ return Int.min }
		return Int(self)
	}
	public var double  : Double		{ return self }
	
	public static var min : Double	{ return DBL_MIN }
	public static var max : Double	{ return DBL_MAX }
}

public func % (lhs: Double, rhs: Double) -> Double {
	return lhs.truncatingRemainder(dividingBy: rhs)
}
