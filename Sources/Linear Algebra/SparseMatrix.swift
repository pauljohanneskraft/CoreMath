//
//  SparseMatrix.swift
//  Math
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol EmptyInitializable {
    init()
}

struct SparseMatrix<Number: BasicArithmetic>: LinearAlgebraic {
    typealias Size = (rows: Int, columns: Int)
    typealias TwoDimensionalArray = [[Number]]
    typealias Row = [Number]
    
    var elements = [Int: [Int: Number]]()
    var size: Size
    let defaultValue: Number
    
    init(size: Size, defaultValue: Number) {
        self.size = size
        self.defaultValue = defaultValue
    }
    
    var matrix: TwoDimensionalArray {
        return (0..<size.rows).map { self[$0] }
    }
    
    subscript(row: Int) -> Row {
        get {
            return (0..<size.columns).map { self[row, $0] }
        }
        set {
            for i in newValue.indices {
                guard newValue[i] != defaultValue else { continue }
                if elements[row] == nil { elements[row] = [:] }
                elements[row]?[i] = newValue[i]
            }
        }
    }
    
    subscript(row: Int, column: Int) -> Number {
        get {
            return elements[row]?[column] ?? defaultValue
        }
        set {
            guard newValue != defaultValue else {
                elements[row]?.removeValue(forKey: column)
                return
            }
            if elements[row] == nil { elements[row] = [:] }
            elements[row]?[column] = newValue
        }
    }
            
}

extension SparseMatrix: CustomStringConvertible {
    var description: String {
        return ""
    }
}
/*
struct SparseMatrix<Number: EmptyInitializable>: LinearAlgebraic {
    var elements = [Int: [Int: Number]]()
    var size: Size
    let defaultValue: Number
    
    var matrix: [[Number]] {
        return (0..<size.rows).map { self[$0] }
    }
    
    subscript(row: Int) -> [Number] {
        return (0..<size.columns).map { self[row, $0] }
    }
    
    subscript(row: Int, column: Int) -> Number {
        get {
            return elements[row]?[column] ?? .init()
        }
        set {
            
        }
    }
}



extension SparseMatrix where Number: Equatable {
    init(dense: DenseMatrix<Number>) {
        let defaultValue = Number()
        self.size = dense.size
        let matrix = dense.matrix
        for row in matrix.indices {
            let rowElements = matrix[row]
            for column in rowElements.indices {
                let element = matrix[row][column]
                if element != defaultValue {
                    self[row, column] = element
                }
            }
        }
    }
}
*/
