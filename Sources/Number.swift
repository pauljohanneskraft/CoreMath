//
//  Number.swift
//  Math
//
//  Created by Paul Kraft on 22.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

typealias Byte = UInt8

typealias Word = UInt16

typealias DWord = UInt32

typealias QWord = UInt64

// partially from source: http://natecook.com/blog/2014/08/generic-functions-for-incompatible-types/

protocol NumericType : Comparable, Hashable, Strideable, CustomStringConvertible {

    func !=  (lhs: Self, rhs: Self) -> Bool
    func ==  (lhs: Self, rhs: Self) -> Bool
    func  <  (lhs: Self, rhs: Self) -> Bool
    func  >  (lhs: Self, rhs: Self) -> Bool
    func <=  (lhs: Self, rhs: Self) -> Bool
    func >=  (lhs: Self, rhs: Self) -> Bool
    
    func +   (lhs: Self, rhs: Self) -> Self
    func -   (lhs: Self, rhs: Self) -> Self
    func *   (lhs: Self, rhs: Self) -> Self
    func /   (lhs: Self, rhs: Self) -> Self
    func %   (lhs: Self, rhs: Self) -> Self
    
    func &+  (lhs: Self, rhs: Self) -> Self
    func &-  (lhs: Self, rhs: Self) -> Self
    func &*  (lhs: Self, rhs: Self) -> Self
    
    func &+= (lhs: inout Self, rhs: Self)
    func &*= (lhs: inout Self, rhs: Self)
    func &-= (lhs: inout Self, rhs: Self)
    
    func %=  (lhs: inout Self, rhs: Self)
    func +=  (lhs: inout Self, rhs: Self)
    func -=  (lhs: inout Self, rhs: Self)
    func *=  (lhs: inout Self, rhs: Self)
    func /=  (lhs: inout Self, rhs: Self)
    
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
    init<T: NumericType>(_ v: T)
    
    func string(radix: Int, groupsOf: Int) -> String
    
    var successor : Self { get }
}

extension NumericType {
    
    var bin : String {
        let str = bigEndian.bin
        let index : String.Index = str.getIndex(72 - sizeof(Self) * 9)
        return str.substring(from: index)
    }
    var oct : String {
        let str = bigEndian.oct
        let index : String.Index = str.getIndex(32 - sizeof(Self) * 4)
        return str.substring(from: index)
    }
    var dec : String {
        return String(Int(self))
    }
    var hex : String {
        let str = bigEndian.hex
        let index : String.Index
        switch sizeof(Self) {
        case 1:  index = str.getIndex(18)
        case 2:  index = str.getIndex(15)
        case 4:  index = str.getIndex(10)
        default: return str
        }
        return str.substring(from: index)
    }
    
    func string(radix: Int, groupsOf: Int) -> String {
        return bigEndian.string(radix: radix, groupsOf: groupsOf)
    }
    
    var bigEndian : QWord {
        return bitVectorToInt(toBitVector().reversed())
    }
    
    private func bitVectorToInt(_ array: [Byte]) -> QWord {
        let arr : [Byte] = array.reversed()
        var res = QWord(0)
        for i in arr.indices {
            var a = QWord(arr[i])
            a <<= QWord(i*8)
            res |= a
        }
        return res
    }
    
    private func toBitVector() -> [Byte] {
        var value = self
        let arr = withUnsafePointer(&value) {
            Array(UnsafeBufferPointer(start: UnsafePointer<Byte>($0), count: sizeof(Self)))
        }
        return arr
    }
    
    var littleEndian : QWord {
        return bitVectorToInt(toBitVector())
    }
    
    static var range : Range<Self> {
        return Self.min..<Self.max
    }
    
