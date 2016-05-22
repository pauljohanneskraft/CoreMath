//
//  Constants.swift
//  Math
//
//  Created by Paul Kraft on 14.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct constants {
    static let pi  = 3.14159_26535_89793_23846
    static let tau = 2*pi
    static let e   = 2.71828_18284_59045_23536
    static let y_0 = (4*pi) * (10.0 ^^ -7)
    static let h   = 6.6260_7004_0 * (10.0 ^^ -34)
    static let c   = 299_792_458
}

func Z(_ u: Int) -> Set<Int> {
    guard u >= 0 else { return [] }
    var set = Set<Int>()
    for i in 0..<u { set.insert(i) }
    return set
}






