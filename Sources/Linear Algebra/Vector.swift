//
//  Vector.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

public protocol Vector: LinearAlgebraicArithmetic {
    var elements: [Number] { get set }
}

extension Vector where Self: All {
    public static func *= (lhs: inout Self, rhs: Number) {
        lhs.elements.indices.forEach { lhs.elements[$0] *= rhs }
    }
}
