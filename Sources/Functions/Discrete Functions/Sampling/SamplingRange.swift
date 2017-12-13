//
//  InterpolationData.swift
//  Math
//
//  Created by Paul Kraft on 05.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct SamplingRange {
    static var zero = SamplingRange(start: 0, interval: 0, end: 0, count: 0)
    let start: Double
    let end: Double
    let interval: Double
    let count: Int
    
    private init(start: Double, interval: Double, end: Double, count: Int) {
        self.start = start
        self.interval = interval
        self.end = end
        self.count = count
    }
    
    init(start: Double, interval: Double, end: Double) {
        self.init(start: start, interval: interval, end: end, count: lround((end - start) / interval) + 1)
    }
    
    init(start: Double, interval: Double, count: Int) {
        self.init(start: start, interval: interval, end: start + (interval * Double(count)), count: count)
    }
    
    init(start: Double, end: Double, count: Int) {
        self.init(start: start, interval: (end - start) / Double(count - 1), end: end, count: count)
    }
    
    subscript(index: Int) -> Double {
        return start + Double(index) * interval
    }
}

extension SamplingRange: Sequence {
    func makeIterator() -> Array<Double>.Iterator {
        return (0..<count).map { self[$0] }.makeIterator()
    }
}
