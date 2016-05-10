//
//  Number.swift
//  Math
//
//  Created by Paul Kraft on 22.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

// partially from source: http://natecook.com/blog/2014/08/generic-functions-for-incompatible-types/

protocol NumericType {
    
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
    
    func abs() -> Self
    
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

extension Int    : NumericType {
    func abs() -> Int       { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Int(w)
            break
        case is Float:
            let w = v as! Float
            self = Int(w)
            break
        case is Int:
            let w = v as! Int
            self = Int(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Int(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Int(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Int(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Int(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Int(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Int(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Int(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Int(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Int(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension Int8   : NumericType {
    func abs() -> Int8      { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Int8(w)
            break
        case is Float:
            let w = v as! Float
            self = Int8(w)
            break
        case is Int:
            let w = v as! Int
            self = Int8(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Int8(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Int8(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Int8(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Int8(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Int8(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Int8(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Int8(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Int8(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Int8(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension Int16  : NumericType {
    func abs() -> Int16     { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Int16(w)
            break
        case is Float:
            let w = v as! Float
            self = Int16(w)
            break
        case is Int:
            let w = v as! Int
            self = Int16(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Int16(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Int16(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Int16(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Int16(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Int16(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Int16(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Int16(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Int16(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Int16(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension Int32  : NumericType {
    func abs() -> Int32     { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Int32(w)
            break
        case is Float:
            let w = v as! Float
            self = Int32(w)
            break
        case is Int:
            let w = v as! Int
            self = Int32(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Int32(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Int32(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Int32(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Int32(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Int32(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Int32(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Int32(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Int32(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Int32(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension Int64  : NumericType {
    func abs() -> Int64     { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Int64(w)
            break
        case is Float:
            let w = v as! Float
            self = Int64(w)
            break
        case is Int:
            let w = v as! Int
            self = Int64(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Int64(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Int64(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Int64(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Int64(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Int64(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Int64(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Int64(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Int64(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Int64(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension UInt   : NumericType {
    func abs() -> UInt      { return self }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = UInt(w)
            break
        case is Float:
            let w = v as! Float
            self = UInt(w)
            break
        case is Int:
            let w = v as! Int
            self = UInt(w)
            break
        case is Int8:
            let w = v as! Int8
            self = UInt(w)
            break
        case is Int16:
            let w = v as! Int16
            self = UInt(w)
            break
        case is Int32:
            let w = v as! Int32
            self = UInt(w)
            break
        case is Int64:
            let w = v as! Int64
            self = UInt(w)
            break
        case is UInt:
            let w = v as! UInt
            self = UInt(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = UInt(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = UInt(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = UInt(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = UInt(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension UInt8  : NumericType {
    func abs() -> UInt8     { return self }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = UInt8(w)
            break
        case is Float:
            let w = v as! Float
            self = UInt8(w)
            break
        case is Int:
            let w = v as! Int
            self = UInt8(w)
            break
        case is Int8:
            let w = v as! Int8
            self = UInt8(w)
            break
        case is Int16:
            let w = v as! Int16
            self = UInt8(w)
            break
        case is Int32:
            let w = v as! Int32
            self = UInt8(w)
            break
        case is Int64:
            let w = v as! Int64
            self = UInt8(w)
            break
        case is UInt:
            let w = v as! UInt
            self = UInt8(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = UInt8(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = UInt8(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = UInt8(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = UInt8(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension UInt16 : NumericType {
    func abs() -> UInt16    { return self }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = UInt16(w)
            break
        case is Float:
            let w = v as! Float
            self = UInt16(w)
            break
        case is Int:
            let w = v as! Int
            self = UInt16(w)
            break
        case is Int8:
            let w = v as! Int8
            self = UInt16(w)
            break
        case is Int16:
            let w = v as! Int16
            self = UInt16(w)
            break
        case is Int32:
            let w = v as! Int32
            self = UInt16(w)
            break
        case is Int64:
            let w = v as! Int64
            self = UInt16(w)
            break
        case is UInt:
            let w = v as! UInt
            self = UInt16(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = UInt16(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = UInt16(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = UInt16(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = UInt16(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension UInt32 : NumericType {
    func abs() -> UInt32    { return self }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = UInt32(w)
            break
        case is Float:
            let w = v as! Float
            self = UInt32(w)
            break
        case is Int:
            let w = v as! Int
            self = UInt32(w)
            break
        case is Int8:
            let w = v as! Int8
            self = UInt32(w)
            break
        case is Int16:
            let w = v as! Int16
            self = UInt32(w)
            break
        case is Int32:
            let w = v as! Int32
            self = UInt32(w)
            break
        case is Int64:
            let w = v as! Int64
            self = UInt32(w)
            break
        case is UInt:
            let w = v as! UInt
            self = UInt32(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = UInt32(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = UInt32(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = UInt32(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = UInt32(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension UInt64 : NumericType {
    func abs() -> UInt64    { return self }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = UInt64(w)
            break
        case is Float:
            let w = v as! Float
            self = UInt64(w)
            break
        case is Int:
            let w = v as! Int
            self = UInt64(w)
            break
        case is Int8:
            let w = v as! Int8
            self = UInt64(w)
            break
        case is Int16:
            let w = v as! Int16
            self = UInt64(w)
            break
        case is Int32:
            let w = v as! Int32
            self = UInt64(w)
            break
        case is Int64:
            let w = v as! Int64
            self = UInt64(w)
            break
        case is UInt:
            let w = v as! UInt
            self = UInt64(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = UInt64(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = UInt64(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = UInt64(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = UInt64(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension Double : NumericType {
    static var max : Double { return DBL_MAX }
    static var min : Double { return DBL_MIN }
    func abs() -> Double { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Double(w)
            break
        case is Float:
            let w = v as! Float
            self = Double(w)
            break
        case is Int:
            let w = v as! Int
            self = Double(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Double(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Double(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Double(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Double(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Double(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Double(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Double(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Double(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Double(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
    }
}

extension Float  : NumericType {
    static var max : Float { return FLT_MAX }
    static var min : Float { return FLT_MIN }
    func abs() -> Float { return (self < 0 ? 0 - self : self) }
    init<T: NumericType>(_ v: T) {
        switch v {
        case is Double:
            let w = v as! Double
            self = Float(w)
            break
        case is Float:
            let w = v as! Float
            self = Float(w)
            break
        case is Int:
            let w = v as! Int
            self = Float(w)
            break
        case is Int8:
            let w = v as! Int8
            self = Float(w)
            break
        case is Int16:
            let w = v as! Int16
            self = Float(w)
            break
        case is Int32:
            let w = v as! Int32
            self = Float(w)
            break
        case is Int64:
            let w = v as! Int64
            self = Float(w)
            break
        case is UInt:
            let w = v as! UInt
            self = Float(w)
            break
        case is UInt8:
            let w = v as! UInt8
            self = Float(w)
            break
        case is UInt16:
            let w = v as! UInt16
            self = Float(w)
            break
        case is UInt32:
            let w = v as! UInt32
            self = Float(w)
            break
        case is UInt64:
            let w = v as! UInt64
            self = Float(w)
            break
        default:
            assert(false)
            self = 0
            break
        }
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

prefix func -<T:NumericType>(left: T) -> T {
    return T(0) &- left
}

infix operator ^^ {}
func ^^ <T: NumericType> (radix: T, power: T) -> T {
    return T(pow(Double(radix), Double(power)))
}






