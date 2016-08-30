//
//  ConstantFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

internal typealias Constant = ConstantFunction

public struct ConstantFunction : Function, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
	
	public var value : Double
	
    public init(_ value:		Double	) { self.value = value					}
    public init(integerLiteral:	Int		) { self.init( Double(integerLiteral) )	}
    public init(floatLiteral:	Double	) { self.init( floatLiteral			  )	}
	
	public var description	: String	{ return self.value.reducedDescription	} // e.g. "1" instead of "1.0"
	public var derivative	: Function	{ return ConstantFunction(0.0)			} // f = a, f' = 0
	public var integral		: Function	{ return value * _Polynomial(degree: 1)	} // f = a, F = a * x
	public var reduced		: Function	{ return self							} // not reducable
	
	public func coefficientDescription	(first: Bool	) -> String { return value.coefficientDescription(first: first)		}
	public func equals					(to:	Function) -> Bool	{ return Optional(value) == (to as? Constant)?.value	}
	public func call					(x:		Double	) -> Double { return value											}
}

public func + (lhs: Function, rhs: Double	) -> Function { return lhs + Constant(rhs)	}
public func + (lhs: Double	, rhs: Function	) -> Function { return Constant(lhs) + rhs	}

public func - (lhs: Function, rhs: Double	) -> Function { return lhs + Constant(-rhs)	}
public func - (lhs: Double	, rhs: Function	) -> Function { return Constant(lhs)+(-rhs)	}

public func * (lhs: Function, rhs: Double	) -> Function { return lhs * Constant(rhs)	}
public func * (lhs: Double	, rhs: Function	) -> Function { return Constant(lhs) * rhs	}

public func / (lhs: Function, rhs: Double	) -> Function { return lhs / Constant(rhs)	}
public func / (lhs: Double	, rhs: Function	) -> Function { return Constant(lhs) / rhs	}

public func += (lhs: inout Function, rhs: Double) { lhs = lhs + rhs }
public func -= (lhs: inout Function, rhs: Double) { lhs = lhs - rhs }
public func *= (lhs: inout Function, rhs: Double) { lhs = lhs * rhs }
public func /= (lhs: inout Function, rhs: Double) { lhs = lhs / rhs }
