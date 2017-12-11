//
//  Power.swift
//  Math
//
//  Created by Paul Kraft on 03.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct Power {
    var base: Function
    var exponent: Function
}

extension Power: Function {
    var integral: Function {
        return self
    }
    
    var derivative: Function {
        return self
    }
    
    var reduced: Function {
        switch (base.reduced, exponent.reduced) {
        case let (base as Constant, exponent as Constant):
            return Constant(base.value.power(exponent.value)).reduced
        case let (base, exponent as Constant):
            switch exponent.value {
            case 0:
                return Constant(1)
            case 1:
                return base
            default:
                return Power(base: base, exponent: exponent)
            }
        case let (base as Constant, exponent):
            switch base.value {
            case 0:
                return Constant(0)
            case 1:
                return Constant(1)
            default:
                return Power(base: base, exponent: exponent)
            }
        case let (base, exponent):
            return Power(base: base, exponent: exponent)
        }
    }
    
    func call(x: Double) -> Double {
        return base.call(x: x).power(exponent.call(x: x))
    }
    
    func equals(to: Function) -> Bool {
        guard let other = to as? Power else { return false }
        return base == other.base && exponent == other.exponent
    }
}

extension Power: CustomStringConvertible {
    var description: String {
        return "(\(base))^(\(exponent))"
    }
}
