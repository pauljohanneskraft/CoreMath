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
		return Self(integerLiteral: Int(arc4random() % UInt32(Self.max.integer)))
	}
}

extension Int    : AdvancedNumeric {
	init?<N : Numeric>(_ v: N) { self = v.integer }
	
	public var integer : Int {
		return self
	}
	public var double : Double {
		return Double(self)
	}
	
	public static var random : Int {
		return (arc4random() % 2 == 0 ? 1 : -1) * Int(arc4random() % UInt32(UInt8.max))
	}
	
	var isInteger : Bool { return true }
	
	public init(floatLiteral: Double) {
		self = Int(floatLiteral)
	}
}

extension Int8	: IntegerAdvancedNumeric {}
extension Int16	: IntegerAdvancedNumeric {}
extension Int32 : IntegerAdvancedNumeric {}
extension Int64 : IntegerAdvancedNumeric {}

extension Double : AdvancedNumeric {
	public init(integerLiteral: Int) {
		self.init(integerLiteral)
	}
	
	public static var random : Double {
		var z : Double? = nil
		while z == nil || z!.isNaN || z!.isInfinite {
			z = ((Double(Int.random) / Double(Int.random)) * (Double(Int.random) / Double(Int.random)))
		}
		return z!
	}
	
	public var integer : Int    {
		if self > Double(Int.max) { return Int.max }
		if self < Double(Int.min) { return Int.min }
		return Int(self)
	}
	public var double  : Double  { return self }
	
	static var minValue : Double { return DBL_MAX }
	static var maxValue : Double { return DBL_MIN }
}
