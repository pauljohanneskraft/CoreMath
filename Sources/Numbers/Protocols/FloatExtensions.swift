//
//  FloatExtensions.swift
//  Math
//
//  Created by Paul Kraft on 21.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Float {
    public static func % (lhs: Float, rhs: Float) -> Float {
        return lhs.truncatingRemainder(dividingBy: rhs)
    }
    
    public static func %= (lhs: inout Float, rhs: Float) {
        lhs.formTruncatingRemainder(dividingBy: rhs)
    }
}

extension Float: Ordered {
    public static var min: Float { return .leastNormalMagnitude }
    public static var max: Float { return .greatestFiniteMagnitude }
}

extension Float: AdvancedNumeric {
    public var integer: Int { return Int(self) }
    public var double: Double { return Double(self) }
    
    public var isInteger: Bool {
        return isReal && truncatingRemainder(dividingBy: 1) == 0
    }
    
    public static func random(inside range: ClosedRange<Float>) -> Float {
        let doubleRange = range.map { Double($0) }
        let randomDouble = Double.random(inside: doubleRange)
        return Float(randomDouble)
    }
}
