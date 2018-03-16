//
//  NewtonPolynomialInterpolation.swift
//  Math
//
//  Created by Paul Kraft on 23.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

public struct NewtonPolynomialInterpolation: Interpolation {
    public typealias Point = (x: Number, y: Number)
    public private(set) var points: [Point]
    var coefficients: [Number]
    var schemeDiagonal: [Number]
    
    public var function: DiscreteFunction {
        get {
            return DiscreteFunction(points: points)
        }
        set {
            points = newValue.points
            updateCoefficients()
        }
    }
    
    public init(function: DiscreteFunction) {
        self.points = function.points
        self.coefficients = []
        self.schemeDiagonal = []
        updateCoefficients()
        assert(isValid)
    }
    
    public mutating func add(point: (x: Number, y: Number)) throws {
        points.append(point)
        schemeDiagonal.append(point.y)
        
        for i in schemeDiagonal.indices.dropLast().reversed() {
            let dd = schemeDiagonal[i + 1] - schemeDiagonal[i]
            let dx = points[i + 1].x - points[i].x
            schemeDiagonal[i] = dd / dx
        }
        
        coefficients.insert(schemeDiagonal[0], at: 0)
    }
    
    public mutating func updateCoefficients() {
        let indices = points.indices
        coefficients = [Double](repeating: .nan, count: indices.count)
        schemeDiagonal = points.map { $0.y }
        for i in indices {
            coefficients[i] = schemeDiagonal[0]
            for j in indices.dropLast(i + 1) {
                let xDiff = points[j + i + 1].x - points[j].x
                let diagDiff = schemeDiagonal[j + 1] - schemeDiagonal[j]
                schemeDiagonal[j] = diagDiff / xDiff
            }
        }
    }
    
    public var isValid: Bool {
        return points.count == coefficients.count && points.count == schemeDiagonal.count
    }
    
    public func call(x: Number) -> Number {
        assert(isValid)
        let count = points.count
        guard count > 1, var output = coefficients.last else { return coefficients.first ?? 0 }
        
        for i in points.indices.dropLast().reversed() {
            output = coefficients[i] + output * (x - points[i].x)
            // Horner's scheme (((ax + b)x + c)x + d) = ax^3 + bx^2 + cx + d
        }
        
        return output
    }
}
