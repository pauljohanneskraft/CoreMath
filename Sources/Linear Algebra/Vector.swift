//
//  Vector.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct Vector<Number> {
    var mode: Mode
    var elements: [Number]
}

extension Vector {
    enum Mode {
        case horizontal, vertical
    }
}
