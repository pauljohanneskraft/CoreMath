//
//  ExponentialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct Exponential {
	public var base: Double
    
	public init(base: Double) {
        self.base = base
    }
}

extension Exponential: Function {
	public var integral: Function {
        return Constant(1 / log(base)) * self // 1 / log(b) * b^x
    }
    
	public var derivative: Function {
        return log(base) * self // log(b) * b^x
    }
    
	public var description: String {
        return "\(self.base.reducedDescription)^x"
    }
    
	public var latex: String {
        return description
    }

    public var reduced: Function {
        guard base != 0 && base != 1 else {
            return Constant(base)
        }
        return self
    }
	
	public func equals(to: Function) -> Bool {
        return (to as? Exponential)?.base == base
	}
	
    public func call(x: Double) -> Double {
        return base.power(x)
    }
}

public func ^ (lhs: Double, rhs: _Polynomial) -> Function {
	precondition(rhs.degree == 1, "only exponential functions with exponent x are currently supported.")
	return Exponential(base: lhs).reduced
}
