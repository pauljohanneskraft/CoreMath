//
//  VerticalDenseVector.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct VerticalDenseVector<Number: BasicArithmetic>: Vector {
    public typealias Row = [Number]
    public typealias TwoDimensionalArray = [[Number]]
    public typealias Size = (rows: Int, columns: Int)
    
    public var elements: [Number]
}

extension VerticalDenseVector: All {}

extension VerticalDenseVector: LinearAlgebraicArithmetic {
    public typealias MultiplicationResult = DenseMatrix<Number>
    
    public static func += <L: LinearAlgebraic>(lhs: inout VerticalDenseVector, rhs: L) where Number == L.Number {
        precondition(lhs.size == rhs.size)
        for i in 0..<lhs.size.columns { lhs[i, 0] += rhs[i, 0] }
    }
    
    public static func -= <L: LinearAlgebraic>(lhs: inout VerticalDenseVector, rhs: L) where Number == L.Number {
        precondition(lhs.size == rhs.size)
        for i in 0..<lhs.size.columns { lhs[i, 0] -= rhs[i, 0] }
    }
    
    public static func * <L: LinearAlgebraic>(lhs: VerticalDenseVector, rhs: L)
        -> DenseMatrix<Number> where Number == L.Number {
            assert(lhs.size.columns == rhs.size.rows)
            let lrows = 0..<lhs.size.rows
            let rcolumns = 0..<rhs.size.columns
            
            let matrix = lrows.map { i in
                rcolumns.map { j in lhs[i, 0] * rhs[0, j] }
            }
            return DenseMatrix(matrix)
    }
    
    public var transposed: HorizontalDenseVector<Number> {
        return HorizontalDenseVector(elements: elements)
    }
}

extension VerticalDenseVector: LinearAlgebraic {
    public var matrix: [[Number]] {
        return elements.map { [$0] }
    }
    
    public var size: Size {
        return (elements.count, 1)
    }
    
    public subscript(row: Int) -> Row {
        get {
            return [elements[row]]
        }
        set {
            elements[row] = newValue[0]
        }
        
    }
    
    public subscript(row: Int, column: Int) -> Number {
        get {
            assert(column == 0)
            return elements[row]
        }
        set {
            assert(column == 0)
            elements[row] = newValue
        }
    }
}

extension VerticalDenseVector: CustomStringConvertible {
    public var description: String {
        return "\(elements)^T"
    }
}
