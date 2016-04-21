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
