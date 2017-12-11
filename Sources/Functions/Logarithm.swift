//
//  Logarithm.swift
//  Math
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Logarithm {
    var base: Double
    var content: Function
}

extension Logarithm: Function {
    var integral: Function {
        return content * Logarithm(base: base, content: content) - content
    }
    
    var derivative: Function {
        return Fraction(numerator: content.derivative, denominator: content * log(base)).reduced
    }
    
    var reduced: Function {
        switch content.reduced {
        case let content as ConstantFunction:
            return ConstantFunction(log(base: base, of: content.value))
        case let content as Term:
            return Equation(content.factors.map { Logarithm(base: base, content: $0) }).reduced
        case let content as Exponential:
            return log(base: base, of: content.base)*x
        case let content:
            return Logarithm(base: base, content: content)
        }
    }
    
    func call(x: Double) -> Double {
        return log(base: base, of: content.call(x: x))
    }
    
    func equals(to: Function) -> Bool {
        guard let other = to as? Logarithm else { return false }
        return other.base == base && other.content.equals(to: content)
    }
}

extension Logarithm: CustomStringConvertible {
    var description: String {
        let logDescs = [Constants.Math.e: "ln", 2: "ld", 10: "lg"]
        let logDesc = logDescs[base] ?? "log_\(base.reducedDescription)"
        return logDesc + "(\(content))"
    }
}
