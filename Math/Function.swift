//
//  Function.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 14.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

protocol Function {
    associatedtype Operand
    associatedtype Result
    func call(x: Operand) -> Result
    var name : String { get }
}

struct PolynomialFunction< N : Numeric > : Function, CustomStringConvertible {
    var polynomial : Polynomial<N>
    var name : String
    init(polynomial: Polynomial<N>, name: String = "f") {
        self.polynomial = polynomial
        self.name = name
    }
    
    func call(x: N) -> N? {
        return polynomial.call(x: x)
    }
    var description : String {
        return "\(name)(x) = \(polynomial)"
    }
}
