//
//  main.swift
//  Matrizen
//
//  Created by Paul Kraft on 21.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

//import Foundation

let matrixA = [[1,2,0], [0, 1, 1]]

let matrixB = [[1,5,0], [0,2,1], [1,4,1]]

let matrixC = [[2,1], [0,0], [1,0], [1,-1]]

let matrixD = [[1], [2], [0], [-1]]

let matrixE = [[1, -1, 0]]

let matrixF = [[3]]

//let matrixG = [[1.0]]

let matrices = [matrixA, matrixB, matrixC, matrixD, matrixE, matrixF]

var out = "\\documentclass[12pt]{article}\n\\usepackage{amsmath}\n\\begin{document}\n"

for matrix1 in matrices {
    for matrix2 in matrices {
        do {
            let product = try matrix1 * matrix2
            out += "\\[\n"
            out += toLaTeX(matrix1)
            out += "\\times\n"
            out += toLaTeX(matrix2)
            out += "=\n"
            out += toLaTeX(product)
            out += "\n\\]\n\n\\[ \\]\n\n"
        } catch _ {}
    }
}

out += "\\end{document}\n"

print(out)

let matrix = [[1.0, 1, 1 ], [ 43, 0, 31 ],  [ 4, 0, 7 ]]

let vector = [2.0, 4, 8]

let result = try solve(matrix, vector)

print(result)

// print(try matrixA + matrixB) -> example where exception is thrown because matrixA and matrixB are incompatible to be added up

// printing in the end for possible extension of project
// (maybe directly compiling the LaTeX-file and letting the user decide where to store the .pdf-file)

