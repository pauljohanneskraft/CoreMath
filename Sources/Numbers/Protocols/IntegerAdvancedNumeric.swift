//
//  AdvancedNumericTypeExtensions.swift
//  Math
//
//  Created by Paul Kraft on 25.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol IntegerAdvancedNumeric: AdvancedNumeric, FixedWidthInteger {
    init(integerLiteral: Int)
    init(floatLiteral: Double)
    
    var double: Double { get }
    var integer: Int { get }
    var isInteger: Bool { get }
}

extension IntegerAdvancedNumeric {
    public var double: Double {
        return Double(self.integer)
    }
    
    public var integer: Int {
        return hashValue
    }
    
	public var isInteger: Bool {
        return true
    }
    
    public static func random(inside range: ClosedRange<Self>) -> Self {
        let number = Self(Math.random() % Self.max.integer)
        guard !range.contains(number) else { return number }
        guard !range.upperBound.subtractingReportingOverflow(range.lowerBound).overflow else {
            let length = UInt64(range.upperBound) + UInt64(-Int64(range.lowerBound))
            return Self(UInt64(number.abs) % length) + range.lowerBound
        }
		return (number.abs % range.length) + range.lowerBound
	}
}

extension Randomizable where Self: Ordered & BasicArithmetic {
    public static func random() -> Self {
        return random(inside: .fullRange)
    }
}

extension Int: IntegerAdvancedNumeric {}
extension Int8: IntegerAdvancedNumeric {}
extension Int16: IntegerAdvancedNumeric {}
extension Int32: IntegerAdvancedNumeric {}
extension Int64: IntegerAdvancedNumeric {}
extension Decimal: BasicArithmetic {}
