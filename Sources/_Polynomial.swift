//
//  _Polynomial.swift
//  Math
//
//  Created by Paul Kraft on 23.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct _Polynomial : Function {
	
	// stored properties
	public internal(set) var degree: Double
	
	init(degree: Double) { self.degree = degree }
	
	// computed properties
	public var derivative	: Function { return     degree       * _Polynomial(degree: degree - 1) }
	public var integral		: Function { return (1/(degree + 1)) * _Polynomial(degree: degree + 1) }
	public var reduced		: Function { return degree == 0 ? Constant(1) : self			 }
	
	public var description	: String {
		if degree == 1 { return "x" }
		return "x^\( degree.reducedDescription )"
	} // x^3
	public var latex		: String {
		if degree == 1 { return "x" }
		return "x^{\(degree.reducedDescription)}"
	} // x^{3}
	
	// functions
	public func call(x: Double) -> Double { return pow(x, degree) }
}

public func ^ (lhs: _Polynomial, rhs: Double) -> _Polynomial {
	return _Polynomial(degree: lhs.degree * rhs)
}

public let x : _Polynomial = _Polynomial(degree: 1)
