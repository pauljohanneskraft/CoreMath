//
//  Term.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Term : Function {
	var integral : Function {
		guard factors.count > 0 else { return Constant(0) }
		guard factors.count > 1 else { return factors[0].integral }
		
		// print("integral of", self)
		
		// taken from: https://en.wikipedia.org/wiki/Integration_by_parts
		
		var terms = [Function]()
		let indices = factors.indices
		let integratedIndex = (Int(arc4random()) % (factors.count - 1)) + 1
		var product = [factors[integratedIndex].integral]
		for i in indices {
			if i == integratedIndex { continue }
			product.append(factors[i])
		}
		let s = Term(product).reduced
		// print(self, "first term:", s, "from product", product)
		if !(s == Constant(0)) { terms.append(s) }
		for i in indices {
			if i == integratedIndex { continue }
			var product : [Function] = [Constant(-1)]
			for j in indices {
				if i != j || i == integratedIndex {
					product.append(factors[i].reduced)
				} else {
					product.append(factors[i].derivative)
				}
			}
			// print(self, "factors \(i):", product)
			let s = Term(product).reduced
			if s == Constant(0) { continue }
			// print(self, "product \(i):", s, "will be integrated")
			let int = s.integral.reduced
			// print(self, "summand \(i):", int, "has been integrated")
			terms.append(int)
			// print(terms)
		}
		let result = Equation(terms).reduced
		// print(self, "end of integrating with result:", result)
		return result
	}
    
    init(_ factors: Function...) {
        self.factors = factors
    }
	
	init(_ factors: [Function]) {
		self.factors = factors
	}
	
    var derivative: Function {
		var terms = [Function]()
		for fi in factors.indices {
			var facs = self.factors
			facs[fi] = facs[fi].derivative
			terms.append(Term(facs).reduced)
		}
        return Equation(terms)
    }
    
    func call(x: Double) -> Double {
        var res = 1.0
        for f in factors {
            res *= f.call(x: x)
        }
        return res
    }
    
    var description: String {
        if factors.isEmpty { return "0" }
        var result = ""
		let f = factors.first!
		if f is Equation	{ result += "(\(f))"	}
		else				{ result +=  "\(f)"		}
        for f in factors.dropFirst() {
			if f is Equation	{ result += "·(\(f))"	}
			else				{ result +=  "·\(f)"	}
        }
        return result
    }
	
	public var latex: String {
		if factors.isEmpty { return "0" }
		var result = "\(factors.first!.latex)"
		for f in factors.dropFirst() {
			result += " \\cdot \(f.latex)"
		}
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
    
    var factors : [ Function ]
}
