//
//  Array.swift
//  Math
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// extension to add swapping-capability, e.g. comfortable when sorting

import Foundation

extension Array {
    mutating func swap(left: Int, _ right: Int) {
        self[left] <-> self[right]
    }
    
    func toLaTeXVector() -> String {
        var out = "\\begin{pmatrix}\n"
        for value in self.dropLast() {
            out += "\(value) \\\\\n"
        }
        if let last = self.last {
            out += "\(last)\n"
        }
        return out + "\\end{pmatrix}"
    }
    
    func toLaTeX() -> String {
        var out = "\\begin{pmatrix}\n"
        for value in self.dropLast() {
            out += "\(value) & "
        }
        if let last = self.last {
            out += "\(last) \\\\\n"
        }
        return out + "\\end{pmatrix}"
    }
    
    func max(fun: (Element, Element) -> Bool) -> Element {
        let printing = false
        let buckets = 4
        if self.count <= (buckets + buckets) {
            if count == 1 { return self[0] }
            var max : Element = self[0]
            for v in self.dropFirst() {
                if fun(v, max) {
                    max = v
                }
            }
            if printing { print("max in " + self + " is " + max) }
            return max
        }
        let c = Int(log2(Double(buckets)))
        let separator = count >> c
        var arrOfMaxes = [Element]()
        var upperBound = separator
        if printing { print(upperBound + " " + separator)}
        while upperBound < count {
            if printing { print("will search for max in self[\(upperBound-separator)..<\(upperBound)]") }
            arrOfMaxes.append(([] + self[(upperBound-separator)..<upperBound]).max(fun))
            upperBound += separator
        }
        if printing { print("will search for max in self[\(upperBound-separator)..<\(count)]") }
        arrOfMaxes.append(([] + self[upperBound-separator..<count]).max(fun))
        let max = arrOfMaxes.max(fun)
        if printing { print("max in " + self + " is " + max) }
        return max
    }
    
    var range : Range<Int> { return 0..<count }
}

// division of an array and a number (simply divides every single item)

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

prefix func §<T : NumericType>(lhs: [T]) -> [[T]] {
    var res : [[T]] = []
    for v in lhs {
        res.append([v])
    }
    return res
}


