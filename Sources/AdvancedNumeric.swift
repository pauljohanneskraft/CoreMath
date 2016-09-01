//
//  AdvancedNumeric.swift
//  Math
//
//  Created by Paul Kraft on 03.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol AdvancedNumeric : Numeric, Ordered {
	static func % (lhs: Self, rhs: Self) -> Self
	static func %= (lhs: inout Self, rhs: Self)
}

public extension AdvancedNumeric {
	func mod(_ v: Int) -> Self {
		let m = self % Self(integerLiteral: v)
		if m < 0 { return m + Self(integerLiteral: v) }
		return m
	}
}
