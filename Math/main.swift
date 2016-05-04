//
//  main.swift
//  Math
//
//  Created by Paul Kraft on 21.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Cocoa

//let matrixA = [[1,2,0], [0, 1, 1]]

//let matrixB = [[1,5,0], [0,2,1], [1,4,1]]

//let matrixC = [[2,1], [0,0], [1,0], [1,-1]]

//let matrixD = [[1], [2], [0], [-1]]

//let matrixE = [[1, -1, 0]]

//let matrixF = [[3]]

let friends : [[Double]] = [[0,0.5,1/2, 0, 0], [1,0,0,0,0], [0,1/3,0,1/3,1/3], [0,0,0,0,1], [0,1/2,1/2, 0, 0]]

let start : Double = NSDate().timeIntervalSince1970

let a = try friends ^ Int.max

let end = Double(NSDate().timeIntervalSince1970)

print(end - start)

//let friends2 : [[Double]] = [[0,1/2,1/2, 0, 0], [1,0,0,0,0], [0,1/3,0,1/3,1/3], [0,0,0,0,1], [0,1/2,1/2, 0, 0] ]

//let b = try friends2 ^^ Int.max - 10

print(a)



//print(try a - b)

//let matrixG = [[1.0]]
/*
let matrices = [matrixA, matrixB, matrixC, matrixD, matrixE, matrixF]

//print("\\documentclass[12pt]{article}\n\\usepackage{amsmath}\n\\begin{document}\n")

for matrix1 in matrices {
    for matrix2 in matrices {
        do {
            let product = try matrix1 * matrix2
            var out = "\\[\n"
            out += toLaTeX(matrix1)
            out += "\\times\n"
            out += toLaTeX(matrix2)
            out += "=\n"
            out += toLaTeX(product)
            out += "\n\\]\n\n\\[ \\]\n\n"
            //print(out)
        } catch _ {}
    }
}

let matrix1 = [[2.0,1,3], [2,6,8], [6,8,18]]

let vector1 = [1.0,3,5]

do {
    //print(toLaTeX(matrix1, vector: vector1, result: try solve(matrix1, vector1)))
    // working
} catch _ {}

/*
 2x +  y +  3z = 1
 2x + 6y +  8z = 3
 6x + 8y + 18z = 5
 */

let matrix2 = [[2,1,3], [2,6,8], [6,8,18]]

let vector2 = [1,3,5]

do {
    //print(toLaTeX(matrix2, vector: vector2, result: try solve(matrix2, vector2)))
    // not working due to fact that there are no Int-results
} catch _ {}

do {
    //print(try matrixA + matrixB)
    // -> example where exception is thrown because matrixA and matrixB are incompatible to be added up
} catch _ {}

//print("\\end{document}")
*/