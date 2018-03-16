//
//  PolynomialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct PolynomialFunction: Function {
	
	// stored properties
	public var polynomial: Polynomial<Double>
	
	// initializers
	public init(_ poly: Polynomial<Double>) {
        self.polynomial = poly
    }
	
	// computed properties
	public var derivative: Function {
        return PolynomialFunction(polynomial.derivative).reduced
    }
    
	public var integral: Function {
        return PolynomialFunction(polynomial.integral).reduced
    }
    
	public var reduced: Function {
        return degree == 0 ? Constant(polynomial[0]) : self
    }
    
	public var description: String {
        return degree == 0 ? polynomial[0].reducedDescription : "(\(polynomial.reducedDescription))"
    }
	public var degree: Int {
        return polynomial.degree
    }
	
	// functions
	public func equals(to: Function) -> Bool {
        guard let other = to as? PolynomialFunction else { return false }
        return other.polynomial == polynomial
    }
	public func call(x: Double) -> Double {
        return polynomial.call(x: x) ?? .nan
    }
}
