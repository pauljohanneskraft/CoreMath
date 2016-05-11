//
//  Array.swift
//  Math
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// extension to add swapping-capability, e.g. comfortable when sorting

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