//
//  LinearAlgebraic.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

protocol LinearAlgebraic: CustomStringConvertible {
    associatedtype Number
    typealias Row = [Number]
    typealias TwoDimensionalArray = [[Number]]
    typealias Size = (rows: Int, columns: Int)
    
    var matrix: TwoDimensionalArray { get }
    // Do not access unless really necessary, because large sparse matrices generate this in O(n^2)
    var size: Size { get }
    
    subscript(row: Int) -> Row? { get set }
    subscript(row: Int, column: Int) -> Number? { get set }
}
