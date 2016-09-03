//
//  ExponentialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct Exponential: Function {
	
	// stored properties
	public var base : Double
	
	// initializers
	public init(base: Double) { self.base = base }
	
	// computed properties
	public var integral		: Function	{ return Constant(1.0/log(base)) * self			} // 1/log(b) * b^x
	public var derivative	: Function	{ return log(base) * self						} //   log(b) * b^x
	public var description	: String	{ return "\(self.base.reducedDescription)^x"	}
	public var latex		: String	{ return description							}

    public var reduced		: Function	{
        if base == 0.0 { return Constant(0.0) }
        if base == 1.0 { return Constant(1.0) }
        return self
    }
	
	// functions
	public func equals(to: Function) -> Bool {
		if let e = to as? Exponential { return e.base == self.base }
		return false
	}
	
	public func call(x: Double) -> Double { return pow(base, x) }
	
}

public func ^ (lhs: Double, rhs: _Polynomial) -> Function {
	precondition(rhs.degree == 1, "only exponential functions with exponent x are currently supported.")
	return Exponential(base: lhs).reduced
}
