//
//  CubicSplineInterpolation.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct CubicSplineInterpolation {
    var function: DiscreteFunction
    var derivative: DiscreteFunction
    
    init(function: DiscreteFunction) {
        self.function = function
        // swiftlint:disable:next force_cast
        self.derivative = function.derivative as! DiscreteFunction
    }
}

extension CubicSplineInterpolation: Interpolation {
    func call(x: Double) -> Double {
        guard let index = function.points.index(where: { $0.x >= x }), index < points.count - 1 else {
            return function.points.last?.y ?? 0
        }
        guard index > 0 else { return function.points.first?.y ?? 0 }
        
        let this = points[index - 1], thisDy = derivative.call(x: this.x)
        let next = points[index], nextDy = derivative.call(x: next.x)
        
        let h = next.x - this.x
        let t = (x - this.x) / (next.x - this.x)
        
        let t2 = t * t
        let t3 = t2 * t
        
        return this.y * (2*t3 - 3*t2 + 1)
            + next.y * (-2*t3 + 3*t2)
            + thisDy * h * (t3 - 2*t2 + t)
            + nextDy * h * (t3 - t2)
    }
}
