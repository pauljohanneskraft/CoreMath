//
//  TrigonometricCurveFitting.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct TrigonometricCurveFitting: CurveFittingFunction {
    public var parameters: [Double]
    public var kind: TrigonometricFunction.Kind
    
    public init(parameters: [Double], kind: TrigonometricFunction.Kind) {
        self.parameters = parameters
        self.kind = kind
    }
    
    public var function: Function {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? 1
        let p2 = parameters.get(at: 2) ?? 1
        return p0 + p1 * TrigonometricFunction(content: p2*x, kind: kind)
    }
    
    public func call(withoutCoefficients x: Double) -> Double {
        return kind.function((parameters.get(at: 2) ?? 1)*x)
    }
}

public struct ExponentialCurveFitting: CurveFittingFunction {
    public var parameters: [Double]
    
    public init(parameters: [Double]) {
        self.parameters = parameters
    }
    
    public var function: Function {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? 1
        let p2 = parameters.get(at: 2) ?? 1
        return p0 + p1 * (p2^x)
    }
    
    public func call(withoutCoefficients x: Double) -> Double {
        return pow(parameters.get(at: 2) ?? 1, x)
    }
}

extension ExponentialCurveFitting: EmptyInitializable {
    public init() {
        self.init(parameters: [])
    }
}

public struct PolynomialCurveFitting: CurveFittingFunction {
    public var parameters: [Double]
    
    public init(parameters: [Double]) {
        self.parameters = parameters
    }
    
    public func call(withoutCoefficients: Double) -> Double {
        return 0
    }
    
    public var function: Function {
        return parameters.indices.reduce(into: Equation()) { (equation: inout Equation, index: Int) in
               equation.terms.append(Term(Constant(parameters[index]), _Polynomial(degree: Double(index))))
        }
    }
    
    public func call(x: Double) -> Double {
        return parameters.indices.reduce(0.0) { $0 + parameters[$1]*pow(x, Double($1)) }
    }
}

extension PolynomialCurveFitting: EmptyInitializable {
    public init() {
        self.init(parameters: [])
    }
}

public struct LogarithmicCurveFitting: CurveFittingFunction {
    public var parameters: [Double]
    
    public init(parameters: [Double]) {
        self.parameters = parameters
    }
    
    public var function: Function {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? Constants.Math.e
        return p0 + Log(p1, x)
    }
    
    public func call(x: Double) -> Double {
        let p0 = parameters.get(at: 0) ?? 0
        let p1 = parameters.get(at: 1) ?? Constants.Math.e
        return p0 + log(base: p1, of: x)
    }
    
    public func call(withoutCoefficients x: Double) -> Double {
        return 0
    }
}

extension LogarithmicCurveFitting: EmptyInitializable {
    public init() {
        self.init(parameters: [])
    }
}

public struct CustomCurveFitting: CurveFittingFunction {
    public var parameters: [Double]
    public var generateFunction: ([Double]) -> Function
    
    public init(parameters: [Double], generateFunction: @escaping ([Double]) -> Function) {
        self.parameters = parameters
        self.generateFunction = generateFunction
    }
    
    public var function: Function {
        return generateFunction(parameters)
    }
    
    public func call(x: Double) -> Double {
        return function.call(x: x)
    }
    
    public func call(withoutCoefficients: Double) -> Double {
        return 0
    }
}

extension DiscreteFunction {
    public func customCurveFit(generator: @escaping ([Double]) -> Function,
                               initialValues: [Double]) -> CurveFittingFunction {
        let curveFitter = CustomCurveFitting(parameters: initialValues, generateFunction: generator)
        return curveFit(using: curveFitter)
    }
}
