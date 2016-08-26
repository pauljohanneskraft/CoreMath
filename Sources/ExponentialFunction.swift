//
//  ExponentialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct Exponential: Function {
	
	public internal(set) var base : Double
	
	public init(base: Double) { self.base = base }
	
	public func call(x: Double) -> Double {
        return pow(base, x)
    }
	
	public var integral : Function {
		// 1/log(b) * b^x
        return Constant(1.0/log(base)) * self
    }
	
    public var reduced: Function {
        if base == 0.0 { return Constant(0.0) }
        if base == 1.0 { return Constant(1.0) }
        return self
    }
    
    public var derivative: Function { return log(base) * self }
	
	public var description	: String { return "\(self.base.reducedDescription)^x"	}
	public var latex		: String { return description		}
}

postfix operator ^^

public postfix func ^^ (lhs: Double) -> Function {
	return Exponential(base: lhs).reduced
}

public func ^ (lhs: Double, rhs: _Polynomial) -> Function {
	assert(rhs.degree == 1)
	return Exponential(base: lhs).reduced
}
