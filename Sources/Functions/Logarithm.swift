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
            return ConstantFunction(log(content.value) / log(base))
        case let content as Term:
            return Equation(content.factors.map { Logarithm(base: base, content: $0) }).reduced
        case let content as Exponential:
            return content.base == base ? x : Logarithm(base: base, content: content)
        case let content:
            return Logarithm(base: base, content: content)
        }
    }
    
    func call(x: Double) -> Double {
        return log(content.call(x: x)) / log(base)
    }
    
    func equals(to: Function) -> Bool {
        guard let other = to as? Logarithm else { return false }
        return other.base == base && other.content.equals(to: content)
    }
}

extension Logarithm: CustomStringConvertible {
    var description: String {
        guard base != Constants.Math.e else { return "ln(\(content))" }
        guard base != 2 else { return "ld(\(content))" }
        return "log_\(base.reducedDescription)(\(content))"
    }
}
