//
//  Term.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Term : Function {
	
	// stored properties
	var factors : [ Function ]
	
	// initializers
	init(_ factors: Function...	) { self.factors = factors }
	init(_ factors: [Function]	) { self.factors = factors }
	
	// computed properties
	var integral : Function {
		var factors = self.factors
		// print("integral of", self)
		guard factors.count > 2 else {
			guard factors.count > 1 else { return factors.count == 0 ? Constant(0) : factors[0].integral }
			// print("2", self)
			return (factors[0] * factors[1].integral) - (factors[0].derivative*factors[1]).integral
		}
		
		// taken from: https://en.wikipedia.org/wiki/Integration_by_parts
		
		var terms = [Function]()
		let indices = factors.indices
		let integratedIndex = (Math.random() % factors.count)
		let factor = factors[integratedIndex].integral.reduced
		var product = [factor]
		for i in indices {
			if i == integratedIndex { continue }
			product.append(factors[i])
		}
		let s = Term(product).reduced
		print(s, "is the first term to integrate", self)
		// print(self, "first term:", s, "from product", product)
		if !(s == Constant(0)) { terms.append(s) }
		for i in indices {
			if i == integratedIndex { continue }
			var product = [Function]()
			for j in indices {
				if j == integratedIndex {
					product.append(factor)
				} else if i == j {
					product.append(factors[j].derivative)
				} else {
					product.append(factors[j])
				}
				print("(\(i), \(j)) with \(integratedIndex) in \(self) results in", product.last!)
			}
			// print(self, "factors \(i):", product)
			let s = Term(product).reduced
			if s == Constant(0) { continue }
			print(s, "is the \(i). term to be integrated and subtracted \(product) --> integrating", self)
			// print(self, "product \(i):", s, "will be integrated")
			let int = -(s.integral.reduced)
			// print(self, "summand \(i):", int, "has been integrated")
			terms.append(int)
			// print(terms)
		}
		let result = Equation(terms).reduced
		// print(self, "end of integrating with result:", result)
		return result
	}
	
	var derivative: Function {
		var terms = [Function]()
		for fi in factors.indices {
			var facs = self.factors
			let a = facs[fi].derivative
			if a == Constant(0) { continue }
			facs[fi] = a
			let b = Term(facs).reduced
			// print(b)
			terms.append(b)
		}
		return Equation(terms)
	}

	var description: String { return coefficientDescription(first: true) }
	
	public var debugDescription: String {
		guard factors.count > 0 else { return "Term()" }
		var arr = ""
		for i in factors.dropLast() {
			arr += "\(i.debugDescription), "
		}
		return "Term(\(arr)\(factors.last!.debugDescription))"
	}
	
	public var latex: String {
		guard !factors.isEmpty else { return "0" }
		var result = "\(factors.first!.latex)"
		for f in factors.dropFirst() { result += " \\cdot \(f.latex)" }
		return result
	}
	
	var reduced: Function {
		guard factors.count > 0 else { return Constant(0) }
		guard factors.count > 1 else { return factors[0] }
		if factors.count == 2 {
			let lhs = factors[0]
			let rhs = factors[1]
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
		}
		var this = self
		var i = 0
		var rest = 1.0
		var poly = PolynomialFunction(1)
		var poly1 = _Polynomial(degree: 0)
		while i < this.factors.count {
			// print("testing at", i, ":", this.factors[i], "in", this.factors, "with length", this.factors.count)
			switch this.factors[i] {
			case let r as Term:
				this.factors.append(contentsOf: r.factors)
				this.factors.remove(at: i)
			case let r as Constant:
				if r.value == 0.0 { return r }
				rest *= r.value
				this.factors.remove(at: i)
			case let r as PolynomialFunction:
				if r.polynomial == 0.0 { return Constant(0.0) }
				poly.polynomial *= r.polynomial
				this.factors.remove(at: i)
			case let r as _Polynomial:
				poly1 = _Polynomial(degree: r.degree + poly1.degree)
				this.factors.remove(at: i)
			default: i += 1
			}
		}
		// print(this.factors, poly, rest)
		if poly1.degree != 0 { this.factors.append(poly1) }
		let r = poly.polynomial * Polynomial<Double>(rest)
		if r != 1.0 {
			if r.degree == 0 { this.factors = [Constant(r[0])] + this.factors }
			else { this.factors.append(PolynomialFunction(r).reduced) }
		}
		if this.factors.count >  1 { return this }
		if this.factors.count == 1 { return this.factors[0] }
		return Constant(1.0)
	}

	
	// functions
	func call(x: Double) -> Double {
		var res = 1.0
		for f in factors { res *= f.call(x: x) }
		return res
	}
	
	public func coefficientDescription(first: Bool) -> String {
		guard factors.count > 1 else { return factors.count == 0 ? "0" : factors[0].coefficientDescription(first: false) }
		if let coeff = factors[0] as? Constant {
			let hasMinusOne = coeff.value.abs == 1
			var result = "\(coeff.value.coefficientDescription(first: first))"
			guard factors.count > 2 else {
				let f = factors[1]
				switch f {
				case is Equation: return result + "·(\(f))"
				case is _Polynomial, is CustomFunction: return result + "\(f)"
				default: return result + "·\(f)"
				}
			}
			if !hasMinusOne { result += "·( " }
			let f = factors[1]
			if f is Equation	{ result += "(\(f))"	}
			else				{ result +=  "\(f)"		}
			for f in factors.dropFirst(2) {
				if f is Equation	{ result += "·(\(f))"	}
				else				{ result +=  "·\(f)"	}
			}
			guard !hasMinusOne else { return result }
			return result + " )"
		} else {
			var result = first ? "" : "+ "
			let f = factors[0]
			if f is Equation	{ result += "(\(f))"	}
			else				{ result +=  "\(f)"		}
			for f in factors.dropFirst() {
				if f is Equation	{ result += "·(\(f))"	}
				else				{ result +=  "·\(f)"	}
			}
			return result
		}
	}
	
	func equals(to: Function) -> Bool {
		if let t = to as? Term { return t.factors == self.factors }
		return false
	}
}
