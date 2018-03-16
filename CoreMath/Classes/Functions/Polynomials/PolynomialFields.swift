//
//  PolynomialFields.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 14.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Numeric {
	
	public static func x(_ v: Int = 1) -> Polynomial<Self> {
		return Polynomial((Self(integerLiteral: 1), v))
	}
	
	public static var x: Polynomial<Self> { return Self.x(1) }
	
}
