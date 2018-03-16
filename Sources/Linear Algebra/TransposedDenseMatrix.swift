//
//  TransposedDenseMatrix.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct TransposedDenseMatrix<Number: BasicArithmetic>: LinearAlgebraicArithmetic {
    public typealias MultiplicationResult = DenseMatrix<Number>
    public typealias Transposed = DenseMatrix<Number>
    public typealias Row = [Number]
    public typealias TwoDimensionalArray = [[Number]]
    public typealias Size = (rows: Int, columns: Int)
    
    public var transposed: DenseMatrix<Number>
    public var denseMatrix: DenseMatrix<Number> {
        return DenseMatrix(matrix)
    }
    
    public init(_ original: DenseMatrix<Number>) {
        transposed = original
    }
    
    public var matrix: [[Number]] {
        let (rows, columns) = self.size
        let matrix = (0..<columns).map { column in
            (0..<rows).map { row in transposed[row, column] }
        }
        return matrix
    }
    
    public var size: LinearAlgebraic.Size {
        let orig = transposed.size
        return (orig.columns, orig.rows)
    }
    
    public subscript(row: Int) -> Row {
        get {
            return transposed.elements.map { $0[row] }
        }
        set {
            for index in newValue.indices {
                transposed[index, row] = newValue[index]
            }
        }
    }
    
    public subscript(row: Int, column: Int) -> Number {
        get {
            return transposed[column, row]
        }
        set {
            transposed[column, row] = newValue
        }
    }
    
    public static func * <L: LinearAlgebraic>(lhs: TransposedDenseMatrix<Number>, rhs: L)
        -> DenseMatrix<Number> where Number == L.Number {
            assert(lhs.size.columns == rhs.size.rows)
            let ls = lhs.size, lrows = 0..<ls.rows, lcols = 0..<ls.columns
            let rcols = 0..<rhs.size.columns
            
            let elements = lrows.map { i -> Row in
                rcols.map { j -> Number in
                    lcols.reduce(into: 0) { value, k in value += lhs[i, k] * rhs[k, j] }
                }
            }
            
            return DenseMatrix(elements)
    }
    
    public static func *= (lhs: inout TransposedDenseMatrix, rhs: Number) {
        lhs.transposed *= rhs
    }
}

extension TransposedDenseMatrix: All {}

extension TransposedDenseMatrix: CustomStringConvertible {
    public var description: String {
        return transposed.description + "^T"
    }
}
