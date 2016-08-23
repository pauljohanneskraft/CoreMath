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
    fileprivate(set) var numerator   : Int
    fileprivate(set) var denominator : Int
    
    public init(_ numerator: Int, _ denominator: Int) {
        self.init(numerator: numerator, denominator: denominator)
    }
    
    public init(numerator: Int, denominator: Int) {
        self.numerator   =   numerator
        self.denominator = denominator
    }
    
    public init(_ value: Int) {
        self.numerator = value
        self.denominator = 1
    }
    
    mutating func reduce() {
        let gcd = numerator.greatestCommonDivisor(with: denominator)
        self.numerator   /= gcd
        self.denominator /= gcd
        if self.denominator.sign {
            numerator   =   -numerator
            denominator = -denominator
        }
    }
    
    public var integer : Int? {
        return numerator / denominator
    }
    
    public var double: Double? {
        return Double(numerator) / Double(denominator)
    }
    
    public static var minValue : RationalNumber {
        return RationalNumber(Int.min, 1)
    }
    
    public static var maxValue : RationalNumber {
        return RationalNumber(Int.max, 1)
    }
    
    public static var random: RationalNumber {
        var z = Q(Int.random, 1)
        z.reduce()
        return z
    }
    
    var reduced : RationalNumber {
        var this = self
        this.reduce()
        return this
    }
    
    var maxValue : RationalNumber {
        return RationalNumber(Int.max)
    }
    
    var minValue : RationalNumber {
        return RationalNumber(Int.min)
    }
    
    var sign : Bool {
        if numerator < 0 {
            return !(denominator < 0)
        }
        return denominator < 0
    }
    
    public var hashValue : Int {
        return Double(self).hashValue
    }
    
    var abs : RationalNumber {
        return RationalNumber(
            numerator: self.numerator.abs,
            denominator: self.denominator.abs)
    }
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
        let accuracy = max(value.inaccuracy, 1e-11)
        
        let sign = value < 0
        let val = sign ? -value : value
        var n = Double(Int(val))
        var d = 1.0
        var frac = n / d
        var inacc = (frac - val).abs
        
        while inacc > accuracy {
            if frac < value { n += 1 }
            else {
                d += 1
                n = Double(Int(val * d))
            }
            frac = n / d
            inacc = (frac - val).abs
            // print(frac, n, d)
            assert(n <= Double(Int.max) && d <= Double(Int.max))
        }
        
        self = RationalNumber(numerator: sign ? -Int(n) : Int(n), denominator: Int(d))
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
    if lhs.sign != rhs.sign { return false }
    if lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator {
        return true
    }
    return lhs.numerator == -rhs.numerator && lhs.denominator == -rhs.denominator
}

public func < (lhs: RationalNumber, rhs: RationalNumber) -> Bool {
    return Double(lhs) < Double(rhs)
}

extension AdvancedNumeric {
    func greatestCommonDivisor(with other: Self) -> Self {
        var a = self > other ? self : other
        var b = self < other ? self : other
        while b.abs > 0 {
            let t = b
            b = a % b
            a = t
        }
        if a == 0 { return 1 }
        return a
    }
}

public func % (lhs: RationalNumber, rhs: RationalNumber) -> RationalNumber {
    var lhs = lhs
    lhs %= rhs
    return lhs
}

public func % (lhs: Double, rhs: Double) -> Double {
    return lhs.truncatingRemainder(dividingBy: rhs)
}

public func %= (lhs: inout RationalNumber, rhs: RationalNumber) {
    lhs -= rhs * Q( (lhs / rhs).integer! )
}

extension Double {
    public init(_ rat: RationalNumber) {
        self = Double(rat.numerator) / Double(rat.denominator)
    }
}
