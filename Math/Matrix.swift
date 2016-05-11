//
//  Matrix.swift
//  Math
//
//  Created by Paul Kraft on 21.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

//
// ++ used on a matrix with numeric values will increment every single element in the matrix
//
// example:
//
// var left : [[T]] = [[..., ...], ...]
// left++

postfix func ++<T: NumericType>(inout left: [[T]]) -> [[T]] {
    let before = left
    ++left
    return before
}

prefix func ++<T: NumericType>(inout left: [[T]]) -> [[T]] {
    for row in 0..<left.count {
        for column in 0..<left[row].count {
            left[row][column]++
        }
    }
    return left
}

// multiplying matrices can be done using the * operator
// 
// @generic T : NumericType
// @param left : [[T]] - matrix A
// @param right: [[T]] - matrix B
// @result : [[T]] - product of matrix A and matrix B
// @throws MatrixError.NotMultipliable if left[0].count != right.count

func * <T: NumericType>(left: [[T]], right: [[T]]) throws -> [[T]] {
    var left = left
    try left *= right
    return left
}

func *= <T: NumericType>(inout left: [[T]], right: [[T]]) throws -> [[T]] {
    if left[0].count != right.count { throw MatrixError.NotMultipliable }
    var matrix : [[T]] = []
    
    for i in 0..<left.count {
        var array : [T] = []
        for j in 0..<right[0].count {
            var value : T = T(0)
            for k in 0..<right.count {
                value += (left[i][k]*right[k][j])
            }
            array.append(value)
        }
        matrix.append(array)
    }
    left = matrix
    return left
}

func -= <T: NumericType>(inout left: [[T]], right: [[T]]) throws -> [[T]] {
    if left.count != right.count || left[0].count != right[0].count { throw MatrixError.NotAddable }
    for i in 0..<left.count {
        for j in 0..<left[0].count {
            left[i][j] = left[i][j] - right[i][j]
        }
    }
    return left
}

func - <T: NumericType>(left: [[T]], right: [[T]]) throws -> [[T]] {
    var matrix = left
    try matrix -= right
    return matrix
}


func += <T: NumericType>(inout left: [[T]], right: [[T]]) throws -> [[T]] {
    if left.count != right.count || left[0].count != right[0].count { throw MatrixError.NotAddable }
    for i in 0..<left.count {
        for j in 0..<left[0].count {
            left[i][j] = left[i][j] + right[i][j]
        }
    }
    return left
}

func + <T: NumericType>(left: [[T]], right: [[T]]) throws -> [[T]] {
    var matrix = left
    try matrix += right
    return matrix
}

func *= <T: NumericType>(inout left: [[T]], right: T) -> [[T]] {
    for row in 0..<left.count {
        for column in 0..<left[row].count {
            left[row][column] = left[row][column]*right
        }
    }
    return left
}

func * <T: NumericType>(left: [[T]], right: T) -> [[T]] {
    var left = left
    left *= right
    return left
}

func * <T: NumericType>(left: T, right: [[T]]) -> [[T]] {
    var right = right
    right *= left
    return right
}

func /= <T: NumericType>(inout left: [[T]], right: T) -> [[T]] {
    for row in 0..<left.count {
        for column in 0..<left[row].count {
            left[row][column] = left[row][column]/right
        }
    }
    return left
}

func / <T: NumericType>(left: [[T]], right: T) -> [[T]] {
    var left = left
    left /= right
    return left
}

func / <T: NumericType>(left: T, right: [[T]]) -> [[T]] {
    var right = right
    right /= left
    return right
}

func == <T: NumericType>(left: [[T]], right: [[T]]) -> Bool {
    if left.count != right.count || left[0].count != right[0].count { return false }
    var left = left
    for row in 0..<left.count {
        for column in 0..<left[row].count {
            if left[row][column] != right[row][column] {
                return false
            }
        }
    }
    return true
}

