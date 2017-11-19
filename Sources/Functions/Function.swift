//
//  Function.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 14.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol Function: CustomStringConvertible, LaTeXConvertible {
	
	// properties
	var derivative: Function { get }
	var integral: Function { get }
	var reduced: Function { get }
	var debugDescription: String { get }
	
	// functions
	func call(x: Double) -> Double
	func coefficientDescription(first: Bool) -> String
	func equals(to: Function) -> Bool
	
	// operators
	static func == (lhs: Function, rhs: Function) -> Bool
	static func != (lhs: Function, rhs: Function) -> Bool
	
	static func + (lhs: Function, rhs: Function) -> Function
	static func - (lhs: Function, rhs: Function) -> Function
	static func * (lhs: Function, rhs: Function) -> Function
	static func / (lhs: Function, rhs: Function) -> Function
	
	prefix static func - (lhs: Function) -> Function
}

public extension Function {
	
	// properties
	var debugDescription: String { return description }
	
	// functions
	func coefficientDescription(first: Bool	) -> String { return first ? description : "+ \(description)" }
	
	func integral(c:	Double				) -> Function { return integral + Constant(c)											}
	func integral(from: Double, to: Double	) -> Double {
        let int = self.integral
        return int.call(x: from) - int.call(x: to)
    }
}

public func * (lhs: Function, rhs: Function) -> Function {
	if let l = lhs as? Equation {
		if !(rhs is CustomFunction) {
			var res: Function = Constant(0)
			for f1 in l.terms { res = res + (f1 * rhs) }
			return res.reduced
		}
	}
	if let r = rhs as? Equation {
		if !(lhs is CustomFunction) {
			var res: Function = Constant(0)
			for f1 in r.terms { res = res + (f1 * lhs) }
			return res.reduced
		}
	}
	if var l = lhs as? Term { l.factors.append(rhs); return l.reduced }
	if var r = rhs as? Term { r.factors.append(lhs); return r.reduced }
	
	return Term(lhs, rhs).reduced
}

public func + (lhs: Function, rhs: Function) -> Function {
	let lhs = lhs.reduced
	let rhs = rhs.reduced
	if let l = lhs as? Equation {
		if let r = rhs as? Equation { return Equation(l.terms + r.terms).reduced }
		return Equation(l.terms + [rhs]).reduced
	}
	if let r = rhs as? Equation { return Equation([lhs] + r.terms).reduced }
	return Equation(lhs, rhs).reduced
}

public prefix func - (lhs: Function) -> Function {
	if let l = lhs as? Constant { return Constant(-(l.value)) }
	return Constant(-1) * lhs
}

internal func == (lhs: [Function], rhs: [Function]) -> Bool {
	guard lhs.count == rhs.count else { return false }
	let l = lhs.sorted { $0.description < $1.description }
	let r = rhs.sorted { $0.description < $1.description }
    return !l.indices.contains { l[$0] != r[$0] }
}

public func *= (lhs: inout Function, rhs: Function) { lhs = lhs * rhs }
public func += (lhs: inout Function, rhs: Function) { lhs = lhs + rhs }

public func - (lhs: Function, rhs: Function) -> Function {
    return lhs + (-rhs)
}
public func == (lhs: Function, rhs: Function) -> Bool {
    return lhs.reduced.equals(to: rhs.reduced)
}
public func != (lhs: Function, rhs: Function) -> Bool {
    return !(lhs == rhs)
}
public func / (lhs: Function, rhs: Function) -> Function {
    return Fraction(numerator: lhs, denominator: rhs).reduced
}
