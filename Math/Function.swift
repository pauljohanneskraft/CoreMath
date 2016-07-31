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
        return Equation(res).reduced
    }
    if let r = rhs as? Equation {
        var res = [Function]()
        for f1 in r.terms { res.append(f1 * lhs) }
        return Equation(res).reduced
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

func + (lhs: Function, rhs: Function) -> Function {
    if let l = lhs as? Equation {
        if let r = rhs as? Equation { return Equation(l.terms + r.terms).reduced }
        return Equation(l.terms + [rhs]).reduced
    }
    if let r = rhs as? Equation {
        return Equation(r.terms + [lhs]).reduced
    }
    return Equation(lhs, rhs).reduced
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

extension Function {
    var reduced : Function {
        if var this = self as? Equation {
            var i = 0
            var rest = 0.0
            while i < this.terms.count {
                if let r = this.terms[i] as? ConstantFunction {
                    rest += r.value
                    this.terms.remove(at: i)
                }
                i += 1
            }
            if rest != 0.0 { this.terms.append(ConstantFunction(value: rest)) }
            if this.terms.count == 1 { return this.terms[0] }
            return this
        }
        if var this = self as? Term {
            var i = 0
            var rest = 1.0
            while i < this.factors.count {
                if let r = this.factors[i] as? ConstantFunction {
                    rest *= r.value
                    this.factors.remove(at: i)
                }
                i += 1
            }
            if rest != 1.0 { this.factors.append(ConstantFunction(value: rest)) }
            if this.factors.count == 1 { return this.factors[0] }
            return this
        }
        return self
    }
}

func == (lhs: Function, rhs: Function) -> Bool {
    let lhs = lhs.reduced
    let rhs = rhs.reduced
    if rhs.dynamicType != lhs.dynamicType { return false }
    else {
        switch rhs {
        case is Equation:
            var r = (rhs as! Equation).terms
            var l = (lhs as! Equation).terms
            if r.count != l.count { return false }
            l = l.sorted(by:{ return "\($0)" < "\($1)" })
            r = r.sorted(by:{ return "\($0)" < "\($1)" })
            for i in l.indices {
                if !(l[i] == r[i]) { return false }
            }
            return true
        case is Term:               return (rhs as! Term) == (lhs as! Term)
        case is ConstantFunction:   return (rhs as! ConstantFunction).value == (lhs as! ConstantFunction).value
        case is Exponential:        return (rhs as! Exponential).base == (lhs as! Exponential).base
        case is CustomFunction:     return rhs.description == lhs.description
        default: return true
        }
    }
}

struct FunctionWrapper < F : Function > : CustomStringConvertible {
    var function : F
    var name : String
    var description: String {
        return "\(self.name)(x) = \(self.function)"
    }
}
