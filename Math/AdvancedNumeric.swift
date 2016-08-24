//
//  AdvancedNumeric.swift
//  Math
//
//  Created by Paul Kraft on 03.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol AdvancedNumeric : Numeric {
    static func % (lhs: Self, rhs: Self) -> Self
    static func %= (lhs: inout Self, rhs: Self)
}

extension AdvancedNumeric {
    func mod(_ v: Int) -> Self {
        let m = self % Self(integerLiteral: v)
        if m < 0 { return m + self }
        return m
    }
}

extension Int {
    init?<N : Numeric>(_ v: N) {
        self = v.integer
    }
}

extension Int    : AdvancedNumeric {
    public var integer : Int {
        return self
    }
    public var double : Double {
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
            z = ((Double(Int.random) / Double(Int.random)) * (Double(Int.random) / Double(Int.random)))
        }
        return z!
    }
    
    public var integer : Int    {
		if self > Double(Int.max) { return Int.max }
		if self < Double(Int.min) { return Int.min }
        return Int(self)
    }
    public var double  : Double  { return self }
    
    static var minValue : Double { return DBL_MAX }
    static var maxValue : Double { return DBL_MIN }
}
