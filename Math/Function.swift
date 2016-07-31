//
//  Function.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 14.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

protocol Function : CustomStringConvertible {
    func call(x: Double) -> Double
    var derivate: Function { get }
    func integral(c: Double) -> Function
}

extension Function {
    var integral: Function { return integral(c: 0)  }
}

func * (lhs: Function, rhs: Function) -> Function {
    if let l = lhs as? Equation {
        var res = [Function]()
        for f1 in l.terms { res.append(f1 * rhs) }
        return Equation(res)
    }
    if let r = rhs as? Equation {
        var res = [Function]()
        for f1 in r.terms { res.append(f1 * lhs) }
        return Equation(res)
    }
    if var l = lhs as? Term {
        l.factors.append(rhs)
        return l
    }
    if var r = rhs as? Term {
        r.factors.append(lhs)
        return r
    }
    return Term(lhs, rhs)
}

func + (lhs: Function, rhs: Function) -> Equation {
    if let l = lhs as? Equation {
        if let r = rhs as? Equation { return Equation(l.terms + r.terms) }
        return Equation(l.terms + [rhs])
    }
    if let r = rhs as? Equation {
        return Equation(r.terms + [lhs])
    }
    return Equation(lhs, rhs)
}

struct Term : Function {
    func integral(c: Double) -> Function { return self }

    init(_ factors: Function...) {
        self.factors = factors
    }
    
    var derivate: Function {
        return self
    }
    
    func call(x: Double) -> Double {
        var res = 0.0
        for f in factors {
            res *= f.call(x: x)
        }
        return res
    }
    
    var description: String {
        var result = "\(factors.first!)"
        for f in factors.dropFirst() {
            result += "*\(f)"
        }
        return result
    }

    var factors : [ Function ]
}

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
    
}

struct FunctionWrapper < F : Function > : CustomStringConvertible {
    var function : F
    var name : String
    var description: String {
        return "\(self.name)(x) = \(self.function)"
    }
}
