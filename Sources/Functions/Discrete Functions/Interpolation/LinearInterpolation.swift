//
//  LinearInterpolation.swift
//  Math
//
//  Created by Paul Kraft on 23.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct LinearInterpolation {
    var function: DiscreteFunction
}

extension LinearInterpolation: Interpolation {
    func call(x: Number) -> Number {
        guard let index = function.points.index(where: { $0.x >= x }) else {
            return function.points.last?.y ?? 0
        }
        guard index > 0 else { return function.points.first?.y ?? 0 }
        
        let upperBound = function.points[index]
        guard upperBound.x > x else { return upperBound.y }
        let lowerBound = function.points[index - 1]
        
        let m = (lowerBound.y - upperBound.y) / (lowerBound.x - upperBound.x)
        return lowerBound.y + m * (x - lowerBound.x)
    }
}
