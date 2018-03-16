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
        return Term(Constant(1 / log(base)), self) // 1 / log(b) * b^x
    }
    
    public var derivative: Function {
        return Term(Constant(log(base)), self) // log(b) * b^x
    }
    
	public var description: String {
        guard Float(base) != Float(Constants.Math.e) else { return "e^x" }
        return "\(self.base.reducedDescription)^x"
    }
    
	public var latex: String {
        return description
    }

    public var reduced: Function {
        guard base != 0 && base != 1 else { return Constant(base) }
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
	assert(rhs.degree == 1)
	return Exponential(base: lhs).reduced
}
