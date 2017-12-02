//
//  Sampling.swift
//  Math
//
//  Created by Paul Kraft on 30.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

extension Function {
    func sampled(start: Double, interval: Double = 1, end: Double) -> DiscreteFunction {
        return sampled(start: start, interval: interval, count: Int((end - start) / interval))
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
