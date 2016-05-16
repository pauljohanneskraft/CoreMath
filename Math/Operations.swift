//
//  Operations.swift
//  Math
//
//  Created by Paul Kraft on 14.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

infix operator ⊂ {} // subset
func ⊂ <T: Comparable>(array1: [T], array2: [T]) -> Bool {
    if array1.count < 10 {
        for v in array1 {
            if !array2.contains({ $0 == v }) {
                return false
            }
        }
        return true
    }
    let mid = array1.count >> 1
    return ((array1[0..<mid] + []) ⊂ array2) && ((array1[mid..<array1.count] + []) ⊂ array2)
}

prefix operator ∑ {} // sum of all elements
prefix func ∑ <T : NumericType>(array: [T]) -> T {
    if let all = array.combineAll({ $0 + $1 }) {
        return all
    }
    return 0 as! T
}

prefix operator ∏ {} // product of all elements
prefix func ∏ <T: NumericType>(array: [T]) -> T {
    if let all = array.combineAll({ $0 * $1 }) {
        return all
    }
    return 0 as! T
}