func != <T: NumericType>(left: [[T]], right: [[T]]) -> Bool {
    return !(left == right)
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

func print<T>(matrix: [[T]]) {
    print(toLaTeX(matrix))
}


// source: https://wiki.freitagsrunde.org/Javakurs/Übungsaufgaben/Gauß-Algorithmus/Musterloesung
// originally written in Java, rewritten by me in Swift

func solve<T : NumericType>(pmatrix: [[T]], _ pvector: [T]) throws -> [T] {
    if pmatrix.count < pmatrix[0].count { throw MatrixError.Unsolvable }
    var matrix = pmatrix
    var vector = pvector
    var tmpColumn : Int
    for line in 0..<matrix.count {
        tmpColumn = -1
        for column in 0..<matrix[line].count {
            for row in line..<matrix.count {
                if matrix[row][column] != T(0) {
                    tmpColumn = column
                }
            }
            if tmpColumn != -1 { break }
        }
        
        if tmpColumn == -1 {
            for _ in line..<matrix.count {
                if vector[line] != T(0) {
                    //print(matrix)
                    //print(vector)
                    throw MatrixError.Unsolvable
                }
            }
            
            if matrix[0].count - 1 >= line {
                //print(matrix)
                //print(vector)
                throw MatrixError.Unsolvable
            }
            break
        }
        // Umformungsschritt 2: Die Zahl matrix[line][tmpColumn] soll
        // UNgleich null sein
        if matrix[line][tmpColumn] == T(0) {
            for row in line+1..<matrix.count {
                if matrix[row][tmpColumn] != T(0) {
                    //print(matrix, vector)
                    //print("\nRow \(line + 1) will be swapped with row \(row + 1)")
                    matrix.swap(line, row)
                    vector.swap(line, row)
                    break
                }
            }
        }
        
        // Umformungsschritt 3: matrix[line][tmpColumn] soll gleich 1 sein.
        if matrix[line][tmpColumn] != T(0) {
            //print(matrix, vector)
            //print("\nRow \(line + 1) will be divided by \(matrix[line][tmpColumn])")
            divideLine(line, matrix[line][tmpColumn], &matrix, &vector)
        }
        
        //print(matrix, vector)
        
        for row in line+1..<matrix.count {
            //print(matrix, vector)
            //print("\nRow \(row + 1) will be subtracted by: \(matrix[row][tmpColumn]) * row \(line + 1)")
            removeRowLeadingNumber(matrix[row][tmpColumn], line, row, &matrix, &vector)
        }

    }
    
    for column in 1..<matrix[0].count {
        for row in 1...column {
            //print(matrix, vector)
            //print("\nRow \(row) will be subtracted by \(matrix[row - 1][column]) * row \(column + 1)")
            removeRowLeadingNumber(matrix[row - 1][column], column, row - 1, &matrix, &vector);
        }
    }
    
    if !test(pmatrix, vector: pvector, result: vector) {
        throw MatrixError.Unsolvable // throws e.g. when there are no Int-results but there was a [[Int]] as input
    }
    //print(matrix, vector)
    return vector
}

private func removeRowLeadingNumber<T : NumericType>(factor: T, _ rowRoot: Int, _ row: Int, inout _ matrix: [[T]], inout _ vector: [T]) {
    for column in 0..<matrix[row].count {
        matrix[row][column] = matrix[row][column] - factor * matrix[rowRoot][column];
    }
    vector[row] = vector[row] - factor * vector[rowRoot];
}

private func divideLine< T: NumericType>(row : Int, _ div : T, inout _ matrix : [[T]], inout _ vector: [T]){
    for column in 0..<matrix[row].count {
        matrix[row][column] = matrix[row][column] / div;
    }
    vector[row] = vector[row] / div;
}

func toLaTeX<T>(matrix: [[T]], vector: [T], result: [T]) -> String {
    var out = "\\[\n\\left(\n\\begin{matrix}\n"
    for row in matrix {
        // out += : a & b & c & d \\
        for item in row.dropLast() {
            out += "\(item) & "
        }
        out += "\(row.last!) \\\\\n"
    }
    out += "\\end{matrix}\n"
    // end of first part of matrix
    out += "\\right.\\left|\\left.\n"
    // start of vector
    out += "\\begin{matrix}\n"
    for element in vector {
        out += "\(element) \\\\\n"
    }
    out += "\\end{matrix}\n\\right)\\right."
    out += "=\n"
    // in the end the result vector
    out += result.toLaTeXVector()
    out += "\n\\]"
    return out
}


func test<T: NumericType>(matrix: [[T]], vector: [T], result: [T]) -> Bool {
    if vector.count != result.count || vector.count != matrix.count { return false }
    for row in 0..<result.count {
        var value = T(0)
        for column in 0..<matrix[row].count {
            //print("\(matrix[row][column]*result[column]) + ", terminator: "")
            value += matrix[row][column]*result[column]
        }
        //print("=\(vector[row])?")
        if ((value - vector[row])*T(128)).abs() >= T(1) {
            return false
        }
    }
    return true
}

import Foundation

var count = 0

func ^=<T : NumericType>(inout left: [[T]], right: Int) throws -> [[T]] {
    print("calculating matrix ^ \(right)")
    let orig = left
    if right == 0 {
        for i in 0..<left.count {
            for j in 0..<left[i].count {
                left[i][j] = T(1)
            }
        }
    } else if right < 5 {
        for _ in 0..<right {
            try left *= orig
        }
    } else {
        let half = right / 2
        let m = try orig ^ half
        left = try m * m
        if !Bool(right & 0x1) {
            left = try left * orig
        }
    }
    print("calculating matrix ^ \(right) ready.")
    return left
}

func ^<T : NumericType>(left: [[T]], right: Int) throws -> [[T]] {
    var left = left
    try left ^= right
    return left
}

func exp<T:NumericType>(left: [[T]], _ right: Int) throws -> [[T]] {
    return try left ^ right
}

infix operator ^+ { associativity left precedence 140 }
infix operator ^+= { associativity left precedence 140 assignment }

func ^+ <T : NumericType>(left: [[T]], right : UInt) throws -> [[T]] {
    var left = left
    try left ^+= right
    return left
}

func ^+= <T: NumericType>(inout left: [[T]], right: UInt) throws -> [[T]] {
    if right < 2 { return left }
    var matrixToPower = left
    let matrix0 = left
    for _ in 2...right {
        try matrixToPower *= matrix0
        try left += matrixToPower
        // print(i, " mat: ", matrixToPower, " left: ", left)
    }
    return left
}

func %= <T: NumericType>(inout left: [[T]], right: T) -> [[T]] {
    for i in 0..<left.count {
        for j in 0..<left[i].count {
            left[i][j] %= right
        }
    }
    return left
}

func % <T: NumericType>(left: [[T]], right: T) -> [[T]] {
    var left = left
    left %= right
    return left
}

prefix operator § {}

prefix func §<T : NumericType>(lhs: [[T]]) -> [[T]] {
    var res : [[T]] = []
    for j in lhs[0].range {
        var array : [T] = []
        for i in lhs.range {
            array.append(lhs[i][j])
        }
        res.append(array)
    }
    return res
}

prefix operator §! {}

prefix func §!<T : NumericType>(inout lhs: [[T]]) -> [[T]] {
    lhs = §lhs
    return lhs
}













