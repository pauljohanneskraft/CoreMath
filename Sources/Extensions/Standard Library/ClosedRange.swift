//
//  ClosedRange.swift
//  Math
//
//  Created by Paul Kraft on 21.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

extension ClosedRange {
    func map<T>(_ fun: (Bound) -> T) -> ClosedRange<T> {
        return fun(lowerBound)...fun(upperBound)
    }
}

extension ClosedRange where Bound: Ordered {
    static var fullRange: ClosedRange<Bound> {
        return Bound.min...Bound.max
    }
}
