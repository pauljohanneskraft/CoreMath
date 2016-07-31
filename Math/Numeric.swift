//
//  Numeric.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 04.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public typealias R = Double
public typealias N = UInt
public typealias Z = Int

public func Z_(_ v: UInt) -> Set<UInt> {
    return Set<UInt>(0..<v)
}

extension Numeric {
    public var sqrt : Self? {
        if let d = self.double {
            if d < 0 { return nil }
            return Self(floatLiteral: pow(d, 1.0/2))
        } else { return nil }
    }
    
    public func power(_ v: Double) -> Self? {
        if let d = self.double {
            if d < 0 && v < 1 { return nil }
            return Self(floatLiteral: pow(d, v))
        } else { return nil }
    }
}

public protocol AdvancedNumeric : Numeric {
    static func % (lhs: Self, rhs: Self) -> Self
    static func %= (lhs: inout Self, rhs: Self)
}

public protocol Ordered : Comparable {
    static var min : Self { get }
    static var max : Self { get }
}

public protocol BasicArithmetic : CustomStringConvertible, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Hashable, Comparable {
    init(integerLiteral: Int)
    init(floatLiteral: Double)
    
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
    
    static func += (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
    static func *= (lhs: inout Self, rhs: Self)
    static func /= (lhs: inout Self, rhs: Self)
    
    prefix static func - (lhs: Self) -> Self
}

public protocol Numeric : BasicArithmetic {
    var integer : Int?   { get }
    var double : Double? { get }
    var sqrt : Self? { get }
    func power(_ v: Double) -> Self?
    static var random : Self { get }
}

extension Int {
    init<N : AdvancedNumeric>(_ v: N) {
        let int = v.integer
        assert(int != nil)
        self = int!
    }
}

extension Int    : AdvancedNumeric {
    public var integer : Int? {
        return self
    }
    public var double : Double? {
        return Double(self)
    }
    
    public static var random : Int {
        return (arc4random() % 2 == 0 ? 1 : -1) * Int(arc4random() % UInt32(UInt8.max))
    }
    
    var isInteger : Bool { return true }
    
    public init(floatLiteral: Double) {
        self = Int(floatLiteral)
    }
}

extension Double : AdvancedNumeric {
    public init(integerLiteral: Int) {
        self.init(integerLiteral)
    }
    
    public static var random : Double {
        var z : Double? = nil
        while z == nil || z!.isNaN || z!.isInfinite {
            z = (arc4random() % 2 == 0 ? -1 : 1) * Double(unsafeBitCast(arc4random(), to: Float.self))
        }
        return z!
    }
    
    public var integer : Int?    {
        if self > Double(Int.max) || self < Double(Int.min) { return nil }
        return Int(self)
    }
    public var double  : Double? { return self }
    
    static var min : Double { return DBL_MAX }
    static var max : Double { return DBL_MIN }
}

extension BasicArithmetic {
    var abs    : Self { return self < 0 ? -self : self }
    var isZero : Bool { return abs < 1e-14 }
    
}

extension Numeric {
    var isInteger : Bool {
        if let int = self.integer { return Self(integerLiteral: int) == self }
        return false
    }
}

extension Numeric {
    var primeFactors : [Int] {
        guard self.isInteger else { return [] }
        var this = self.integer!
        var i = 0
        var primes = Int.getPrimes(upTo: this)
        var factors = [Int]()
        while this > 1 {
            let p = primes[i]
            if this % p == 0 {
                this /= p
                factors.append(p)
            } else { i += 1 }
        }
        return factors
    }
    
    static func getPrimes(upTo: Int) -> [Int] {
        // print("did start", upTo)
        if upTo <= 1 { return [] }
        
        var candidate = 1
        var test      = 3
        var res       = [2]
        
        while candidate <= upTo {
            test = 3
            candidate += 2
            while candidate % test != 0 { test += 2 }
            if candidate == test { res.append(candidate) }
        }
        // print("did end", upTo)
        return res
    }
    
    static func getNextPrime(from: Int) -> Int {
        var candidate = from % 2 == 0 ? from : from - 1
        var test = 3
        while true {
            test = 3
            candidate += 2
            while candidate % test != 0 { test += 2 }
            if candidate == test { return candidate }
        }
    }
}

/*
prefix  operator | {}
postfix operator | {}

prefix  func | < N : Numeric > (elem: N) -> (f: (N) -> N, e: N) {
    return (f: { return $0.abs }, e: elem)
}
    
postfix func | < N : Numeric > ( t: (f: (N) -> N, e: N) ) -> N {
    return t.f(t.e)
}
*/

extension BasicArithmetic {
    var reducedDescription : String {
        if let s = self as? Double {
            if s.isNaN || s.isInfinite { return "\(s)" }
            if s > Double(Int.min) && s < Double(Int.max) {
                let si = Int(s)
                if (Double(si) - s).isZero { return "\(si)" }
            }
        }
        return self.description
    }
    
    func coefficientDescription(first: Bool) -> String {
        
        let n : Self
        var res = ""
        if !first { n = self.abs; res += self < 0 ? "- " : "+ " }
        else { n = self }
        
        switch n {
        case 0, 1:  return res
        case -1:    return "-"
        default:    return res + n.reducedDescription
        }
    }
}

extension Complex {
    
    public var polarForm : (coefficient: Double, exponent: Double)? {
        let abs = self.abs.real
        if let di = imaginary.double, let dr = real.double {
            return (abs.double!, atan2(di, dr))
        }
        return nil
    }
    
    public func power(_ v: Double) -> Complex<Number>? {
        // if d < 0 && v < 1 { return nil }
        if var pF = self.polarForm {
            pF.coefficient = pF.coefficient.power(v)!
            pF.exponent = pF.exponent * v
            // print(pF)
            return Complex(polarForm: pF)
        }
        return nil
    }
}


infix operator ~= {}

public func ~= (lhs: Double, rhs: Double) -> Bool {
    let inacc = max(lhs.inaccuracy, rhs.inaccuracy)
    return (lhs - rhs).abs < inacc
}
