//
//  PolynomialFields.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 14.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Numeric {
    
    static func x(_ v: Int = 1) -> Polynomial<Self> {
        return Polynomial((Self(integerLiteral: 1), v))
    }
    
    static var x : Polynomial<Self> { return Self.x(1) }
    
}

public func x(_ v: Double = 1) -> _Polynomial {
	return _Polynomial(degree: v)
}
	
public var x : _Polynomial { return x(1) }

