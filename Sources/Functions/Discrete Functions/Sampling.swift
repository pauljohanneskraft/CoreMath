//
//  Sampling.swift
//  Math
//
//  Created by Paul Kraft on 30.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Function {
    func sampled(start: Double, interval: Double = 1, end: Double) -> DiscreteFunction {
        return sampled(start: start, interval: interval, count: lround((end - start) / interval) + 1)
    }
    
    func sampled(start: Double, end: Double, count: Int) -> DiscreteFunction {
        return sampled(start: start, interval: (end - start) / Double(count - 1), count: count)
    }
    
    func sampled(start: Double, interval: Double = 1, count: Int) -> DiscreteFunction {
        var currentX = start
        
        let newPoints = (0..<count).map { _ -> DiscreteFunction.Point in
            defer { currentX += interval }
            return (x: currentX, y: call(x: currentX))
        }
        
        return DiscreteFunction(points: newPoints)
    }
    
    func sampled(at xValues: [Double]) -> DiscreteFunction {
        return DiscreteFunction(points: xValues.map { (x: $0, y: call(x: $0)) })
    }
}
