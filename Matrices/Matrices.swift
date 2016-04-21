//
//  Matrices.swift
//  Matrizen
//
//  Created by Paul Kraft on 21.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

infix operator * { associativity left precedence 140 }

func * <T: NumericType>(left: [[T]], right: [[T]]) -> [[T]]? {
    if left[0].count != right.count { return nil }
    var matrix : [[T]] = []
    
    for i in 0..<left.count {
        var array : [T] = []
        for j in 0..<right[0].count {
            var value : T = T(0)
            for k in 0..<right.count {
                value = value + (left[i][k]*right[k][j])
            }
            array.append(value)
        }
        matrix.append(array)
    }
    return matrix
}

func * <T: NumericType>(left: [[T]], right: T) -> [[T]] {
    var left = left
    for row in 0..<left.count {
        for column in 0..<left[row].count {
            left[row][column] = left[row][column]*right
        }
    }
    return left
}

func * <T: NumericType>(left: T, right: [[T]]) -> [[T]] {
    var right = right
    for row in 0..<right.count {
        for column in 0..<right[row].count {
            right[row][column] = right[row][column]*left
        }
    }
    return right
}

func print<T>(matrix: [[T]]) {
    print(toLaTeX(matrix))
}

func toLaTeX<T>(matrix: [[T]]) -> String {
    var out = "\\begin{pmatrix}\n"
    for array in matrix {
        for value in array.dropLast() {
            out += "\(value) & "
        }
        out += "\(array.last!) \\\\\n"
    }
    return out + "\\end{pmatrix}"
}

func toLaTeX<T : NumericType>(matrix1: [[T]], _ matrix2: [[T]]) -> String {
    var out = ""
    if let product = matrix1 * matrix2 {
        out = "\\[\n"
        out += toLaTeX(matrix1)
        out += "\\times\n"
        out += toLaTeX(matrix2)
        out += "=\n"
        out += toLaTeX(product)
        out += "\\] \\[ \\]\n"
    }
    return out
}

func toLaTeX<T : NumericType>(scalar: T, _ matrix: [[T]]) -> String {
    let product = scalar * matrix
    var out = "\\[\n"
    out += "\(scalar)"
    out += "\\times\n"
    out += toLaTeX(matrix)
    out += "=\n"
    out += toLaTeX(product)
    out += "\\] \\[ \\]\n"
    return out
}

func toLaTeX<T : NumericType>(matrix: [[T]], _ scalar: T) -> String {
    let product = matrix * scalar
    var out = "\\[\n"
    out += toLaTeX(matrix)
    out += "\\times\n"
    out += "\(scalar)"
    out += "=\n"
    out += toLaTeX(product)
    out += "\\] \\[ \\]\n"
    return out
}