    var bits : Int {
        var this = bigEndian
        var num = 0
        for _ in 0..<(sizeof(Self) << 2) {
            num += Int(this % 2)
            this >>= 1
        }
        return num
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
    
    func isNaturalNumber(includingZero: Bool) -> Bool {
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
    
    var inaccuracy : Self {
        let this : Self = self
        let succ : Self = self.successor
        return succ - this
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
    var nextPowerOf2: Int {
        let c = ceil(log2(Double(self)))
        return Int(pow(2.0, c))
    }
    var faculty : UInt64 {
        let one = UInt64(1)
        if self <= Self(1) { return one }
        let value = UInt64(self)
        return value * (value - one).faculty
    }
    
    var successor : Self {
        return self &+ Self(1)
    }
}

protocol EnhancedFloatingPointType : NumericType {}
extension EnhancedFloatingPointType {}

extension Int    : EnhancedIntegerType {}
extension Int8   : EnhancedIntegerType {}
extension Int16  : EnhancedIntegerType {}
extension Int32  : EnhancedIntegerType {}
extension Int64  : EnhancedIntegerType {}
extension UInt   : EnhancedIntegerType {}
extension UInt8  : EnhancedIntegerType {}
extension UInt16 : EnhancedIntegerType {}
extension UInt32 : EnhancedIntegerType {}
extension UInt64 : EnhancedIntegerType {
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
    
    var bin : String { return string(radix: 2, groupsOf: 8) }
    var oct : String { return string(radix: 8, groupsOf: 3) }
    var dec : String { return string(radix:10, groupsOf: 3) }
    var hex : String { return string(radix:16, groupsOf: 4) }
}

extension Double : EnhancedFloatingPointType {
    static var max : Double { return DBL_MAX }
    static var min : Double { return DBL_MIN }
    var successor : Double {
        return nextafter(self, DBL_MAX)
    }
}

extension Float  : EnhancedFloatingPointType {
    static var max : Float { return FLT_MAX }
    static var min : Float { return FLT_MIN }
    var successor : Float {
        return nextafterf(self, FLT_MAX)
    }
}

extension Float80: EnhancedFloatingPointType {
    static var max : Float80 { return Float80(FLT_MAX) }
    static var min : Float80 { return Float80(FLT_MIN) }
    
    var isSignMinus: Bool { return self < Float80(0) }
    var isNormal: Bool { return Double(self).isNormal }
    var isFinite: Bool { return self != Float80(Double.infinity) && self != Float80(-Double.infinity) }
    var isZero: Bool { return self == Float80(0) }
    var isSubnormal: Bool { return Double(self).isSubnormal }
    var isInfinite: Bool { return !self.isFinite }
    var isNaN: Bool { return self == Float80(Double.nan) }
    var isSignaling: Bool { return isNaN }
    
    var successor : Float80 {
        let num = self
        let modF = Float(num % Float80(Float.max))
        return num + Float80(modF.successor)
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


postfix func ++<T: NumericType>( left: inout T) -> T {
    let before = left
    ++left
    return before
}

prefix func ++<T: NumericType>( left: inout T) -> T {
    left = left + T(1)
    return left
}

postfix func --<T: NumericType>( left: inout T) -> T {
    let before = left
    _ = --left
    return before
}

prefix func --<T: NumericType>(left: inout T) {
    left = left - T(1)
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

/*
func max<T : NumericType>(numbers: T...) -> T {
    return numbers.max { $0 > $1 }!
}

func min<T : NumericType>(numbers: T...) -> T {
    return numbers.max { $0 < $1 }!
}
*/
// prefix operator ! {}
prefix func ! <T: EnhancedIntegerType>(value: T) throws -> T {
    let fac = value.faculty
    if fac > UInt64(T.max) { throw NumberError.TooBigForType("0x\(fac.hex), \(fac.dec) is too large to fit into \(T.self)") }
    return T(fac)
}

prefix operator ∿ {}
prefix func ∿<T: NumericType>(num: T) -> T {
    return T(sin(Double(num)))
}

prefix operator √ {}
prefix func √ <T: NumericType>(num: T) -> T {
    return T(pow(Double(num), 1/2))
}

prefix operator ∛ {}
prefix func ∛ <T: NumericType>(num: T) -> T {
    return T(pow(Double(num), 1/3))
}

prefix operator ∜ {}
prefix func ∜ <T: NumericType>(num: T) -> T {
    return T(pow(Double(num), 1/4))
}






struct InfiniteInt : CustomStringConvertible, InfiniteIntType {
    private var sign : Bool = false
    private var array : [UInt64]
    /*
    init(integerLiteral v: Int) {
        if v < 0 { sign = true }
        array = [UInt64(v.abs)]
    }
 */
    
    init(_ v: Int) {
        if v < 0 { sign = true }
        array = [UInt64(v.abs)]
    }
    /*
    init(_ v: Int8) {
        if v < 0 { sign = true }
        array = [UInt64(v.abs)]
    }
    init(_ v: Int16) {
        if v < 0 { sign = true }
        array = [UInt64(v.abs)]
    }
    init(_ v: Int32) {
        if v < 0 { sign = true }
        array = [UInt64(v.abs)]
    }
    init(_ v: Int64) {
        if v < 0 { sign = true }
        array = [UInt64(v.abs)]
    }
    init(_ v: UInt) {
        array = [UInt64(v)]
    }
    init(_ v: UInt8) {
        array = [UInt64(v)]
    }
    init(_ v: UInt16) {
        array = [UInt64(v)]
    }
    init(_ v: UInt32) {
        array = [UInt64(v)]
    }
    init(_ v: UInt64) {
        array = [v]
    }
 */
    var description: String {
        return "\(array)"
    }
    var successor : InfiniteInt {
        return self // + InfiniteInt(1)
    }
    var hashValue: Int {
        return Int(array[0] % UInt64(Int.max))
    }
}

protocol InfiniteIntType {
    func <<= (lhs: inout Self, rhs: Int) -> Self
    func << (lhs: Self, rhs: Int) -> Self
    func += (lhs: inout Self, rhs: Self) -> Self
    func + (lhs: Self, rhs: Self) -> Self
}

func <<= (lhs: inout InfiniteInt, rhs: Int) -> InfiniteInt {
    var x : UInt64
    var overflow : UInt64 = 0
    let rhs = UInt64(rhs)
    let mask : UInt64 = UInt64.max << rhs
    for i in lhs.array.indices {
        x = lhs.array[i] + overflow
        overflow = x & mask
        lhs.array[i] = x << rhs
    }
    if overflow != 0 {
        lhs.array.append(overflow)
    }
    return lhs
}

func << (lhs: InfiniteInt, rhs: Int) -> InfiniteInt {
    var lhs = lhs
    lhs <<= rhs
    return lhs
}

func += (lhs: inout InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    let rhscount = rhs.array.count, lhscount = lhs.array.count
    if !rhs.sign && !lhs.sign {
        if lhscount >= rhscount {
            var overflow : UInt64 = 0
            let max32 = UInt64(UInt32.max) + 1
            var l : UInt64
            var r : UInt64
            var e : UInt64
            var x : UInt64
            for i in lhs.array.indices {
                l = lhs.array[i] % max32
                r = rhs.array[i] % max32
                e = l + r + overflow
                overflow = e / max32
                x = e % max32
                l = lhs.array[i] / max32
                r = rhs.array[i] / max32
                e = l + r + overflow
                overflow = e / max32
                lhs.array[i] = ((e % max32) << 8) + x
                if i > rhscount && overflow == 0 { return lhs }
            }
            if overflow != 0 {
                lhs.array.append(overflow)
            }
            return lhs
        }
    }
    return lhs
}

func + (lhs: InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    var lhs = lhs
    lhs += rhs
    return lhs
}

func -= (lhs: inout InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    if lhs.array.count >= rhs.array.count {
        let indices = lhs.array.indices
        for i in indices {
            print(i)
        }
    } else {
        let indices = rhs.array.indices
        lhs.sign = true
        for i in indices {
            print(i)
        }
    }
    return lhs
}

func - (lhs: InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    var lhs = lhs
    lhs -= rhs
    return lhs
}
/*
func * (lhs: InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    
}

func / (lhs: InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    
}

func >> (lhs: InfiniteInt, rhs: Int) -> InfiniteInt {
    var lhs = lhs
    lhs >>= rhs
    return lhs
}

func >>= (lhs: inout InfiniteInt, rhs: Int) -> InfiniteInt {
    let rest = UInt64(16 - rhs)
    let rhs64 = UInt64(rhs)
    let mask = UInt64.max >> rest
    lhs.array[0] >>= rhs64
    var v : UInt64
    for i in lhs.array.indices.dropFirst() {
        v = lhs.array[i]
        lhs.array[i-1] |= ((mask & v) << rest)
        lhs.array[i] = v >> rhs64
    }
    return lhs
}


func % (lhs: InfiniteInt, rhs: InfiniteInt) -> InfiniteInt {
    if rhs.array.count == 1 {
        return InfiniteInt(Int(lhs.array[0] % rhs.array[0]))
    }
    for i in lhs.array.count {
        
    }
    return lhs
}

*/

infix operator &+= {}
infix operator &-= {}
infix operator &*= {}

func &+=<T : NumericType>(lhs: inout T, rhs: T) {
    lhs = lhs &+ rhs
}

func &*=<T : NumericType>(lhs: inout T, rhs: T) {
    lhs = lhs &* rhs
}

func &-=<T : NumericType>(lhs: inout T, rhs: T) {
    lhs = lhs &- rhs
}


