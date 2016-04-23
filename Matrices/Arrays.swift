//
//  Arrays.swift
//  Matrices
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Cocoa

infix operator <-> { associativity left precedence 140 }
func <-> <T>(inout left: T, inout right: T) {
    (left, right) = (right, left)
}

extension Array {
    mutating func swap(left: Int, _ right: Int) {
        self[left] <-> self[right]
    }
}

func / <T : NumericType>(left: [T], right: T) -> [T] {
    var left = left
    left /= right
    return left
}

func /= <T : NumericType>(inout left: [T], right: T) -> [T] {
    for valueIndex in 0..<left.count {
        left[valueIndex] = left[valueIndex] / right
    }
    return left
}