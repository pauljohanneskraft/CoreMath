//
//  Equation.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Equation : Function, CustomStringConvertible {
    var derivate: Function {
        var funcs = [Function]()
        for t in terms { funcs.append(t.derivate) }
        return Equation(funcs)
    }
    
    func integral(c: Double) -> Function {
        var funcs = [Function]()
        for t in terms { funcs.append(t.integral) }
        return Equation(funcs)
    }
    
    var terms : [ Function ]
    
    init(_ terms: Function...) { self.init(terms) }
    
    init(_ terms: [Function]) {
        self.terms = terms
    }
    
    func call(x: Double) -> Double {
        var value = 0.0
        for t in terms { value += t.call(x: x) }
        return value
    }
    
    var description : String {
        if terms.isEmpty { return "0" }
        var result = "\(terms.first!)"
        for t in terms.dropFirst() {
            result += " + \(t)"
        }
        return result
    }
    
    var reduced: Function {
        var this = self
        var i = 0
        var rest = 0.0
        var poly = PolynomialFunction(0)
        while i < this.terms.count {
            this.terms[i] = this.terms[i].reduced
            if let r = this.terms[i] as? ConstantFunction {
                rest += r.value
                this.terms.remove(at: i)
            } else if let r = this.terms[i] as? PolynomialFunction {
                poly.polynomial += r.polynomial
                this.terms.remove(at: i)
            }
            i += 1
        }
        if poly.polynomial != 0 { this.terms.append(poly.reduced) }
        if rest != 0.0 { this.terms.append(ConstantFunction(value: rest)) }
        if this.terms.count >  1 { return this }
        if this.terms.count == 1 { return this.terms[0] }
        return ConstantFunction(value: 0.0)
    }
    
}
