//
//  Function.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 14.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct FunctionType {
	var type : Function.Type
}

extension FunctionType : Hashable {
	public var hashValue : Int { return "\(type)".hashValue }
}

public func == (lhs: FunctionType, rhs: FunctionType) -> Bool {
	return lhs.type == rhs.type
}

var FunctionEquality : [FunctionType:(Function, Function) -> Bool] = [
	FunctionType(type: Equation.self)			: { a,b in return
		(a as! Equation).terms == (b as! Equation).terms },
	
	FunctionType(type: Term.self)				: { a,b in return
		(a as! Term  ).factors == (b as! Term  ).factors },
	
	FunctionType(type: Fraction.self)			: { a,b in return
		(a as! Fraction).numerator == (b as! Fraction).numerator && (a as! Fraction).denominator == (b as! Fraction).denominator },
	
	FunctionType(type: Exponential.self)		: { a,b in return
		(a as! Exponential).base == (b as! Exponential).base },
	
	FunctionType(type: ConstantFunction.self)	: { a,b in return
		(a as! ConstantFunction).value == (b as! ConstantFunction).value },
	
	FunctionType(type: _Polynomial.self)		: { a,b in return
		(a as! _Polynomial).degree == (b as! _Polynomial).degree }
]

public protocol Function : CustomStringConvertible, LaTeXConvertible {
	
	// properties
	var derivative: Function { get }
	var integral: Function { get }
	var reduced : Function { get }
	var debugDescription: String { get }
	
	// functions
	func call(x: Double) -> Double
	func coefficientDescription(first: Bool) -> String
	
	// operators
	static func ==(lhs: Function, rhs: Function) -> Bool
	
	static func + (lhs: Function, rhs: Function) -> Function
	static func * (lhs: Function, rhs: Function) -> Function
	static func / (lhs: Function, rhs: Function) -> Function
	static func - (lhs: Function, rhs: Function) -> Function
	
	prefix static func - (lhs: Function) -> Function
}

public extension Function {
	func integral(c: Double) -> Function {
		return integral + Constant(c)
	}
	func integral(from: Double, to: Double) -> Double {
		let int = self.integral
		return int.call(x: from) - int.call(x: to)
	}
	var debugDescription : String {
		return description
	}
	func coefficientDescription(first: Bool) -> String {
		guard first else { return "+ \(self.description)" }
		return description
	}
}

public func * (lhs: Function, rhs: Function) -> Function {
	if let l = lhs as? Equation {
		if !(rhs is CustomFunction) {
			var res = [Function]()
			for f1 in l.terms { res.append(f1 * rhs) }
			return Equation(res).reduced
		}
	}
	if let r = rhs as? Equation {
		if !(lhs is CustomFunction) {
			var res = [Function]()
			for f1 in r.terms { res.append(f1 * lhs) }
			return Equation(res).reduced
		}
	}
	if var l = lhs as? Term {
		l.factors.append(rhs)
		return l.reduced
	}
	if var r = rhs as? Term {
		r.factors.append(lhs)
		return r.reduced
	}
	return Term(lhs, rhs).reduced
}

public func *= (lhs: inout Function, rhs: Function) {
	if let l = lhs as? Equation {
		if !(rhs is CustomFunction) {
			var res = [Function]()
			for f1 in l.terms { res.append(f1 * rhs) }
			lhs = Equation(res).reduced
			return
		}
	}
	if let r = rhs as? Equation {
		if !(lhs is CustomFunction) {
			var res = [Function]()
			for f1 in r.terms { res.append(f1 * lhs) }
			lhs = Equation(res).reduced
			return
		}
	}
	if var l = lhs as? Term {
		l.factors.append(rhs)
		lhs = l.reduced
		return
	}
	if var r = rhs as? Term {
		r.factors.append(lhs)
		lhs = r.reduced
		return
	}
	lhs = Term(lhs, rhs).reduced
}

public func + (lhs: Function, rhs: Function) -> Function {
	let lhs = lhs.reduced
	let rhs = rhs.reduced
	if let l = lhs as? Equation {
		if let r = rhs as? Equation { return Equation(l.terms + r.terms).reduced }
		return Equation(l.terms + [rhs]).reduced
	}
	if let r = rhs as? Equation {
		return Equation([lhs] + r.terms).reduced
	}
	return Equation(lhs, rhs).reduced
}

public func - (lhs: Function, rhs: Function) -> Function {
	return lhs + (-rhs)
}

public prefix func - (lhs: Function) -> Function {
	if let l = lhs as? Constant { return Constant(-(l.value)) }
	return -1 * lhs
}

private func == (lhs: [Function], rhs: [Function]) -> Bool {
	guard lhs.count == rhs.count else { return false }
	let l = lhs.sorted { $0.description < $1.description }
	let r = rhs.sorted { $0.description < $1.description }
	for i in l.indices { if !(l[i] == r[i]) { return false } }
	return true
}

public func == (lhs: Function, rhs: Function) -> Bool {
	let lhs = lhs.reduced
	let rhs = rhs.reduced
	if type(of: rhs) != type(of: lhs) { return false }
	else {
		// print(lhs, "=?=", rhs)
		let res = FunctionEquality[FunctionType(type: type(of: rhs))]?(lhs, rhs)
		return res != nil ? res! : rhs.description == lhs.description
	}
}

public func / (lhs: Function, rhs: Function) -> Function {
	return Fraction(numerator: lhs, denominator: rhs).reduced
}

struct FunctionWrapper : CustomStringConvertible, LaTeXConvertible {
	var function : Function
	var name : String
	var description: String {
		return "\(self.name)(x) = \(self.function)"
	}
	var latex : String {
		return "\(self.name)(x) = \(self.function.latex)"
	}
}
