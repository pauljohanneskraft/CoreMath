//
//  Term.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct Term: Function {
	
	// stored properties
	public var factors : [ Function ]
	
	// initializers
	public init(_ factors: Function...	) { self.factors = factors }
	public init(_ factors: [Function]	) { self.factors = factors }
	
	// computed properties
	public var integral: Function {
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
	
	public var derivative: Function {
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

	public var description: String { return coefficientDescription(first: true) }
	
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
	
	public var reduced: Function {
        guard factors.count > 1 else {
            return factors.first ?? Constant(0)
        }
        
		var this = self
		var i = 0
		var rest = 1.0
		var polynomialFunction = PolynomialFunction(1)
		var _polynomial = _Polynomial(degree: 0)
		while i < this.factors.count {
            switch this.factors[i] {
            case let r as Term:
                this.factors.append(contentsOf: r.factors)
                this.factors.remove(at: i)
            case let r as Constant:
                guard r.value != 0 else { return r }
                rest *= r.value
                this.factors.remove(at: i)
            case let r as PolynomialFunction:
                guard r.polynomial != 0 else { return Constant(0) }
                polynomialFunction.polynomial *= r.polynomial
                this.factors.remove(at: i)
            case let r as _Polynomial:
                _polynomial.degree += r.degree
                this.factors.remove(at: i)
            case let r as Fraction:
                this.factors.remove(at: i)
                return Fraction(
                    numerator: Term(
                        [r.numerator, polynomialFunction, _polynomial, ConstantFunction(rest)] + this.factors
                        ).reduced,
                    denominator: r.denominator).reduced
            default: i += 1
            }
		}

        if _polynomial.degree != 0 {
            this.factors.append(_polynomial)
        }
        
        let r = polynomialFunction.polynomial * Polynomial<Double>(floatLiteral: rest)
		if r != 1.0 {
			if r.degree == 0 {
                this.factors = [Constant(r[0])] + this.factors
            } else {
                this.factors.append(PolynomialFunction(r).reduced)
            }
		}
        return this.factors.count > 1 ? this : this.factors.first ?? Constant(1)
	}
	
	// functions
	public func call(x: Double) -> Double {
        return factors.reduce(into: 1) { $0 *= $1.call(x: x) }
	}
	
	public func coefficientDescription(first: Bool) -> String {
		guard factors.count > 1 else {
            return factors.first?.coefficientDescription(first: false) ?? 0.description
        }
        
		guard let coeff = factors.first as? Constant else {
            let sign = first ? "" : "+ "
            let rest = factors.reduce("") { $0 + ($1 is Equation ? "·(\($1))" : "·\($1)") }.dropFirst()
            return sign + rest
        }
        
        let hasMinusOne = coeff.value.abs == 1
        var result = coeff.value.coefficientDescription(first: first)
        guard factors.count > 2 else {
            let f = factors[1]
            switch f {
            case is Equation: return result + "·(\(f))"
            case is _Polynomial, is CustomFunction: return result + "\(f)"
            default: return result + "·\(f)"
            }
        }
        if !hasMinusOne { result += "·( " }
        let facs = factors.dropFirst().reduce("") { $0 + ($1 is Equation ? "·(\($1))" : "·\($1)") }.dropFirst()
        return result + facs + (hasMinusOne ? "" : " )")
	}
	
	public func equals(to: Function) -> Bool {
		if let t = to as? Term { return t.factors == self.factors }
		return false
	}
}
