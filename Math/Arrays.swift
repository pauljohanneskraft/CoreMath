//
//  Arrays.swift
//  Math
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

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

func toLaTeX<T>(array array: [T]) -> String {
    var out = "\\begin{pmatrix}\n"
    for value in array.dropLast() {
        out += "\(value) & "
    }
    out += "\(array.last!) \\\\\n"
    return out + "\\end{pmatrix}"
}

func toLaTeX<T>(vector vector: [T]) -> String {
    var out = "\\begin{pmatrix}\n"
    for value in vector.dropLast() {
        out += "\(value) \\\\\n"
    }
    out += "\(vector.last!)\n"
    return out + "\\end{pmatrix}"
}

