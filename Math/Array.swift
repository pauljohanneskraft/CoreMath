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

// toLatex(array: ) returns LaTeX code describing the given array as a matrix having only one row

func toLaTeX<T>(array array: [T]) -> String {
    var out = "\\begin{pmatrix}\n"
    for value in array.dropLast() {
        out += "\(value) & "
    }
    out += "\(array.last!) \\\\\n"
    return out + "\\end{pmatrix}"
}

// toLatex(vector: ) returns LaTeX code describing the given array as a matrix having only one column (just like a vector would look like)

func toLaTeX<T>(vector vector: [T]) -> String {
    var out = "\\begin{pmatrix}\n"
    for value in vector.dropLast() {
        out += "\(value) \\\\\n"
    }
    out += "\(vector.last!)\n"
    return out + "\\end{pmatrix}"
}

