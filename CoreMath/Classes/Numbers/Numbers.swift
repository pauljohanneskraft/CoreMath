//
//  Numbers.swift
//  Math
//
//  Created by Paul Kraft on 03.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
public typealias R = Double
public typealias N = UInt
public typealias Z = Int
// swiftlint:enable type_name

public func Z_(_ v: UInt) -> Set<UInt> {
	return Set<UInt>(0..<v)
}

public func Z_(_ v: Int) -> Set<Int> {
	return Set<Int>(0..<v)
}

public protocol Ordered: Comparable {
	static var min: Self { get }
	static var max: Self { get }
}

extension Ordered {
    static var range: ClosedRange<Self> {
        return min...max
    }
}

public protocol Randomizable: Comparable {
    static func random(inside: ClosedRange<Self>) -> Self
}

infix operator =~ : ComparisonPrecedence

extension Double {
    public static func =~ (lhs: Double, rhs: Double) -> Bool {
        let inacc = Swift.max(lhs.inaccuracy, rhs.inaccuracy)
        return (lhs - rhs).abs <= inacc
    }
}
