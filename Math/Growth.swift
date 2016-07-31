//
//  Growth.swift
//  Math
//
//  Created by Paul Kraft on 30.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

enum GrowthClass < N : BasicArithmetic > {
    case polynomial(exponent: N)
    case exponential(base: N)
    case logistic(mid: N, max: N, steepness: N)
}

enum GrowthFactor {
    case smallO, bigO
    case theta
    case bigOmega, smallOmega
}
