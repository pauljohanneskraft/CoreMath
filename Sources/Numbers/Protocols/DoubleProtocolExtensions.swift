//
//  DoubleExtensions.swift
//  Math
//
//  Created by Paul Kraft on 21.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Double: BasicArithmetic {
    public init(integerLiteral: Int) {
        self.init(integerLiteral)
    }
}

extension Double: Randomizable {
    public static func random(inside range: ClosedRange<Double>) -> Double {
        guard !range.isPoint else { return range.lowerBound }
        var random = Math.random()
        var double = random.memoryRebound(to: Double.self)
        while !double.isReal {
            random = Math.random()
            double = random.memoryRebound(to: Double.self)
        }
        let result = range.lowerBound + double.remainder(dividingBy: range.length).abs
        precondition(range.contains(result), "\(result) is not in \(range)")
        return result
    }
}

extension Double: Numeric {
    public var isInteger: Bool {
        return isReal && truncatingRemainder(dividingBy: 1) == 0
    }
    
    public var integer: Int {
        precondition(!isNaN, "Cannot return an Int-value for Double.nan.")
        if self >= Double(Int.max) { return Int.max }
        if self <= Double(Int.min) { return Int.min }
        return Int(self)
    }
    
    public var double: Double { return self }
}

extension Double: AdvancedNumeric {
    public var sqrt: Double {
        return pow(self, 0.5)
    }
 
    public var reducedDescription: String {
        let float = Float(self)
        guard !float.isInteger    else { return integer.description }
        return float.description
    }
}

extension Double: Ordered {
    public static var min: Double { return .leastNormalMagnitude }
    public static var max: Double { return .greatestFiniteMagnitude }
}

extension Double {
    public static func % (lhs: Double, rhs: Double) -> Double {
        return lhs.truncatingRemainder(dividingBy: rhs)
    }
    
    public static func %= (lhs: inout Double, rhs: Double) {
        lhs.formTruncatingRemainder(dividingBy: rhs)
    }
}
