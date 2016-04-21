//
//  main.swift
//  Matrizen
//
//  Created by Paul Kraft on 21.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

var matrixA = [[1,2,0], [0, 1, 1]]

var matrixB = [[1,5,0], [0,2,1], [1,4,1]]

var matrixC = [[2,1], [0,0], [1,0], [1,-1]]

var matrixD = [[1], [2], [0], [-1]]

var matrixE = [[1, -1, 0]]

var matrixF = [[3]]

var matrices = [matrixA, matrixB, matrixC, matrixD, matrixE, matrixF]

print("\\documentclass[12pt]{article}\n\\usepackage{amsmath}\n\\begin{document}")

for matrix1 in matrices {
    for matrix2 in matrices {
        let product = matrix1 * matrix2
        if product != nil {
            print("\\[")
            print(matrix1)
            print("\\times")
            print(matrix2)
            print("=")
            print(product!)
            print("\\] \\[ \\]")
        }
    }
}

print("\\end{document}")
