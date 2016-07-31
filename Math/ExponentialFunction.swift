//
//  ExponentialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Exponential: Function {
    var base : Double
    func call(x: Double) -> Double {
        return pow(base, x)
    }
    func integral(c: Double) -> Function {
        return Equation(Term(ConstantFunction(value: 1.0/log(base)), self), ConstantFunction(value: c)).reduced
    }
    var reduced: Function {
        if base == 0.0 { return ConstantFunction(value: 0.0) }
        if base == 1.0 { return ConstantFunction(value: 1.0) }
        return self
    }
    
    var derivate: Function { return Term(ConstantFunction(value: log(base)), self).reduced }
    var description: String { return "\(self.base)^x" }
}
