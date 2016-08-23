//
//  Numbers.swift
//  Math
//
//  Created by Paul Kraft on 03.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public typealias R = Double
public typealias N = UInt
public typealias Z = Int

public func Z_(_ v: UInt) -> Set<UInt> {
    return Set<UInt>(0..<v)
}

public protocol Ordered : Comparable {
    static var minValue : Self { get }
    static var maxValue : Self { get }
}

public protocol Randomizable {
    static var random : Self { get }
}

infix operator =~

public func =~ (lhs: Double, rhs: Double) -> Bool {
    let inacc = max(lhs.inaccuracy, rhs.inaccuracy)
    return (lhs - rhs).abs <= inacc
}
