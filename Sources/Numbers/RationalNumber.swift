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

public struct RationalNumber {
    public private(set) var numerator: Int
    public private(set) var denominator: Int
    
    public init(numerator: Int, denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
    }
}

extension RationalNumber {
    public init(_ numerator: Int, _ denominator: Int) {
        self.init(numerator: numerator, denominator: denominator)
    }
    
    public init(_ value: Int) {
        self.init(numerator: value, denominator: 1)
    }
}

extension RationalNumber: All {}

extension RationalNumber {
    public var sign: Bool {
        return numerator < 0 ? denominator >= 0 : denominator < 0
    }
    
    public var reduced: RationalNumber {
        return copy { $0.reduce() }
    }
}

extension RationalNumber {
    mutating func reduce() {
        let gcd = numerator.greatestCommonDivisor(with: denominator)
        numerator   /= gcd
        denominator /= gcd
        if denominator < 0 {
            numerator = -numerator
            denominator = -denominator
        }
    }
}

extension RationalNumber: Equatable {
    public static func == (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
        guard lhs.sign == rhs.sign else {
            return false
        }
        guard lhs.numerator != rhs.numerator || lhs.denominator != rhs.denominator else {
            return true
        }
        return lhs.numerator == -rhs.numerator && lhs.denominator == -rhs.denominator
    }
}

extension RationalNumber: Hashable {
    public var hashValue: Int {
        return double.hashValue
    }
}

extension RationalNumber: Comparable {
    public static func < (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
        return lhs.double < rhs.double
    }
}

extension RationalNumber: CustomStringConvertible {
    public var description: String {
        switch denominator {
        case 1:
            return numerator.description
        case -1:
            return (-numerator).description
        case 0:
            return Double.nan.description
        default:
            return "(\(numerator)/\(denominator))"
        }
    }
}

extension RationalNumber: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public init(_ value: Double) {
        self.init(readable: value)
    }
    
    // source: http://stackoverflow.com/questions/95727/how-to-convert-floats-to-human-readable-fractions
    private init(readable value: Double) {
        assert(value <= Double(Int.max))
        let accuracy = Swift.min(value.inaccuracy, 1e-11)
        
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
            } else {
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
    
    // source: http://stackoverflow.com/questions/95727/how-to-convert-floats-to-human-readable-fractions
    private init(notReadable value: Double) {
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
}

extension RationalNumber: Numeric {
    public var integer: Int {
        return numerator / denominator
    }
    
    public var double: Double {
        return Double(numerator) / Double(denominator)
    }
    
    public var isInteger: Bool {
        return self.reduced.denominator == 1
    }
    
    public static var random: RationalNumber {
        return Q(Math.random(), Math.random()).reduced
    }
}

extension RationalNumber: BasicArithmetic {
    public static func *= (lhs: inout RationalNumber, rhs: RationalNumber) {
        let rhs = rhs.reduced
        lhs.reduce()
        lhs.denominator = rhs.denominator * lhs.denominator
        lhs.numerator *= rhs.numerator
        lhs.reduce()
    }
    
    public static func /= (lhs: inout RationalNumber, rhs: RationalNumber) {
        let rhs = rhs.reduced
        lhs.reduce()
        lhs.denominator = rhs.numerator * lhs.denominator
        lhs.numerator *= rhs.denominator
        lhs.reduce()
    }
    
    public static func += (lhs: inout RationalNumber, rhs: RationalNumber) {
        let rhs = rhs.reduced
        lhs.reduce()
        lhs.numerator = lhs.numerator * rhs.denominator + rhs.numerator * lhs.denominator
        lhs.denominator = rhs.denominator * lhs.denominator
        lhs.reduce()
    }
    
    public static func -= (lhs: inout RationalNumber, rhs: RationalNumber) {
        let rhs = rhs.reduced
        lhs.reduce()
        lhs.numerator = lhs.numerator * rhs.denominator - rhs.numerator * lhs.denominator
        lhs.denominator = rhs.denominator * lhs.denominator
        lhs.reduce()
    }
    
    prefix public static func - (lhs: RationalNumber) -> RationalNumber {
        var lhs = lhs
        if lhs.denominator < 0 { lhs.denominator = -lhs.denominator } else { lhs.numerator = -lhs.numerator }
        return lhs
    }
}

extension RationalNumber: Ordered {
    public static var min: RationalNumber {
        return Q(Int.min, 1)
    }
    
    public static var max: RationalNumber {
        return Q(Int.max, 1)
    }
}

extension RationalNumber: AdvancedNumeric {
    public static func %= (lhs: inout RationalNumber, rhs: RationalNumber) {
        lhs -= rhs * Q( (lhs / rhs).integer )
    }
}

extension Double {
    public var inaccuracy: Double {
        return nextafter(self, Double.greatestFiniteMagnitude) - self
    }
}
