//
//  LinearAlgebraic.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

public protocol LinearAlgebraic: CustomStringConvertible {
    associatedtype Number: BasicArithmetic
    typealias Row = [Number]
    typealias TwoDimensionalArray = [[Number]]
    typealias Size = (rows: Int, columns: Int)
    
    var matrix: TwoDimensionalArray { get }
    // Do not access unless really necessary, because large sparse matrices generate this in O(n^2)
    var size: Size { get }
    
    subscript(row: Int) -> Row { get set }
    subscript(row: Int, column: Int) -> Number { get set }
}

public protocol LinearAlgebraicArithmetic: LinearAlgebraic {
    associatedtype MultiplicationResult: LinearAlgebraic where MultiplicationResult.Number == Number
    associatedtype Transposed: LinearAlgebraic where Transposed.Number == Number
    
    static func + <L: LinearAlgebraic>(lhs: Self, rhs: L) -> Self where L.Number == Number
    static func - <L: LinearAlgebraic>(lhs: Self, rhs: L) -> Self where L.Number == Number
    static func * <L: LinearAlgebraic>(lhs: Self, rhs: L) -> MultiplicationResult where L.Number == Number
    
    static func += <L: LinearAlgebraic>(lhs: inout Self, rhs: L) where L.Number == Number
    static func -= <L: LinearAlgebraic>(lhs: inout Self, rhs: L) where L.Number == Number
    
    static func * (lhs: Self, rhs: Number) -> Self
    static func * (lhs: Number, rhs: Self) -> Self
    static func *= (lhs: inout Self, rhs: Number)
    
    var transposed: Transposed { get }
}

extension LinearAlgebraicArithmetic where Self: All {
    public static func += <L: LinearAlgebraic>(lhs: inout Self, rhs: L) where Number == L.Number {
        let lsize = lhs.size
        precondition(lsize == rhs.size)
        
        for i in 0..<lsize.rows {
            for j in 0..<lsize.columns {
                lhs[i, j] += rhs[i, j]
            }
        }
    }
    
    public static func -= <L: LinearAlgebraic>(lhs: inout Self, rhs: L) where Number == L.Number {
        let lsize = lhs.size
        precondition(lsize == rhs.size)
        
        for i in 0..<lsize.rows {
            for j in 0..<lsize.columns {
                lhs[i, j] -= rhs[i, j]
            }
        }
    }
    
    public static func *= (lhs: inout Self, rhs: Number) {
        let size = lhs.size
        let rows = 0..<size.rows, columns = 0..<size.columns
        for i in rows {
            for j in columns { lhs[i, j] *= rhs }
        }
    }
    
    public static func + <L: LinearAlgebraic>(lhs: Self, rhs: L) -> Self where L.Number == Number {
        return lhs.copy { $0 += rhs }
    }
    
    public static func - <L: LinearAlgebraic>(lhs: Self, rhs: L) -> Self where L.Number == Number {
        return lhs.copy { $0 -= rhs }
    }
    
    public static func * (lhs: Self, rhs: Number) -> Self {
        return lhs.copy { $0 *= rhs }
    }
    public static func * (lhs: Number, rhs: Self) -> Self {
        return rhs.copy { $0 *= lhs }
    }
}
