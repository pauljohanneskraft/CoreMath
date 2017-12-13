//
//  Interpolation.swift
//  Math
//
//  Created by Paul Kraft on 30.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

protocol Interpolation: Function {
    typealias Number = Double
    typealias Point = (x: Number, y: Number)
    var function: DiscreteFunction { get set }
    init(function: DiscreteFunction)
    init(points: [Point])
    mutating func add(point: Point) throws
    func call(x: Number) -> Number
}

extension Interpolation {
    subscript(x: Number) -> Number {
        return call(x: x)
    }
    
    init(points: [Point]) {
        self.init(function: DiscreteFunction(points: points))
    }
    
    var integral: Function {
        guard let integral = function.integral as? DiscreteFunction else {
            return Constant(0)
        }
        return Self.init(function: integral)
    }
    
    var derivative: Function {
        guard let derivative = function.derivative as? DiscreteFunction else {
            return Constant(0)
        }
        return Self.init(function: derivative)
    }
    
    var description: String {
        return "\(Self.self): \(function)"
    }
    
    var points: [Point] {
        return function.points
    }
    
    mutating func add(point: Point) throws {
        try function.points.insertSortedNoDuplicates(point, where: { $0.x < $1.x }, equal: { $0.x == $1.x })
    }
    
    var reduced: Function {
        return self
    }
    
    func equals(to: Function) -> Bool {
        return function.equals(to: to)
    }
    
    func converted<I: Interpolation>(to: I.Type) -> I {
        return I.init(function: function)
    }
}

extension DiscreteFunction {
    func interpolate(using type: Interpolation.Type) -> Interpolation {
        return type.init(points: points)
    }
}
