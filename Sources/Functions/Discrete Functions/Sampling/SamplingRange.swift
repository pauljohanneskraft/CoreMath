//
//  InterpolationData.swift
//  Math
//
//  Created by Paul Kraft on 05.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct SamplingRange {
    public static var zero = SamplingRange(start: 0, interval: 0, end: 0, count: 0)
    public let start: Double
    public let end: Double
    public let interval: Double
    public let count: Int
    
    private init(start: Double, interval: Double, end: Double, count: Int) {
        self.start = start
        self.interval = interval
        self.end = end
        self.count = count
    }
    
    public init(start: Double, interval: Double, end: Double) {
        self.init(start: start, interval: interval, end: end, count: lround((end - start) / interval) + 1)
    }
    
    public init(start: Double, interval: Double, count: Int) {
        self.init(start: start, interval: interval, end: start + (interval * Double(count)), count: count)
    }
    
    public init(start: Double, end: Double, count: Int) {
        self.init(start: start, interval: (end - start) / Double(count - 1), end: end, count: count)
    }
    
    public subscript(index: Int) -> Double {
        return start + Double(index) * interval
    }
    
    public var isEmpty: Bool {
        return start >= end
    }
}

extension SamplingRange: Sequence {
    public func makeIterator() -> Iterator {
        return Iterator(range: self, index: 0)
    }
    
    public struct Iterator: IteratorProtocol {
        var range: SamplingRange
        var index = 0
        
        public mutating func next() -> Double? {
            let n = range.start + Double(index) * range.interval
            guard n <= range.end else { return nil }
            index += 1
            return n
        }
    }
}
