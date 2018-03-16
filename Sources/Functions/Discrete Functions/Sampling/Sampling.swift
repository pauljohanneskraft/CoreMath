//
//  Sampling.swift
//  Math
//
//  Created by Paul Kraft on 30.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Function {
    public func sampled(in range: SamplingRange) -> DiscreteFunction {
        var currentX = range.start
        
        let newPoints = (0..<range.count).map { _ -> DiscreteFunction.Point in
            defer { currentX += range.interval }
            return (x: currentX, y: call(x: currentX))
        }
        
        return DiscreteFunction(points: newPoints)
    }
    
    public func sampled(start: Double, interval: Double = 1, end: Double) -> DiscreteFunction {
        let range = SamplingRange(start: start, interval: interval, end: end)
        return sampled(in: range)
    }
    
    public func sampled(start: Double, end: Double, count: Int) -> DiscreteFunction {
        let range = SamplingRange(start: start, end: end, count: count)
        return sampled(in: range)
    }
    
    public func sampled(start: Double, interval: Double = 1, count: Int) -> DiscreteFunction {
        let range = SamplingRange(start: start, interval: interval, count: count)
        return sampled(in: range)
    }
    
    public func sampled(at xValues: [Double]) -> DiscreteFunction {
        return DiscreteFunction(points: xValues.map { (x: $0, y: call(x: $0)) })
    }
}
