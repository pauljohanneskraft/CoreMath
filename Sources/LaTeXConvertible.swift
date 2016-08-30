//
//  LaTeXConvertible.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 05.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//


public protocol LaTeXConvertible {
	var latex : String { get }
	// func latex(mode: LaTeXMode) -> String
}

extension LaTeXConvertible where Self : CustomStringConvertible {
	public var latex: String { return self.description }
}

enum LaTeXMode { case Math, Standard, Comment }

extension Int    : LaTeXConvertible {}
extension Int8   : LaTeXConvertible {}
extension Int16  : LaTeXConvertible {}
extension Int32  : LaTeXConvertible {}
extension Int64  : LaTeXConvertible {}
extension UInt   : LaTeXConvertible {}
extension UInt8  : LaTeXConvertible {}
extension UInt16 : LaTeXConvertible {}
extension UInt32 : LaTeXConvertible {}
extension UInt64 : LaTeXConvertible {}

extension Float  : LaTeXConvertible {}
extension Float80: LaTeXConvertible {}
extension Double : LaTeXConvertible {}

extension String : LaTeXConvertible {
	public var latex : String { return "\"\(self)\"" }
}

extension Matrix : LaTeXConvertible {
	public var latex : String {
		assert(size.rows > 0 && size.columns > 0)
		var out = "\\begin{pmatrix}\n"
		for array in self.elements.dropLast() {
			for value in array.dropLast() {
				out += "\(value) & "
			}
			out += "\(array.last!) \\\\\n"
		}
		for value in self.elements.last!.dropLast() {
			out += "\(value) & "
		}
		out += "\(self.elements.last!.last!)\n"
		return out + "\\end{pmatrix}"
	}
}

extension RationalNumber : LaTeXConvertible {
	public var latex: String {
		return "\\frac{\(self.numerator)}{\(self.denominator)}"
	}
	
}

extension Complex	: LaTeXConvertible {}
extension Enhanced	: LaTeXConvertible {}













