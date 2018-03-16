//
//  Fraction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

public struct Fraction {
	public var numerator: Function
	public var denominator: Function
	
	public init(numerator: Function, denominator: Function) {
		self.numerator = numerator
		self.denominator = denominator
	}
}

extension Fraction: Function {
	public var derivative: Function {
		return Fraction(
			numerator: (numerator.derivative * denominator) - (denominator.derivative * numerator),
			denominator: denominator * denominator).reduced
	}
	
	public var integral: Function {
        let this = self.reduced
        guard this is Fraction else { return this.integral }
        switch denominator.reduced {
        case let denominator as Constant:
            return ((1/denominator.value) * numerator).integral
        case let denominator as _Polynomial:
            return (numerator * _Polynomial(degree: -denominator.degree)).integral
        case let denominator as PolynomialFunction where numerator is PolynomialFunction:
            guard let numerator = self.numerator as? PolynomialFunction else {
                assert(false)
                return self
            }
            let (result, remainder) = numerator.polynomial /% denominator.polynomial
            guard remainder.numerator.isZero else {
                assert(false)
                return self
            }
            return PolynomialFunction(result).integral
        default:
            assert(false)
            fatalError("integral not yet supported for fractions.")
        }
	}
	
	public var reduced: Function {
        let numerator = self.numerator.reduced, denominator = self.denominator.reduced
        guard !numerator.equals(to: denominator) else { return Constant(1) }
        guard !numerator.equals(to: -denominator) else { return Constant(-1) }
        switch (numerator, denominator) {
        case let (numerator, denominator as ConstantFunction):
            return numerator * (1 / denominator.value)
        case let (numerator as PolynomialFunction, denominator as PolynomialFunction):
            let frac = numerator.polynomial /% denominator.polynomial
            guard !frac.remainder.numerator.isZero else { return PolynomialFunction(frac.result) }
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
	
	public var description: String {
        return "(\(numerator)) / (\(denominator))" // e.g. x^1 / 2
    }
    
	public var latex: String {
        return "\\frac{\(numerator.latex)}{\(denominator.latex)}" // \frac{n}{d}
    }
	
	public func equals(to: Function) -> Bool {
        guard let fraction = to as? Fraction else { return false }
        return fraction.denominator == denominator && fraction.numerator == numerator
	}
	
	public func call(x: Double) -> Double {
        return numerator.call(x: x) / denominator.call(x: x)
    }
}
