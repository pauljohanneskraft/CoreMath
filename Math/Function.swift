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

struct FunctionWrapper < F : Function > : CustomStringConvertible {
    var function : F
    var name : String
    var description: String {
        return "\(self.name)(x) = \(self.function)"
    }
}
