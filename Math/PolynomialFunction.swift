//
//  PolynomialFunction.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct PolynomialFunction: Function {
    init(_ poly: Polynomial<Double>) {
        self.polynomial = poly
    }
    
    var polynomial : Polynomial<Double>
    var derivative: Function { return PolynomialFunction(self.polynomial.derivative).reduced }
	var integral: Function { return PolynomialFunction(self.polynomial.integral).reduced }
	
    func call(x: Double) -> Double {
        return self.polynomial.call(x: x)!
    }
    var reduced: Function {
        if self.polynomial.degree == 0 { return Constant(self.polynomial[0]) }
        return self
    }
    var description: String { return "(\(polynomial.reducedDescription))" }
}
