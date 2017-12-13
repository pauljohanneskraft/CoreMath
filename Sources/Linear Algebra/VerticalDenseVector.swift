//
//  VerticalDenseVector.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct VerticalDenseVector<Number> {
    var elements: [Number]
}

extension VerticalDenseVector: LinearAlgebraic {
    var matrix: [[Number]] {
        return elements.map { [$0] }
    }
    
    var size: Size {
        return (elements.count, 1)
    }
    
    subscript(row: Int) -> Row {
        get {
            return [elements[row]]
        }
        set {
            elements[row] = newValue[0]
        }
        
    }
    
    subscript(row: Int, column: Int) -> Number {
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
    var description: String {
        return "\(elements)^T"
    }
}
