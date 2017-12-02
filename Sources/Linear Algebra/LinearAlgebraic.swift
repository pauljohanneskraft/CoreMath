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
    var size: Size { get }
    
    subscript(index: Int) -> Row { get }
    
}
