//
//  _Polynomial.swift
//  Math
//
//  Created by Paul Kraft on 23.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// swiftlint:disable:next type_name
public struct _Polynomial {
	public internal(set) var degree: Double
    
	public init(degree: Double) {
        self.degree = degree
    }
}

extension _Polynomial: Function {
	public var derivative: Function {
        return degree * _Polynomial(degree: degree - 1)
    }
    
	public var integral: Function {
        return (1 / (degree + 1)) * _Polynomial(degree: degree + 1)
    }
    
	public var reduced: Function {
        return degree == 0 ? Constant(1) : self
    }
	
	public var description: String {
        return degree == 1 ? "x" : "x^\( degree.reducedDescription )"
    }
    
	public var latex: String {
        return degree == 1 ? "x" : "x^{\(degree.reducedDescription)}"
    }
	
	public func call(x: Double) -> Double {
        return pow(x, degree)
    }
    
	public func equals(to: Function) -> Bool {
        return degree == (to as? _Polynomial)?.degree
    }
}

public func ^ (lhs: _Polynomial, rhs: Double) -> _Polynomial {
	return _Polynomial(degree: lhs.degree * rhs)
}

public let x = _Polynomial(degree: 1)
