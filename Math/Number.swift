//
//  Number.swift
//  Math
//
//  Created by Paul Kraft on 22.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

// partially from source: http://natecook.com/blog/2014/08/generic-functions-for-incompatible-types/

protocol NumericType : ForwardIndexType {
    
    func &+(lhs: Self, rhs: Self) -> Self
    func &-(lhs: Self, rhs: Self) -> Self
    func &*(lhs: Self, rhs: Self) -> Self

    func + (lhs: Self, rhs: Self) -> Self
    func - (lhs: Self, rhs: Self) -> Self
    func * (lhs: Self, rhs: Self) -> Self
    func / (lhs: Self, rhs: Self) -> Self
    func % (lhs: Self, rhs: Self) -> Self
    
    func %=(inout lhs: Self, rhs: Self)
    func +=(inout lhs: Self, rhs: Self)
    func -=(inout lhs: Self, rhs: Self)
    func *=(inout lhs: Self, rhs: Self)
    func /=(inout lhs: Self, rhs: Self)

    func !=(lhs: Self, rhs: Self) -> Bool
    func ==(lhs: Self, rhs: Self) -> Bool
    func  <(lhs: Self, rhs: Self) -> Bool
    func  >(lhs: Self, rhs: Self) -> Bool
    func <=(lhs: Self, rhs: Self) -> Bool
    func >=(lhs: Self, rhs: Self) -> Bool
    
    static var max : Self { get }
    static var min : Self { get }
    
    init(_ v: Double)
    init(_ v: Float )
    init(_ v: Int   )
    init(_ v: Int8  )
    init(_ v: Int16 )
    init(_ v: Int32 )
    init(_ v: Int64 )
    init(_ v: UInt  )
    init(_ v: UInt8 )
    init(_ v: UInt16)
    init(_ v: UInt32)
    init(_ v: UInt64)
    init(_ v: Self  )
    init<T: NumericType>(_ v: T)
    
}

extension NumericType {
    
    static var range : Range<Self> {
        return Self.min...Self.max
    }
    
    var abs : Self {
        return (self < Self(0) ? Self(0) - self : self)
    }
    
    func isPrime() -> Bool {
        let num = self
        if Double(Int(num)) != Double(num) {
            return false
        }
        let zero = Self(0)
        let two = Self(2)
        let three = Self(3)
        let five = Self(5)
        let six = Self(6)
        if num <= three { return true }
        if (num % two) == zero { return false }
        if (num % three) == zero { return false }
        var i = five
        while i * i <= num {
            if (num % i) == zero { return false }
            if (num % (i + two)) == zero { return false }
            i += six
        }
        return true
    }
    
    var isInteger : Bool {
        return Double(Int(self)) == Double(self)
    }
    
    var sign : Bool {
        return self < Self(0)
    }
    
    func isNaturalNumber(includingZero includingZero: Bool) -> Bool {
        return isInteger && (includingZero ? self >= Self(0) : self > Self(0))
    }
    
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Self(w)
            break
        case is Float:
            let w = v as! Float
            self = Self(w)
            break
        case is Int:
            let w = v as! Int
            self = Self(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Self(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Self(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Self(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Self(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Self(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Self(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Self(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Self(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Self(w)
            break
        default:
            fatalError("casting unsuccesful, include " + v.dynamicType + " to init<T: NumericType>(_ v: T)")
            // beware when implementing NumericType-protocol in another type
        }
    }
    
}

extension Int    : NumericType {}
extension Int8   : NumericType {}
extension Int16  : NumericType {}
extension Int32  : NumericType {}
extension Int64  : NumericType {}
extension UInt   : NumericType {}
extension UInt8  : NumericType {}
extension UInt16 : NumericType {}
extension UInt32 : NumericType {}
extension UInt64 : NumericType {}


extension Double : NumericType {
    static var max : Double { return DBL_MAX }
    static var min : Double { return DBL_MIN }
    public func successor() -> Double {
        return nextafter(self, self + 1)
    }
}

extension Float  : NumericType {
    static var max : Float { return FLT_MAX }
    static var min : Float { return FLT_MIN }
    public func successor() -> Float {
        return nextafterf(self, self + 1)
    }
}

func &+(lhs: Double, rhs: Double) -> Double { return lhs + rhs }
func &-(lhs: Double, rhs: Double) -> Double { return lhs - rhs }
func &*(lhs: Double, rhs: Double) -> Double { return lhs * rhs }

func &+(lhs: Float, rhs: Float) -> Float { return lhs + rhs }
func &-(lhs: Float, rhs: Float) -> Float { return lhs - rhs }
func &*(lhs: Float, rhs: Float) -> Float { return lhs * rhs }

postfix func ++<T: NumericType>(inout left: T) -> T {
    let before = left
    ++left
    return before
}

prefix func ++<T: NumericType>(inout left: T) -> T {
    left = left + T(1)
    return left
}

postfix func --<T: NumericType>(inout left: T) -> T {
    let before = left
    --left
    return before
}

prefix func --<T: NumericType>(inout left: T) -> T {
    left = left - T(1)
    return left
}

prefix func -<T: NumericType>(left: T) -> T {
    return T(0) &- left
}

infix operator ^^ {}
func ^^ <T: NumericType> (radix: T, power: T) -> T {
    return T(pow(Double(radix), Double(power)))
}

func max<T : NumericType>(numbers: T...) -> T {
    return numbers.max { $0 > $1 }
}

func min<T : NumericType>(numbers: T...) -> T {
    return numbers.max { $0 < $1 }
}

