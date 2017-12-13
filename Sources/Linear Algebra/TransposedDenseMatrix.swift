//
//  TransposedDenseMatrix.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct TransposedDenseMatrix<Number>: LinearAlgebraic {
    typealias Row = [Number]
    typealias TwoDimensionalArray = [[Number]]
    typealias Size = (rows: Int, columns: Int)
    
    var original: DenseMatrix<Number>
    
    var matrix: [[Number]] {
        let (rows, columns) = self.size
        let matrix = (0..<columns).map { column in
            (0..<rows).map { row in original[row, column] }
        }
        return matrix
    }
    
    var size: LinearAlgebraic.Size {
        let orig = original.size
        return (orig.columns, orig.rows)
    }
    
    subscript(row: Int) -> Row {
        get {
            return original.elements.map { $0[row] }
        }
        set {
            for index in newValue.indices {
                original[index, row] = newValue[index]
            }
        }
    }
    
    subscript(row: Int, column: Int) -> Number {
        get {
            return original[column, row]
        }
        set {
            original[column, row] = newValue
        }
    }
}

extension TransposedDenseMatrix: CustomStringConvertible {
    var description: String {
        return original.description + "^T"
    }
}
