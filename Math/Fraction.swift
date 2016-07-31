//
//  Fraction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct Fraction : Function {
    public var description: String { return "(\(numerator)) / (\(denominator))" }

    var numerator: Function
    var denominator : Function
    
    init(numerator: Function, denominator: Function) {
        self.numerator = numerator
        self.denominator = denominator
    }
    
    func call(x: Double) -> Double {
        return numerator.call(x: x) / denominator.call(x: x)
    }
    var derivate: Function {
        return Fraction(
            numerator: (numerator.derivate * denominator) - (denominator.derivate * numerator),
            denominator: denominator * denominator )
    }
    func integral(c: Double) -> Function {
        assert(false)
        return self
    }
    var reduced: Function {
        let denominator = self.denominator.reduced
        let numerator   = self.numerator.reduced
        if let d = denominator.reduced as? ConstantFunction {
            return Term(numerator, ConstantFunction(value: 1.0/d.value)).reduced
        }
        if let n = numerator as? PolynomialFunction, let d = denominator as? PolynomialFunction {
            let frac = n.polynomial /% d.polynomial
            return Equation(
                PolynomialFunction(frac.result),
                Fraction(numerator: PolynomialFunction(frac.remainder.numerator), denominator: PolynomialFunction(frac.remainder.denominator)))
        }
        return self
    }
}
