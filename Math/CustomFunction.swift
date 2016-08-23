//
//  CustomFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct CustomFunction : Function {
    
    init(_ desc: String, function: @escaping (Double) -> Double, integral: @escaping (Double) -> Function, derivate: @escaping () -> Function) {
        self.description = desc
        self.function = function
        self._integral = integral
        self._derivate = derivate
    }
    var description: String
    var _derivate: () -> Function
    var derivate: Function { return _derivate() }
    var _integral: (Double) -> Function
    var function: (Double) -> Double
    func call(x: Double) -> Double {
        return function(x)
    }
    var reduced: Function { return self } // TODO!
    func integral(c: Double) -> Function {
        return _integral(c)
    }
}
