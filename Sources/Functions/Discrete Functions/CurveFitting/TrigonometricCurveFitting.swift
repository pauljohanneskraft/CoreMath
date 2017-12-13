//
//  TrigonometricCurveFitting.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct TrigonometricCurveFitting: CurveFittingFunction {
    var parameters: [Double]
    var kind: TrigonometricFunction.Kind
    
    var function: Function {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? 1
        let p2 = parameters.get(at: 2) ?? 1
        return p0 + p1 * TrigonometricFunction(content: p2*x, kind: kind)
    }
    
    func call(withoutCoefficients x: Double) -> Double {
        return kind.function((parameters.get(at: 2) ?? 1)*x)
    }
}

struct ExponentialCurveFitting: CurveFittingFunction {
    var parameters: [Double]
    
    var function: Function {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? 1
        let p2 = parameters.get(at: 2) ?? 1
        return p0 + p1 * (p2^x)
    }
    
    func call(withoutCoefficients x: Double) -> Double {
        return pow(parameters.get(at: 2) ?? 1, x)
    }
}

struct PolynomialCurveFitting: CurveFittingFunction {
    var parameters: [Double]
    
    func call(withoutCoefficients: Double) -> Double {
        return 0
    }
    
    var function: Function {
        return parameters.indices.reduce(Equation()) { a, index -> Function in
            a + parameters[index]*(x^(Double(index)))
        }
    }
    
    func call(x: Double) -> Double {
        return parameters.indices.reduce(0.0) { $0 + parameters[$1]*pow(x, Double($1)) }
    }
}

struct LogarithmicCurveFitting: CurveFittingFunction {
    var parameters: [Double]
    
    var function: Function {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? 1
        return p0 + Log(p1, x)
    }
    
    
    func call(x: Double) -> Double {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? Constants.Math.e
        return p0 + log(base: p1, of: x)
    }
    
    func call(withoutCoefficients x: Double) -> Double {
        return 0
    }
}
