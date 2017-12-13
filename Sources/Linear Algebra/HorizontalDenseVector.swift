//
//  HorizontalDenseVector.swift
//  Math
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct HorizontalDenseVector<Number> {
    var elements: [Number]
}

extension HorizontalDenseVector: LinearAlgebraic {
    var matrix: [[Number]] {
        return [elements]
    }
    
    var size: Size {
        return (1, elements.count)
    }
    
    subscript(row: Int) -> Row {
        get {
            assert(row == 0)
            return elements
        }
        set {
            assert(row == 0)
            elements = newValue
        }
        
    }
    
    subscript(row: Int, column: Int) -> Number {
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
    var description: String {
        return "[\(elements)]"
    }
}
