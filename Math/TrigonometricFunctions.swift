//
//  TrigonometricFunctions.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation


let sine    : CustomFunction = CustomFunction("sin(x)",
                                              function: { return sin($0) },
                                              integral: { return Equation(cosine, ConstantFunction(value: $0)) },
                                              derivate: { return Term(ConstantFunction(value: -1), cosine) })

let cosine  : CustomFunction = CustomFunction("cos(x)",
                                              function: { return cos($0) },
                                              integral: { return Equation(sine, ConstantFunction(value: $0)) },
                                              derivate: { return sine })

struct Exponential: Function {
    var base : Double
    func call(x: Double) -> Double {
        return pow(base, x)
    }
    func integral(c: Double) -> Function {
        return Equation(Term(ConstantFunction(value: 1.0/log(base)), self), ConstantFunction(value: c))
    }
    var reduced: Function {
        if base == 0.0 { return ConstantFunction(value: 0.0) }
        if base == 1.0 { return ConstantFunction(value: 1.0) }
        return self
    }
    
    var derivate: Function { return Term(ConstantFunction(value: 0.0), self) }
    var description: String { return "\(self.base)^x" }
}

struct PolynomialFunction: Function {
    var polynomial : Polynomial<Double>
    var derivate: Function { return PolynomialFunction(polynomial: self.polynomial.derivate).reduced }
    func integral(c: Double) -> Function {
        return PolynomialFunction(polynomial: self.polynomial.integral(c: c)).reduced
    }
    func call(x: Double) -> Double {
        return self.polynomial.call(x: x)!
    }
    var reduced: Function {
        if self.polynomial.degree == 0 { return ConstantFunction(value: self.polynomial[0]) }
        return self
    }
    var description: String { return polynomial.reducedDescription }
}

/*
public struct Trigonometric {
    static let sine     = Term<Double>(description: "sin(x)") { sin($0) }
    static let cosine   = Term<Double>(description: "cos(x)") { cos($0) }
    static let tangent  = Term<Double>(description: "tan(x)") { tan($0) }
}

public struct LogarithmicFunctions {
    static let baseE   = Term<Double>(description:    "ln(x)") { log  ($0) }
    static let base10  = Term<Double>(description: "log10(x)") { log10($0) }
    static let base2   = Term<Double>(description:  "log2(x)") { log2 ($0) }
}
*/
