//
//  ComplexConvertible.swift
//  Math
//
//  Created by Paul Kraft on 24.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol ComplexConvertible: Numeric {
    associatedtype Number: Numeric
    var complex: Complex<Number> { get }
}

extension IntegerAdvancedNumeric {
    public var complex: Complex<Self> { return Complex(self.integer) }
}

extension Int: ComplexConvertible {}
extension Int8: ComplexConvertible {}
extension Int16: ComplexConvertible {}
extension Int32: ComplexConvertible {}
extension Int64: ComplexConvertible {}
extension Double: ComplexConvertible {
    public var complex: C { return C(real: self) }
}

extension Float: ComplexConvertible {
    public var complex: Complex<Float> {
        return Complex(real: self)
    }
}

extension Complex: ComplexConvertible {
    public var complex: Complex<Number> {
        return self
    }
}
