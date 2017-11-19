//
//  Interpolation.swift
//  Math
//
//  Created by Paul Kraft on 16.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

enum Interpolation<Number: Numeric> {
    typealias Point = (x: Number, y: Number)
}

extension Interpolation where Number == Double {
    static func interpolate(points: [Point], using function: Function) -> Function {
        
        return function
    }
}
