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
    var reduced : Function { get }
}

extension Function {
    var integral: Function { return integral(c: 0)  }
    func integral(from: Double, to: Double) -> Double {
        let int = self.integral
        return int.call(x: from) - int.call(x: to)
    }
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

func - (lhs: Function, rhs: Function) -> Function {
    return lhs + (-rhs)
}

prefix func - (lhs: Function) -> Function {
    return Term(lhs, ConstantFunction(value: -1)).reduced
}

func == (lhs: Function, rhs: Function) -> Bool {
    let lhs = lhs.reduced
    let rhs = rhs.reduced
    if type(of: rhs) != type(of: lhs) { return false }
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

func / (lhs: Function, rhs: Function) -> Function {
    return Fraction(numerator: lhs, denominator: rhs).reduced
}

struct FunctionWrapper < F : Function > : CustomStringConvertible {
    var function : F
    var name : String
    var description: String {
        return "\(self.name)(x) = \(self.function)"
    }
}
