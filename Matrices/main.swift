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

var out = "\\documentclass[12pt]{article}\n\\usepackage{amsmath}\n\\begin{document}\n"

for matrix1 in matrices {
    for matrix2 in matrices {
        out += toLaTeX(matrix1, matrix2)
    }
}

out += "\\end{document}\n"

print(out)

// printing in the end for possible extension of project
// (maybe directly compiling the LaTeX-file and letting the user decide where to store the .pdf-file)

