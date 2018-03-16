//
//  HorizontalDenseVector.swift
//  Math
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

public struct HorizontalDenseVector<Number: BasicArithmetic>: Vector {
    public var elements: [Number]
}

extension HorizontalDenseVector: All {}

extension HorizontalDenseVector: LinearAlgebraicArithmetic {
    public typealias MultiplicationResult = HorizontalDenseVector<Number>
    
    public static func * <L: LinearAlgebraic>(lhs: HorizontalDenseVector, rhs: L)
        -> HorizontalDenseVector where Number == L.Number {
            precondition(lhs.size.columns == rhs.size.rows)
            
            let lcols = 0..<lhs.size.columns
            let rcols = 0..<rhs.size.columns
            
            let elements = rcols.map { j -> Number in
                lcols.reduce(into: 0) { value, k in
                    value += lhs[0, k] * rhs[k, j]
                }
            }
            
            return HorizontalDenseVector(elements: elements)
    }
    
    public static func += <L: LinearAlgebraic>(lhs: inout HorizontalDenseVector, rhs: L) where L.Number == Number {
        precondition(lhs.size == rhs.size)
        for i in 0..<lhs.size.columns { lhs[0, i] += rhs[0, i] }
    }
    
    public static func -= <L: LinearAlgebraic>(lhs: inout HorizontalDenseVector, rhs: L) where L.Number == Number {
        precondition(lhs.size == rhs.size)
        for i in 0..<lhs.size.columns { lhs[0, i] -= rhs[0, i] }
    }
    
    public var transposed: VerticalDenseVector<Number> {
        return VerticalDenseVector(elements: elements)
    }
}

extension HorizontalDenseVector: LinearAlgebraic {
    public var matrix: [[Number]] {
        return [elements]
    }
    
    public var size: Size {
        return (1, elements.count)
    }
    
    public subscript(row: Int) -> Row {
        get {
            assert(row == 0)
            return elements
        }
        set {
            assert(row == 0)
            elements = newValue
        }
        
    }
    
    public subscript(row: Int, column: Int) -> Number {
        get {
            assert(row == 0)
            return elements[column]
        }
        set {
            assert(row == 0)
            elements[column] = newValue
        }
    }
}

extension HorizontalDenseVector: CustomStringConvertible {
    public var description: String {
        return "[\(elements)]"
    }
}
