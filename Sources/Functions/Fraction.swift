//
//  Fraction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

struct Fraction {
	var numerator: Function
	var denominator: Function
	
	init(numerator: Function, denominator: Function) {
		self.numerator = numerator
		self.denominator = denominator
	}
}

extension Fraction: Function {
	var derivative: Function {
		return Fraction(
			numerator: (numerator.derivative * denominator) - (denominator.derivative * numerator),
			denominator: denominator * denominator)
	}
	
	var integral: Function {
		assert(false)
		fatalError("integral not yet supported for fractions.")
	}
	
	var reduced: Function {
        switch (numerator.reduced, denominator.reduced) {
        case let (numerator, denominator as ConstantFunction):
            return numerator * (1 / denominator.value)
        case let (numerator as PolynomialFunction, denominator as PolynomialFunction):
            let frac = numerator.polynomial /% denominator.polynomial
            return Equation(
                PolynomialFunction(frac.result),
                Fraction(numerator: PolynomialFunction(frac.remainder.numerator),
                         denominator: PolynomialFunction(frac.remainder.denominator)
                )
            )
        case let (numerator, denominator as Fraction):
            return Fraction(numerator: numerator * denominator.denominator, denominator: denominator.numerator).reduced
        case let (numerator as Fraction, denominator):
            return Fraction(numerator: numerator.numerator, denominator: denominator * numerator.denominator).reduced
        default:
            return self
        }
	}
	
	var description: String {
        return "(\(numerator)) / (\(denominator))" // e.g. x^1 / 2
    }
    
	var latex: String {
        return "\\frac{\(numerator.latex)}{\(denominator.latex)}" // \frac{n}{d}
    }
	
	func equals(to: Function) -> Bool {
        guard let fraction = to as? Fraction else { return false }
        return fraction.denominator == denominator && fraction.numerator == numerator
	}
	
	func call(x: Double) -> Double {
        return numerator.call(x: x) / denominator.call(x: x)
    }
}
