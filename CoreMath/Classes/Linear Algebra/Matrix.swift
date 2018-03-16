//
//  Matrix.swift
//  Math
//
//  Created by Paul Kraft on 19.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol Matrix: LinearAlgebraic {
    static func *= <L: LinearAlgebraic>(lhs: inout Self, rhs: L) where L.Number == Number
}

extension Matrix where Self: All {
    public static func * <L: LinearAlgebraic>(lhs: Self, rhs: L) -> Self where L.Number == Number {
        return lhs.copy { $0 *= rhs }
    }
}
