//
//  Equation.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Equation: Function, CustomStringConvertible {
	
	// stored properties
	var terms : [ Function ]
	
	// initializers
	init(_ terms: Function...) { self.init(terms)		}
	init(_ terms: [Function]) { self.terms = terms	}
	
	// computed properties
	var derivative: Function { return Equation(terms.map { $0.derivative.reduced }).reduced }
	var integral: Function { return Equation(terms.map { $0.integral.reduced	}).reduced }
	
	var debugDescription: String {
		guard terms.count > 0 else { return "Term()" }
		var arr = ""
		for i in terms.dropLast() { arr += "\(i.debugDescription), " }
		return "Equation(\(arr)\(terms.last!.debugDescription))"
	}
	
	var description: String {
		if terms.isEmpty { return "0" }
		var result = "\(terms.first!.coefficientDescription(first: true))"
		for t in terms.dropFirst() { result += " \(t.coefficientDescription(first: false))" }
		return result
	}
	
	var latex: String {
		if terms.isEmpty { return "0" }
		var result = "\(terms.first!.latex)"
		for t in terms.dropFirst() { result += " + \(t.latex)" }
		return result
	}
	
	var reduced: Function {
		var this = self
		var i	 = 0
		var rest = 0.0
		var poly = PolynomialFunction(0)
		while i < this.terms.count {
			let t = this.terms[i].reduced
			if let r = t as? ConstantFunction {
				rest += r.value
				this.terms.remove(at: i)
			} else if let r = t as? PolynomialFunction {
				poly.polynomial += r.polynomial
				this.terms.remove(at: i)
			} else {
				this.terms[i] = t
				i += 1
			}
		}
		if poly.polynomial != 0 { this.terms.append(poly.reduced) }
		if rest != 0.0 { this.terms.append(Constant(rest)) }
		if this.terms.count >  1 { return this			}
		if this.terms.count == 1 { return this.terms[0] }
		return Constant(0.0)
	}
	
	// functions
	func call(x: Double) -> Double {
		var value = 0.0
		for t in terms { value += t.call(x: x) }
		return value
	}
	
	func equals(to: Function) -> Bool {
		if let e = to as? Equation { return e.terms == self.terms }
		return false
	}
}
