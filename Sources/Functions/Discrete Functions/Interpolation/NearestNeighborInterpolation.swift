//
//  NearestNeighborInterpolation.swift
//  Math
//
//  Created by Paul Kraft on 23.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct NearestNeighborInterpolation {
    var function: DiscreteFunction
}
extension NearestNeighborInterpolation: Interpolation {
    func call(x: Number) -> Number {
        guard let index = points.index(where: { $0.x >= x }) else {
            return points.last?.y ?? 0
        }
        guard index > 0 else { return points.first?.y ?? 0 }
        
        let lowerBound = points[index - 1]
        let upperBound = points[index]
        
        let lowerDistance = x - lowerBound.x
        let upperDistance = upperBound.x - x

        return lowerDistance < upperDistance ? lowerBound.y : upperBound.y
    }
}
