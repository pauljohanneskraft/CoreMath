//
//  CustomFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct CustomFunction : Function {
	
	private var function	: (Double)	-> Double
	private var _derivative	: ()		-> Function
	private var _integral	: ()		-> Function
	public	var description	: String
	
	init(_ desc: String, function: @escaping (Double) -> Double, integral: @escaping () -> Function, derivative: @escaping () -> Function) {
		self.description = desc
		self.function = function
		self._integral = integral
		self._derivative = derivative
	}
	
	public var latex		: String	{ return description	}
	public var derivative	: Function	{ return _derivative()	}
	public var integral		: Function	{ return _integral()	}
	public var reduced		: Function	{ return self			} // LOW_PRIO
	
	public func call	(x:		Double	) -> Double	{ return function(x)															}
	public func equals	(to:	Function) -> Bool	{ return type(of: to) == CustomFunction.self && description == to.description	}
	
}
