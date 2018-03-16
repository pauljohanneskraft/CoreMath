//
//  Smoothing.swift
//  Math
//
//  Created by Paul Kraft on 17.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension DiscreteFunction {
    public func smoothed(using range: CountableRange<Int>) -> DiscreteFunction {
        let maxIndex = points.count - 1
        let newPoints = self.points.indices.map { index -> Point in
            let range = max(index + range.lowerBound, 0)...min(index + range.upperBound - 1, maxIndex)
            let y = points[range].reduce(into: 0.0) { (acc: inout Double, point: Point) in acc += point.y }
            return (x: points[index].x, y: y / Double(range.count))
        }
        
        return DiscreteFunction(points: newPoints)
    }
    
    public func smoothed(using range: CountableClosedRange<Int>) -> DiscreteFunction {
        let maxIndex = points.count - 1
        let newPoints = self.points.indices.map { index -> Point in
            let range = max(index + range.lowerBound, 0)...min(index + range.upperBound, maxIndex)
            let y = points[range].reduce(into: 0.0) { (acc: inout Double, point: Point) in acc += point.y }
            return (x: points[index].x, y: y / Double(range.count))
        }
        
        return DiscreteFunction(points: newPoints)
    }
    
    public func smoothed(usingLast count: Int) -> DiscreteFunction {
        return smoothed(using: (-count)...0)
    }
}
