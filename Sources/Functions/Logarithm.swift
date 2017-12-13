//
//  Logarithm.swift
//  Math
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public func Log(_ base: Double = 10, _ of: Function) -> Function {
    return Logarithm(base: base, content: of).reduced
}

public func Log(_ base: Double = 10, _ double: Double) -> Function {
    return Constant(log(base: base, of: double))
}

public func Ln(_ double: Double) -> Function {
    return Constant(log(base: Constants.Math.e, of: double))
}

public func Ln(_ fun: Function) -> Function {
    return Logarithm(base: Constants.Math.e, content: fun).reduced
}

public func Ld(_ double: Double) -> Function {
    return Constant(log(base: 2, of: double))
}

public func Ld(_ of: Function) -> Function {
    return Logarithm(base: 2, content: of).reduced
}

public struct Logarithm {
    public var base: Double
    public var content: Function
    
    public init(base: Double, content: Function) {
        self.base = base
        self.content = content
    }
}

extension Logarithm: Function {
    public var integral: Function {
        return content * Logarithm(base: base, content: content) - content
    }
    
    public var derivative: Function {
        return Fraction(numerator: content.derivative, denominator: content * log(base)).reduced
    }
    
    public var reduced: Function {
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
    
    public func call(x: Double) -> Double {
        return log(base: base, of: content.call(x: x))
    }
    
    public func equals(to: Function) -> Bool {
        guard let other = to as? Logarithm else { return false }
        return other.base == base && other.content.equals(to: content)
    }
}

extension Logarithm: CustomStringConvertible {
    public var description: String {
        let logDescs = [Float(Constants.Math.e): "ln", 2: "ld", 10: "lg"]
        let logDesc = logDescs[Float(base)] ?? "log_\(base.reducedDescription)"
        return logDesc + "(\(content))"
    }
}
