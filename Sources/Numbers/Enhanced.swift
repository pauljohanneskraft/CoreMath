//
//  EnhancedNumber.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 24.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public enum Enhanced <Number: BasicArithmetic> {
    case finite(Number)
    case infinity(sign: Bool)
    case nan
}

extension Enhanced: Equatable {
    public static func == (lhs: Enhanced, rhs: Enhanced) -> Bool {
        switch (lhs, rhs) {
        case let (.finite(v1), .finite(v2)):
            return v1 == v2
            
        case let (.infinity(s1), .infinity(s2)):
            return s1 == s2
            
        case (.nan, .nan):
            return true
            
        default:
            return false
        }
    }
}

extension Enhanced: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .finite(value):
            return "\(value)"
        case let .infinity(sign):
            return sign ? "-∞" : "∞"
        case .nan:
            return "nan"
        }
    }
}

extension Enhanced: Hashable {
    public var hashValue: Int {
        switch self {
        case .finite(let number):
            return number.hashValue
        case .infinity(let sign):
            return ((sign ? -1 : 1) * Double.infinity).hashValue
        case .nan:
            return Double.nan.hashValue
        }
    }
}

extension Enhanced: BasicArithmetic {
    public init(_ integerLiteral: Int) {
        self = .finite(Number(integerLiteral))
    }
    
    public init(_ floatLiteral: Double) {
        switch floatLiteral.description {
        case "inf":
            self = .infinity(sign: false)
        case "-inf":
            self = .infinity(sign: true)
        case "nan":
            self = .nan
        default:
            self = .finite(Number(floatLiteral: floatLiteral))
        }
    }
    
    public var sign: Bool {
        switch self {
        case let .finite(value):
            return value < 0
        case let .infinity(sign):
            return sign
        case .nan:
            return false
        }
    }
    
    public var abs: Enhanced<Number> {
        switch self {
        case .finite(let num):
            return .finite(num.abs)
        case .infinity:
            return .infinity(sign: false)
        case .nan:
            return .nan
        }
    }
}

extension Enhanced: Comparable {
    public static func < (lhs: Enhanced, rhs: Enhanced) -> Bool {
        switch (lhs, rhs) {
        case let (.finite(v1), .finite(v2)):
            return v1 < v2
        case let (.infinity(s), _):
            return s
        case (.nan, _):
            return true
        case (_, .nan):
            return false
        case let (.finite, .infinity(s)):
            return !s
        default:
            assert(false)
        }
        return false
    }
}

extension Enhanced: All {}

extension Enhanced {
    public static prefix func - (lhs: Enhanced) -> Enhanced {
        switch lhs {
        case let .finite(value):
            return .finite(-value)
        case let .infinity(s):
            return .infinity(sign: !s)
        default:
            return lhs
        }
    }
    
    public static func += (lhs: inout Enhanced, rhs: Enhanced) {
        switch (lhs, rhs) {
        case (.nan, _), (_, .nan):
            lhs = .nan
        case let (.finite(v1), .finite(v2)):
            lhs = .finite(v1 + v2)
        case (.infinity(true), .infinity(false)), (.infinity(false), .infinity(true)):
            lhs = .finite(0)
        case let (.infinity(s), _), let (_, .infinity(s)):
            lhs = .infinity(sign: s)
        default:
            assert(false)
        }
    }
    
    public static func -= (lhs: inout Enhanced, rhs: Enhanced) {
        switch (lhs, rhs) {
        case (.nan, _), (_, .nan):
            lhs = .nan
        case let (.finite(v1), .finite(v2)):
            lhs = .finite(v1 - v2)
        case (.infinity(false), .infinity(false)), (.infinity(true), .infinity(true)):
            lhs = .finite(0)
        case (.infinity(false), _), (_, .infinity(true)):
            lhs = .infinity(sign: true)
        case (_, .infinity(false)), (.infinity(true), _):
            lhs = .infinity(sign: false)
        default:
            assert(false)
        }
    }
    
    public static func *= (lhs: inout Enhanced, rhs: Enhanced) {
        switch (lhs, rhs) {
        case (.nan, _), (_, .nan):
            lhs = .nan
        case let (.finite(v1), .finite(v2)):
            lhs = .finite(v1 * v2) // maybe if too big for "Number" switching to infinity
        case let (.infinity(s), .infinity(t)):
            lhs = .infinity(sign: s != t)
        case let (.infinity(u), _), let (_, .infinity(u)):
            lhs = .infinity(sign: u)
        default:
            assert(false)
        }
    }
    
    public static func /= (lhs: inout Enhanced, rhs: Enhanced) {
        switch (lhs, rhs) {
        case (.nan, _), (_, .nan):
            lhs = .nan
        case (_, .finite(0)):
            lhs = .infinity(sign: lhs.sign)
        case let (.finite(v1), .finite(v2)):
            lhs = .finite(v1 / v2)
        case let (.infinity(s), .infinity(u)):
            lhs = .finite(s == u ? 1 : -1)
        case (_, .infinity):
            lhs = .finite(0)
        case (.infinity, _):
            return
        default:
            assert(false)
        }
    }
}

extension Enhanced where Number: Numeric {
    public static func random(inside range: ClosedRange<Enhanced>) -> Enhanced {
        guard case let .finite(lowerBound) = range.lowerBound, case let .finite(upperBound) = range.upperBound else {
            return .nan
        }
        return .finite(Number.random(inside: lowerBound...upperBound))
    }
    
    public var integer: Int {
        switch self {
        case let .finite(v):
            return v.integer
        case let .infinity(sign):
            return sign ? Int.min : Int.max
        default:
            fatalError("illegal state \(self)")
        }
    }
    
    public var double: Double {
        switch self {
        case let .finite(v):
            return v.double
        case let .infinity(sign):
            return sign ? -Double.infinity : Double.infinity
        case .nan:
            return Double.nan
        }
    }
    
    public var isNormal: Bool {
        return double.isNormal
    }
    
    public var isInteger: Bool {
        switch self {
        case .finite(let number):
            return number.isInteger
        default:
            return false
        }
    }
}

extension Enhanced where Number: Ordered {
    public static var min: Enhanced<Number> {
        return .finite(Number.min)
    }
    
    public static var max: Enhanced<Number> {
        return .finite(Number.max)
    }
}
