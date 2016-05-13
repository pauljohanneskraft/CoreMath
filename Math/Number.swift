//
//  Number.swift
//  Math
//
//  Created by Paul Kraft on 22.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation



// partially from source: http://natecook.com/blog/2014/08/generic-functions-for-incompatible-types/

protocol NumericType : ForwardIndexType, Hashable, Strideable {
    
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

    var isSignMinus: Bool { get }
    var isNormal: Bool { get }
    var isFinite: Bool { get }
    var isZero: Bool { get }
    var isSubnormal: Bool { get }
    var isInfinite: Bool { get }
    var isNaN: Bool { get }
    var isSignaling: Bool { get }
    
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
    //init(_ v: String)
    init<T: NumericType>(_ v: T)
    
}

extension NumericType {
    
    var bin : String { return bigEndian.bin }
    var oct : String { return bigEndian.oct }
    var dec : String { return bigEndian.dec }
    var hex : String { return bigEndian.hex }
    
    func string(radix: Int, groupsOf: Int) -> String {
        return bigEndian.string(radix, groupsOf: groupsOf)
    }
    
    var bigEndian : UInt64 {
        return bitVectorToInt(toBitVector().reverse())
    }
    
    private func bitVectorToInt(array: [UInt8]) -> UInt64 {
        let arr : [UInt8] = array.reverse()
        var res = UInt64(0)
        for i in arr.range {
            var a = UInt64(arr[i])
            a <<= UInt64(i*8)
            res |= a
        }
        return res
    }
    
    private func toBitVector() -> [UInt8] {
        var value = self
        let arr = withUnsafePointer(&value) {
            Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(Self)))
        }
        return arr
    }
    
    var littleEndian : UInt64 {
        return bitVectorToInt(toBitVector())
    }
    
    static var range : Range<Self> {
        return Self.min...Self.max
    }
    
    var abs : Self {
        return (self < Self(0) ? Self(0) - self : self)
    }
    
    var isPrime : Bool {
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
        case let o as Double:  self.init(o)
        case let o as Float:   self.init(o)
        case let o as Float80: self.init(o)
        case let o as UInt8:   self.init(o)
        case let o as UInt16:  self.init(o)
        case let o as UInt32:  self.init(o)
        case let o as UInt64:  self.init(o)
        case let o as UInt:    self.init(o)
        case let o as Int8:    self.init(o)
        case let o as Int16:   self.init(o)
        case let o as Int32:   self.init(o)
        case let o as Int64:   self.init(o)
        case let o as Int:     self.init(o)
        default:
            fatalError("casting unsuccesful, include " + v.dynamicType + " to \(#function)")
            // beware when implementing NumericType-protocol in another type
        }
    }
}

protocol EnhancedIntegerType : NumericType {}

extension EnhancedIntegerType {
    var isSignMinus: Bool { return self < Self(0) }
    var isNormal: Bool { return true }
    var isFinite: Bool { return true }
    var isZero: Bool { return self == Self(0) }
    var isSubnormal: Bool { return false }
    var isInfinite: Bool { return false }
    var isNaN: Bool { return false }
    var isSignaling: Bool { return false }
}

protocol EnhancedFloatingPointType : NumericType {}
extension EnhancedFloatingPointType {}


extension Int    : NumericType, EnhancedIntegerType {}
extension Int8   : NumericType, EnhancedIntegerType {}
extension Int16  : NumericType, EnhancedIntegerType {}
extension Int32  : NumericType, EnhancedIntegerType {}
extension Int64  : NumericType, EnhancedIntegerType {}
extension UInt   : NumericType, EnhancedIntegerType {}
extension UInt8  : NumericType, EnhancedIntegerType {}
extension UInt16 : NumericType, EnhancedIntegerType {}
extension UInt32 : NumericType, EnhancedIntegerType {}
extension UInt64 : NumericType, EnhancedIntegerType {
    func string(radix: Int, groupsOf: Int) -> String {
        let logradixDouble = log2(Double(radix))
        if logradixDouble.isNaturalNumber(includingZero: false) {
            let logradix = UInt64(logradixDouble)
            var m = UInt64.max
            var n = self
            var rep = ""
            while(m > 0) {
                for _ in 0..<groupsOf {
                    rep = String(n % UInt64(radix), radix: radix) + rep
                    m >>= logradix
                    n >>= logradix
                }
                if m != 0 { rep = "_" + rep }
            }
            return rep
        }
        return String(self, radix: radix)
    }
    
    var bin : String { return string( 2, groupsOf: 8) }
    var oct : String { return string( 8, groupsOf: 4) }
    var dec : String { return string(10, groupsOf: 3) }
    var hex : String { return string(16, groupsOf: 4) }
}


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

extension Float80: NumericType {
    static var max : Float80 { return Float80(FLT_MAX) }
    static var min : Float80 { return Float80(FLT_MIN) }
    
    var isSignMinus: Bool { return self < Float80(0) }
    var isNormal: Bool { return Double(self).isNormal }
    var isFinite: Bool { return self != Float80(Double.infinity) && self != Float80(-Double.infinity) }
    var isZero: Bool { return self == Float80(0) }
    var isSubnormal: Bool { return Double(self).isSubnormal }
    var isInfinite: Bool { return !self.isFinite }
    var isNaN: Bool { return self == Float80(Double.NaN) || self == Float80(Double.quietNaN) }
    var isSignaling: Bool { return isNaN }
    
    public func successor() -> Float80 {
        let num = self
        let modF = Float(num % Float80(FLT_MAX))
        return num + Float80(modF.successor())
    }
}

func &+(lhs: Double, rhs: Double) -> Double { return lhs + rhs }
func &-(lhs: Double, rhs: Double) -> Double { return lhs - rhs }
func &*(lhs: Double, rhs: Double) -> Double { return lhs * rhs }

func &+(lhs: Float, rhs: Float) -> Float { return lhs + rhs }
func &-(lhs: Float, rhs: Float) -> Float { return lhs - rhs }
func &*(lhs: Float, rhs: Float) -> Float { return lhs * rhs }

func &+(lhs: Float80, rhs: Float80) -> Float80 { return lhs + rhs }
func &-(lhs: Float80, rhs: Float80) -> Float80 { return lhs - rhs }
func &*(lhs: Float80, rhs: Float80) -> Float80 { return lhs * rhs }


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

infix operator &^^ {}
func &^^ <T: NumericType> (radix: T, power: T) -> T {
    return T(pow(Double(radix), Double(power)) % (Double(T.max) + 1.0))
}


func max<T : NumericType>(numbers: T...) -> T {
    return numbers.max { $0 > $1 }
}

func min<T : NumericType>(numbers: T...) -> T {
    return numbers.max { $0 < $1 }
}

