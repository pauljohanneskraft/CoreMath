//
//  EnhancedNumber.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 24.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public enum Enhanced < Number : Numeric > : Numeric, Hashable {
    case finite(Number)
    case infinity(sign: Bool)
    case nan
    
    public init(integerLiteral: Int) {
        self = .finite(Number(integerLiteral: integerLiteral))
    }
    
    public init(floatLiteral: Double) {
        switch floatLiteral {
        case Double.infinity:   self = .infinity(sign: false)
        case -Double.infinity:  self = .infinity(sign: true)
        case Double.nan:        self = .nan
        default:                self = .finite(Number(floatLiteral: floatLiteral))
        }
    }
    
    public var hashValue: Int {
        switch self {
        case let .finite(value): return value.hashValue
        case let .infinity(sign): return ( (sign ? -1 : 1) * Double.infinity).hashValue
        case .nan: return Double.nan.hashValue
        }
    }
    
    public var sign : Bool {
        switch self {
        case let .finite(value):    return value < 0
        case let .infinity(sign):   return sign
        case .nan:                  return false
        }
    }
    
    public var description: String {
        switch self {
        case let .finite(value):    return "\(value)"
        case let .infinity(sign):   return sign ? "-∞" : "∞"
        case .nan:                  return "nan"
        }
    }
    
    public static var random : Enhanced<Number> {
        return .finite(Number.random)
    }
    
    public var integer : Int	{
        switch self {
        case let .finite(v):        return v.integer
        case let .infinity(sign):   return sign ? Int.min : Int.max
		default: assert(false, "illegal state \(self)")
        }
    }
    
    public var double : Double {
        switch self {
        case let .finite(v):        return v.double
        case let .infinity(sign):   return sign ? -Double.infinity : Double.infinity
        case .nan:                  return Double.nan
        }
    }
}

public func == < N : Numeric >(lhs: Enhanced<N>, rhs: Enhanced<N>) -> Bool {
    switch (lhs, rhs) {
    case let (.finite(v1), .finite(v2)): return v1 == v2
    case let (.infinity(s1), .infinity(s2)): return s1 == s2
    case (.nan, .nan): return true
    default: return false
    }
}

public func < < N : Numeric >(lhs: Enhanced<N>, rhs: Enhanced<N>) -> Bool {
    // if lhs == rhs { return false }
    switch (lhs, rhs) {
    case let (.finite(v1), .finite(v2)): return v1 < v2
    case let (.infinity(s), _): return s
    case (.nan, _): return true
    case (_, .nan): return false
    case let (.finite, .infinity(s)): return !s
    default: assert(false)
    }
    return false
}

public func += < N : Numeric >(lhs: inout Enhanced<N>, rhs: Enhanced<N>) {
    switch (lhs, rhs) {
    case (.nan, _), (_, .nan): lhs = .nan
    case let (.finite(v1), .finite(v2)): lhs = .finite(v1 + v2)
    case (.infinity(true), .infinity(false)), (.infinity(false), .infinity(true)): lhs = .finite(0)
    case let (.infinity(s), _), let (_, .infinity(s)): lhs = .infinity(sign: s)
    default: assert(false)
    }
}

public func -= < N : Numeric >(lhs: inout Enhanced<N>, rhs: Enhanced<N>) {
    switch (lhs, rhs) {
    case (.nan, _), (_, .nan): lhs = .nan
    case let (.finite(v1), .finite(v2)): lhs = .finite(v1 + v2)
    case (.infinity(false), .infinity(false)), (.infinity(true), .infinity(true)): lhs = .finite(0)
    case (.infinity(false), _), (_, .infinity(true)): lhs = .infinity(sign: true)
    case (_, .infinity(false)), (.infinity(true), _): lhs = .infinity(sign: false)
    default: assert(false)
    }
}

public func *= < N : Numeric >(lhs: inout Enhanced<N>, rhs: Enhanced<N>) {
    switch (lhs, rhs) {
    case (.nan, _), (_, .nan): lhs = .nan
    case let (.finite(v1), .finite(v2)): lhs = .finite(v1 * v2) // maybe if too big for "Number" switching to infinity
    case let (.infinity(s), .infinity(t)): if s == t { lhs = .infinity(sign: false) } else { lhs = .infinity(sign: true) }
    case let (.infinity(u), _), let (_, .infinity(u)): lhs = .infinity(sign: u)
    default: assert(false)
    }
}

public func /= < N : Numeric >(lhs: inout Enhanced<N>, rhs: Enhanced<N>) {
    switch (lhs, rhs) {
    case (.nan, _), (_, .nan): lhs = .nan
    case (_, .finite(0)): if lhs.sign { lhs = .infinity(sign: true) } else { lhs = .infinity(sign: false) }
    case let (.finite(v1), .finite(v2)): lhs = .finite(v1 / v2)
    case let (.infinity(s), .infinity(u)): if s == u { lhs = .finite(1) } else { lhs = .finite(-1) }
    case (_, .infinity): lhs = .finite(0)
    case (.infinity, _): return
    default: assert(false)
    }
}

public func + < N : Numeric >(lhs: Enhanced<N>, rhs: Enhanced<N>) -> Enhanced<N> {
    var lhs = lhs
    lhs += rhs
    return lhs
}

public func - < N : Numeric >(lhs: Enhanced<N>, rhs: Enhanced<N>) -> Enhanced<N> {
    var lhs = lhs
    lhs -= rhs
    return lhs
}
public func * < N : Numeric >(lhs: Enhanced<N>, rhs: Enhanced<N>) -> Enhanced<N> {
    var lhs = lhs
    lhs *= rhs
    return lhs
}

public func / < N : Numeric >(lhs: Enhanced<N>, rhs: Enhanced<N>) -> Enhanced<N> {
    var lhs = lhs
    lhs /= rhs
    return lhs
}

prefix public func - < N : Numeric > (lhs: Enhanced<N>) -> Enhanced<N> {
    switch lhs {
    case let .finite(value):    return .finite(-value)
    case let .infinity(s):      return .infinity(sign: !s)
    default:                    return lhs
    }
}



















