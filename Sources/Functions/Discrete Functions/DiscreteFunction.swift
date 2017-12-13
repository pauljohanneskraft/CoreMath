//
//  DiscreteFunction.swift
//  Math
//
//  Created by Paul Kraft on 29.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

public struct DiscreteFunction {
    public typealias Point = (x: Double, y: Double)
    public var points: [Point]
    
    public init(points: [Point]) {
        self.points = points.sorted { $0.x < $1.x }
    }
}

extension DiscreteFunction: Function {
    var bounds: (first: Double, last: Double) {
        return (points.first?.x ?? 0, points.last?.x ?? 0)
    }
    
    public var integral: Function {
        var accumulator: Double = 0
        
        let newPoints = points.indices.dropLast().map { index -> Point in
            let this = points[index], next = points[index + 1]
            accumulator += (next.x - this.x) * this.y
            return (x: next.x, y: accumulator)
        }
        
        return DiscreteFunction(points: [(points.first?.x ?? 0, 0)] + newPoints)
    }
    
    public var derivative: Function {
        let newPoints = points.indices.dropLast().map { index -> Point in
            let this = points[index], next = points[index + 1]
            return (x: this.x, y: (next.y - this.y) / (next.x - this.x))
        }
        return DiscreteFunction(points: newPoints)
    }
    
    public var reduced: Function {
        return self
    }
    
    public func call(x: Double) -> Double {
        return (points.first(where: { $0.x >= x }) ?? points.last ?? (0, 0)).y
    }
    
    public func equals(to other: Function) -> Bool {
        guard let otherDiscrete = other as? DiscreteFunction, points.count == otherDiscrete.points.count else {
            return false
        }
        return !points.indices.contains { points[$0] != otherDiscrete.points[$0] }
    }
}

extension DiscreteFunction: CustomStringConvertible {
    public var description: String {
        return "["
            + points.map { "(\($0.x.reducedDescription), \($0.y.reducedDescription))" }
                .joined(separator: ", ")
            + "]"
    }
}

extension DiscreteFunction: Equatable {
    public static func == (lhs: DiscreteFunction, rhs: DiscreteFunction) -> Bool {
        return lhs.equals(to: rhs)
    }
}
