//
//  Matrices.swift
//  Matrizen
//
//  Created by Paul Kraft on 21.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

infix operator * { associativity left precedence 140 }
func * (left: [[Int]], right: [[Int]]) -> [[Int]]? {
    if left[0].count != right.count { return nil }
    var matrix : [[Int]] = []
    
    for i in 0..<left.count {
        var array : [Int] = []
        for j in 0..<right[0].count {
            var value = 0
            for k in 0..<right.count {
                value += left[i][k]*right[k][j]
            }
            array.append(value)
        }
        matrix.append(array)
    }
    return matrix
}

func print(matrix: [[Int]]) {
    print(toLaTeX(matrix))
}

func toLaTeX(matrix: [[Int]]) -> String {
    var out = "\\begin{pmatrix}\n"
    for array in matrix {
        for v in array.dropLast() {
            out += "\(v) & "
        }
        out += "\(array[array.count - 1]) \\\\\n"
    }
    out += "\\end{pmatrix}"
    return out
}
