//
//  BasicArithmetic.swift
//  Math
//
//  Created by Paul Kraft on 03.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol BasicArithmetic : CustomStringConvertible, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Hashable, Comparable {
	init(integerLiteral: Int)
	init(floatLiteral: Double)
	
	var reducedDescription	: String	{ get }
	
	static func + (lhs: Self, rhs: Self) -> Self
	static func - (lhs: Self, rhs: Self) -> Self
	static func * (lhs: Self, rhs: Self) -> Self
	static func / (lhs: Self, rhs: Self) -> Self
	
	static func += (lhs: inout Self, rhs: Self)
	static func -= (lhs: inout Self, rhs: Self)
	static func *= (lhs: inout Self, rhs: Self)
	static func /= (lhs: inout Self, rhs: Self)
	
	prefix static func - (lhs: Self) -> Self
}

public extension BasicArithmetic {
	
	public var abs		: Self { return self < 0 ? -self : self }
	
	public var isZero	: Bool { return abs <= 1e-14 }
	
	public var reducedDescription : String {
		return self.description
	}
	
	internal func coefficientDescription(first: Bool) -> String {
		
		let n : Self
		var res = ""
		if !first { n = self.abs; res += self < 0 ? "- " : "+ " }
		else { n = self }
		
		switch n {
		case 0, 1:  return res
		case -1:    return "-"
		default:    return res + n.reducedDescription
		}
	}
}







