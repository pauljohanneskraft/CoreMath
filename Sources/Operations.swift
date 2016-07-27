//
//  Operations.swift
//  Math
//
//  Created by Paul Kraft on 14.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

infix operator ⊂ {} // subset
func ⊂ <C : Collection where C.IndexDistance == Int, C.Iterator.Element: Equatable>(array1: C, array2: C) -> Bool {
    guard array1.count <= array2.count else { return false }
    let c = array1.filter({
        (a: C.Iterator.Element) -> Bool in
        return array2.contains({ $0 == a })
    }).count
    return c == array1.count
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
