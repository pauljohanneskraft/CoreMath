//
//  TrigonometricFunctions.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct CustomFunction : Function, CustomStringConvertible {
    
    init(_ desc: String, function: (Double) -> Double, integral: (Double) -> Function, derivate: () -> Function) {
        self.description = desc
        self.function = function
        self._integral = integral
        self._derivate = derivate
    }
    var description: String
    var _derivate: () -> Function
    var derivate: Function { return _derivate() }
    var _integral: (Double) -> Function
    var function: (x: Double) -> Double
    func call(x: Double) -> Double {
        return function(x: x)
    }
    func integral(c: Double) -> Function {
        return _integral(c)
    }
}

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
    func integral(c: Double) -> Function {
        return _integral(c)
    }
}

let sine : CustomFunction = CustomFunction("sin(x)",
                                           function: { return sin($0) },
                                           integral: { return Equation(cosine, ConstantFunction(value: $0)) },
                                           derivate: { return Term(ConstantFunction(value: -1), cosine) })

let cosine = CustomFunction("cos(x)",
                            function: { return cos($0) },
                            integral: { return Equation(sine, ConstantFunction(value: $0)) },
                            derivate: { return sine })

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
