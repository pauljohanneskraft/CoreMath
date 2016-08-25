//
//  Fraction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Fraction : Function {
	var description: String { return "(\(numerator)) / (\(denominator))" }
	var latex: String { return "\\frac{\(numerator.latex)}{\(denominator.latex)}" } // \frac{n}{d}
    var numerator: Function
    var denominator : Function
    
    init(numerator: Function, denominator: Function) {
        self.numerator = numerator
        self.denominator = denominator
    }
    
    func call(x: Double) -> Double {
        return numerator.call(x: x) / denominator.call(x: x)
    }
    var derivative: Function {
        return Fraction(
            numerator: (numerator.derivative * denominator) - (denominator.derivative * numerator),
            denominator: denominator * denominator )
    }
	var integral : Function {
        assert(false, "integral not yet supported for fractions.")
        return self
    }
    var reduced: Function {
        let denominator = self.denominator.reduced
        let numerator   = self.numerator.reduced
        if let d = denominator.reduced as? ConstantFunction {
            return numerator * (1.0/d.value)
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
