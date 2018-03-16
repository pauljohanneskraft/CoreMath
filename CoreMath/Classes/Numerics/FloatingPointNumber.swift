//
//  FloatingPointNumber.swift
//  Math
//
//  Created by Paul Kraft on 16.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct FloatingPointNumber {
    var exponent: Int
    let exponentSize: Int
    var mantissa: Int
    let mantissaSize: Int
    var sign: Bool
    
    static func infinity(sign: Bool) -> FloatingPointNumber {
        return self.init(sign ? -Double.infinity : Double.infinity)
    }
    
    static var zero: FloatingPointNumber {
        return self.init(Double(0))
    }
    
    static var nan: FloatingPointNumber {
        return self.init(Double.nan)
    }
    
    init(exponent: Int, exponentSize: Int, mantissa: Int, mantissaSize: Int, sign: Bool) {
        self.exponent = exponent
        self.mantissa = mantissa
        self.sign = sign
        self.mantissaSize = mantissaSize
        self.exponentSize = exponentSize
    }
    
    public init(_ float: Float) {
        let int = float.modifyCopy { $0.memoryRebound(to: Int64.self) }
        sign = float < 0
        mantissa = Int(int & FloatingPointNumber.bitPattern(forBitCount: 24))
        exponent = Int((int >> 23) & FloatingPointNumber.bitPattern(forBitCount: 8))
        exponentSize = 8
        mantissaSize = 24
    }
    
    public init(_ double: Double) {
        let int = double.modifyCopy { $0.memoryRebound(to: Int64.self) }
        sign = double < 0
        mantissa = Int(int & FloatingPointNumber.bitPattern(forBitCount: 52))
        exponent = Int((int >> 51) & FloatingPointNumber.bitPattern(forBitCount: 11))
        exponentSize = 11
        mantissaSize = 52
    }
    
    private static func bitPattern(forBitCount count: Int) -> Int64 {
        return (1 << count) - 1
    }
    
    public var double: Double {
        return (sign ? -1 : 1)*Double(mantissa)*pow(2, Double(exponent))
    }
    
    static func denormalize(_ first: inout FloatingPointNumber, _ second: inout FloatingPointNumber) {
        let difference = abs(first.exponent - second.exponent)
        if first.compareAbsoluteValue(to: second) > 0 {
            denormalize(bigger: &first, difference: difference)
        } else {
            denormalize(bigger: &second, difference: difference)
        }
    }
    
    private static func denormalize(bigger: inout FloatingPointNumber, difference: Int) {
        bigger.mantissa <<= difference
        bigger.exponent -= difference
    }
    
    mutating func normalize() {
        let bitmask = Int.min >> (MemoryLayout<Int>.size - 24)
        let upperBoundmantissa = (1 << (24 - 1))
        
        var cutOff = 0
        
        while (mantissa & bitmask) > upperBoundmantissa {
            guard let co = shiftOnce() else {
                self = FloatingPointNumber.infinity(sign: sign)
                return
            }
            cutOff = co
        }
        
        mantissa += cutOff
        
        if (mantissa & bitmask) > upperBoundmantissa {
            guard shiftOnce() != nil else {
                self = FloatingPointNumber.infinity(sign: sign)
                return
            }
            
        }
        
        while (mantissa & bitmask) == 0 {
            mantissa <<= 1
            exponent -= 1
            guard exponent <= 0 else {
                mantissa = upperBoundmantissa
                exponent = 0
                return
            }
        }
    }
    
    private mutating func shiftOnce() -> Int? {
        let cutOff = mantissa & 1
        mantissa >>= 1
        exponent += 1
        guard exponent < (1 << 8) else {
            return nil
        }
        return cutOff
    }
    
    func compareAbsoluteValue(to: FloatingPointNumber) -> Int {
        if exponent != to.exponent {
            return exponent < to.exponent ? -1 : 1
        }
        if mantissa != to.mantissa {
            return mantissa < to.mantissa ? -1 : 1
        }
        return 0
    }
    
    public static func + (lhs: FloatingPointNumber, rhs: FloatingPointNumber) -> FloatingPointNumber {
        assert(lhs.exponentSize == rhs.exponentSize)
        assert(lhs.mantissaSize == rhs.mantissaSize)
        var lhs = lhs, rhs = rhs
        denormalize(&lhs, &rhs)
        
        let (mantissa, sign) = lhs.sign == rhs.sign ?
            (lhs.mantissa + rhs.mantissa, lhs.sign) :
            (abs(lhs.mantissa - rhs.mantissa), lhs.compareAbsoluteValue(to: rhs) < 0)
        
        var result = FloatingPointNumber(
            exponent: lhs.exponent,
            exponentSize: lhs.exponentSize,
            mantissa: mantissa,
            mantissaSize: lhs.mantissaSize,
            sign: sign)
        
        result.normalize()
        
        return result
    }
}
