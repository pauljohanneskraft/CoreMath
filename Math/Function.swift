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
}

struct Term < Number : BasicArithmetic > : Function, CustomStringConvertible {
    
    var term : (Number) -> Number
    var sign : Bool = false
    var description: String
    
    init(description: String, sign : Bool = false, _ term: (Number) -> Number) {
        self.term = term
        self.sign = sign
        self.description = description
    }
    
    func call(x: Number) -> Number {
        return sign ? -term(x) : term(x)
    }
}

func + <N : BasicArithmetic>(lhs: Term<N>, rhs: Term<N>) -> Equation<N> {
    return Equation(terms: [lhs, rhs])
}

struct Equation < Number : BasicArithmetic > : Function, CustomStringConvertible {
    typealias T = Term < Number >
    
    var terms : [ T ]
    
    func call(x: Number) -> Number {
        var value : Number = 0
        for t in terms { value += t.call(x: x) }
        return value
    }
    
    var description : String {
        if terms.isEmpty { return "0" }
        var result = "\(terms.first!)"
        for t in terms.dropFirst() {
            result += (t.sign ? " - " : " + ") + "\(t)"
        }
        return result
    }
    
}

struct FunctionWrapper < F : Function > : CustomStringConvertible {
    var function : F
    var name : String
    var description: String {
        return "\(self.name)(x) = \(self.function)"
    }
}
