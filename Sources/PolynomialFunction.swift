//
//  PolynomialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct PolynomialFunction: Function {
	public func equals(to: Function) -> Bool {
		if let p = to as? PolynomialFunction {
			return p.polynomial == self.polynomial
		}
		return false
	}

	public init(_ poly: Polynomial<Double>) {
		self.polynomial = poly
	}
	
	public var polynomial : Polynomial<Double>
	public var derivative: Function { return PolynomialFunction(self.polynomial.derivative).reduced }
	public var integral: Function { return PolynomialFunction(self.polynomial.integral).reduced }
	
	public func call(x: Double) -> Double {
		return self.polynomial.call(x: x)!
	}
	public var reduced: Function {
		if self.polynomial.degree == 0 { return Constant(self.polynomial[0]) }
		return self
	}
	public var description: String { return "(\(polynomial.reducedDescription))" }
}
