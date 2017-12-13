//
//  AdvancedNumericTypeExtensions.swift
//  Math
//
//  Created by Paul Kraft on 25.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol IntegerAdvancedNumeric: AdvancedNumeric, BinaryInteger {
    static var random: Self { get }
    init(integerLiteral: Int)
    init(floatLiteral: Double)
    var double: Double { get }
    var integer: Int { get }
    var isInteger: Bool { get }
}

public extension IntegerAdvancedNumeric {
	public var double: Double { return Double(self.integer) }
	public var integer: Int { return hashValue }
	public var isInteger: Bool { return true }
	public static var random: Self {
		return Self(integerLiteral: Math.random() % Self.max.integer)
	}
}

extension Int: IntegerAdvancedNumeric {}
extension Int8: IntegerAdvancedNumeric {}
extension Int16: IntegerAdvancedNumeric {}
extension Int32: IntegerAdvancedNumeric {}
extension Int64: IntegerAdvancedNumeric {}

extension Double: AdvancedNumeric, Ordered {
    public init(integerLiteral: Int) {
        self.init(integerLiteral)
    }
    
	public var sqrt: Double { return pow(self, 1.0/2) }
	
	public static var random: Double {
        let sign = Math.random() % 2 == 0 ? 1.0 : -1.0
        let r0 = Double(Int.random & 0xFFFFF)
        let r1 = Double(Int.random & 0xFFFFF)
        let r2 = Double(Int.random & 0xFFFFF)
        return sign * (r0 + (r1 / (r2 + 0.001)))
	}
	
	public var reducedDescription: String {
        let float = Float(self)
		guard !float.isInteger	else { return integer.description }
		return float.description
	}
	
	public var isInteger: Bool {
		return !isNaN && !isInfinite && truncatingRemainder(dividingBy: 1) == 0
	}
	
	public var integer: Int {
		precondition(self != Double.nan, "Cannot return an Int-value for Double.nan.")
		if self >= Double(Int.max) { return Int.max }
		if self <= Double(Int.min) { return Int.min }
		return Int(self)
	}
	public var double: Double { return self }
	
	public static var min: Double { return Double.leastNormalMagnitude }
	public static var max: Double { return Double.greatestFiniteMagnitude }
}

public func % (lhs: Double, rhs: Double) -> Double {
	return lhs.truncatingRemainder(dividingBy: rhs)
}

public func %= (lhs: inout Double, rhs: Double) {
	lhs.formTruncatingRemainder(dividingBy: rhs)
}

public func % (lhs: Float, rhs: Float) -> Float {
    return lhs.truncatingRemainder(dividingBy: rhs)
}

public func %= (lhs: inout Float, rhs: Float) {
    lhs.formTruncatingRemainder(dividingBy: rhs)
}

extension Float: AdvancedNumeric {
    public static var min: Float {
        return Float.leastNormalMagnitude
    }
    
    public static var max: Float {
        return Float.greatestFiniteMagnitude
    }
    
    public var integer: Int {
        return Int(self)
    }
    
    public var isInteger: Bool {
        return !isNaN && !isInfinite && truncatingRemainder(dividingBy: 1) == 0
    }
    
    public var double: Double {
        return Double(self)
    }
    
    public static var random: Float {
        return Float(Double.random)
    }
}

extension Decimal: BasicArithmetic {}
