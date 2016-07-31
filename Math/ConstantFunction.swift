//
//  ConstantFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct ConstantFunction : Function, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    init(value: Double) {
        self.value = value
    }
    init(integerLiteral: Int) {
        self.init(value: Double(integerLiteral))
    }
    init(floatLiteral: Double) {
        self.init(value: floatLiteral)
    }
    var value : Double
    var description: String { return self.value.reducedDescription }
    var derivate: Function { return ConstantFunction(value: 0.0) }
    var _integral: (Double) -> Function { assert(false) }
    func call(x: Double) -> Double {
        return value
    }
    
    var reduced: Function { return self }
    func integral(c: Double) -> Function {
        return _integral(c)
    }
}

func + (lhs: Function, rhs: Double) -> Function {
    return Equation(lhs, ConstantFunction(value: rhs)).reduced
}

func * (lhs: Function, rhs: Double) -> Function {
    return Term(lhs, ConstantFunction(value: rhs)).reduced
}












