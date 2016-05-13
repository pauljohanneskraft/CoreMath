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
    
    func sort(order: (Element, Element) -> Bool) {
        sort { return order($0, $1) }
    }
    
    func combineAll(f: (Element, Element) -> Element) -> Element? {
        if count < 5 {
            if count == 0 { return nil }
            if count == 1 { return self[0] }
            var res = f(self[0], self[1])
            for v in self.dropFirst().dropFirst() {
                res = f(res, v)
            }
            return res
        }
        let mid = count >> 1
        let left  = ([] + self[0..<mid]).combineAll(f)
        let right = ([] + self[mid..<count]).combineAll(f)
        if let l = left {
            if let r = right {
                return f(l,r)
            }
        }
        return nil
    }
    
    func max(fun: (Element, Element) -> Bool) -> Element {
        let buckets = 4
        if self.count <= (buckets << 1) {
            if count == 1 { return self[0] }
            var max : Element = self[0]
            for v in self.dropFirst() {
                if fun(v, max) {
                    max = v
                }
            }
            return max
        }
        let separator = count / buckets
        var arrOfMaxes = [Element]()
        var upperBound = separator
        while upperBound < count {
            arrOfMaxes.append(([] + self[(upperBound-separator)..<upperBound]).max(fun))
            upperBound += separator
        }
        arrOfMaxes.append(([] + self[upperBound-separator..<count]).max(fun))
        let max = arrOfMaxes.max(fun)
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


