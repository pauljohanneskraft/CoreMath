//
//  Complex.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 06.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public typealias C = Complex<Double> // swiftlint:disable:this type_name

// makes it possible to write something like the following:
//
// var myComplex = 2 + 3*i
//

public struct Complex<Number: Numeric> {
    public typealias PolarForm = (coefficient: Double, exponent: Double)

    public var real: Number
    public var imaginary: Number
    
    public init(real: Number, imaginary: Number = 0) {
        self.real = real
        self.imaginary = imaginary
    }
}

// MARK: - Initializer
extension Complex {
    public init(_ v: Double) {
        self.init(real: Number(floatLiteral: v), imaginary: 0)
    }
    
    public init(_ v: Int) {
        self.init(real: Number(integerLiteral: v), imaginary: 0)
    }
}

extension Complex {
    public init(coefficient: Double, exponent: Double) {
        real = Number(coefficient * cos(exponent))
        imaginary = exponent == Double.pi ? 0 : Number(coefficient * sin(exponent))
    }
    
    public init(polarForm: PolarForm) {
        self.init(coefficient: polarForm.coefficient, exponent: polarForm.exponent)
    }
}

// MARK: - Computed properties
extension Complex {
    public static var i: Complex {
        return Complex(real: 0, imaginary: 1)
    }
    
    public var conjugate: Complex {
        return Complex<Number>(real: self.real, imaginary: -(self.imaginary))
    }
    
    public var polarForm: PolarForm {
        return (self.abs.real.double, atan2(imaginary.double, real.double))
    }
    
    public var abs: Complex {
        return Complex(real: (real*real + imaginary*imaginary).sqrt)
    }
}

extension Complex: Equatable {
    public static func == (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
    }
}

extension Complex: Hashable {
    public var hashValue: Int {
        if MemoryLayout<Number>.size == MemoryLayout<Int>.size {
            return unsafeBitCast(real, to: Int.self) &+ unsafeBitCast(imaginary, to: Int.self)
        } else { return -real.hashValue &+ imaginary.hashValue }
    }
}

extension Complex: CustomStringConvertible {
    public var description: String {
        switch (real == 0, imaginary == 0) {
        case (true, true):
            return "0"
        case (true, false):
            return imaginary.coefficientDescription(first: true) + "i"
        case (false, true):
            return real.reducedDescription
        case (false, false):
            return "(\(real.reducedDescription) \(imaginary.coefficientDescription(first: false))i)"
        }
    }
}

extension Complex: Comparable {
    public static func < (lhs: Complex, rhs: Complex) -> Bool {
        guard lhs.real != rhs.real else {
            return lhs.imaginary < rhs.imaginary
        }
        return lhs.real < rhs.real
    }
}

extension Complex: All {}

extension Complex: BasicArithmetic {
    public static func *= (lhs: inout Complex, rhs: Complex) {
        let l = lhs
        lhs.real = l.real * rhs.real - l.imaginary * rhs.imaginary
        lhs.imaginary = l.real * rhs.imaginary + l.imaginary * rhs.real
    }
    
    public static func += (lhs: inout Complex, rhs: Complex) {
        lhs.real += rhs.real
        lhs.imaginary += rhs.imaginary
    }
    
    public static func -= (lhs: inout Complex, rhs: Complex) {
        lhs.real -= rhs.real
        lhs.imaginary -= rhs.imaginary
    }
    
    public static func /= (lhs: inout Complex, rhs: Complex) {
        let d = rhs.conjugate
        lhs *= d
        let den = rhs * d
        assert(den.imaginary == 0)
        lhs.real /= den.real
        lhs.imaginary /= den.real
    }
    
    public static prefix func - (lhs: Complex) -> Complex {
        return Complex(real: -lhs.real, imaginary: -lhs.imaginary)
    }
}

extension Complex: Numeric {
    public var integer: Int {
        return imaginary == 0 ? real.integer : abs.real.integer
    }
    
    public var isInteger: Bool {
        return imaginary == 0 && real.isInteger
    }
    
    public var double: Double {
        return imaginary == 0 ? real.double : abs.real.double
    }
    
    public static func random(inside range: ClosedRange<Complex<Number>>) -> Complex<Number> {
        return Complex(real: Number.random(inside: range.map { $0.real }),
                       imaginary: Number.random(inside: range.map { $0.imaginary }))
    }
    
    public var sqrt: Complex<Number> {
        var this = self
        if this.imaginary == 0 {
            if real < 0 {
                this.imaginary = (-(this.real)).sqrt
                this.real = 0
            } else { this.real = real.sqrt }
            return this
        } else {
            // source: http://www.mathpropress.com/stan/bibliography/complexSquareRoot.pdf
            let part = abs.real
            let coeff: Number = (1 / Number(integerLiteral: 2).sqrt)
            let sgn: Number = imaginary < 0 ? -1 : 1
            this.real = coeff * (self.real + part).sqrt
            this.imaginary = sgn * coeff * (part - self.real).sqrt
            return this
        }
    }
    
    public func power(_ v: Double) -> Complex<Number> {
        let (coefficient, exponent) = polarForm
        return Complex(coefficient: coefficient.power(v), exponent: exponent * v)
    }
}
