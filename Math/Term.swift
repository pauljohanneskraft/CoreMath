//
//  Term.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Term : Function {
    func integral(c: Double) -> Function { return self }
    
    init(_ factors: Function...) {
        self.factors = factors
    }
    
    var derivate: Function {
        return self
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
        var result = "\(factors.first!)"
        for f in factors.dropFirst() {
            result += " * \(f)"
        }
        return result
    }
    
    var reduced: Function {
        var this = self
        var i = 0
        var rest = 1.0
        var poly = PolynomialFunction(1)
        while i < this.factors.count {
            // print("testing at", i, ":", this.factors[i], "in", this.factors, "with length", this.factors.count)
            if let r = this.factors[i] as? ConstantFunction {
                if r.value == 0.0 { return r }
                rest *= r.value
                this.factors.remove(at: i)
            } else if let r = this.factors[i] as? PolynomialFunction {
                // print(r, "is polynomial")
                if r.polynomial == 0.0 { return ConstantFunction(value: 0.0) }
                poly.polynomial *= r.polynomial
                this.factors.remove(at: i)
            } else { i += 1 }
            // print("finished -> next()?")
        }
        // print(this.factors, poly, rest)
        let r = poly.polynomial * Polynomial<Double>(rest)
        if r != 1.0 { this.factors.append(PolynomialFunction(r).reduced) }
        if this.factors.count >  1 { return this }
        if this.factors.count == 1 { return this.factors[0] }
        return ConstantFunction(value: 1.0)
    }
    
    var factors : [ Function ]
}
