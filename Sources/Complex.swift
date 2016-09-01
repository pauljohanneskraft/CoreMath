//
//  Complex.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 06.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public typealias C = Complex<Double>

// makes it possible to write something like the following:
//
// var myComplex = 2 + 3*i
//

public struct Complex < Number : BasicArithmetic > : BasicArithmetic {
	public var real      : Number
	public var imaginary : Number
	
	public static var i : C { return C(real: 0, imaginary: 1) }
	
	public var conjugate : Complex<Number> {
		return Complex<Number>(real: self.real, imaginary: -(self.imaginary))
	}
	
	public var hashValue: Int {
		if(MemoryLayout<Number>.size == MemoryLayout<Int>.size) {
			return unsafeBitCast(real, to: Int.self) &+ unsafeBitCast(imaginary, to: Int.self)
		} else { return -real.hashValue &+ imaginary.hashValue }
	}
	
	public init(floatLiteral   v: Double) { self.init(Number(floatLiteral:   v)) }
	public init(integerLiteral v: Int)    { self.init(Number(integerLiteral: v)) }
		
	public init(_ v: Number) {
		self.real      = v
		self.imaginary = 0
	}
	
	public init(real: Number, imaginary: Number) {
		self.real      = real
		self.imaginary = imaginary
	}
}

extension Complex where Number : Numeric {
	public var integer: Int {
		precondition(imaginary == 0, "imaginary part != 0")
		return real.integer
	}
	
	public var abs : Complex<Number> {
		return Complex((real*real + imaginary*imaginary).sqrt)
	}
	
	public var double: Double {
		precondition(imaginary == 0, "imaginary part != 0")
		return real.double
	}
	
}

extension Complex where Number : Randomizable {
	public static var random : Complex<Number> {
		return Complex(Number.random)
	}
}

extension Complex where Number : AdvancedNumeric {
	public var sqrt : Complex<Number> {
		var this = self
		if this.imaginary == 0 {
			if real < 0 {
				this.imaginary = (-(this.real)).sqrt
				this.real = 0
			} else { this.real = real.sqrt }
			return this
		} else {
			// source: http://www.mathpropress.com/stan/bibliography/complexSquareRoot.pdf
			let part = abs.real
			let coeff : Number = (1 / Number(integerLiteral: 2).sqrt)
			let sgn : Number = imaginary < 0 ? -1 : 1
			this.real = coeff * (self.real + part).sqrt
			this.imaginary = sgn * coeff * (part - self.real).sqrt
			// print(part, coeff, sgn, self, this)
			return this
		}
	}
}

extension Complex : CustomStringConvertible {
	public var description : String {
		switch (real == 0, imaginary == 0) {
		case (true, true):  return "0"
		case (true, false):
			return imaginary.coefficientDescription(first: true) + "i"
		case (false, true): return real.reducedDescription
		case (false, false):
			return "(\(real.reducedDescription) \(imaginary.coefficientDescription(first: false))i)"
		}
	}
}

extension Complex where Number : Numeric {
	
	public init(polarForm: (coefficient: Double, exponent: Double)) {
		self.real      = Number(polarForm.coefficient * cos(polarForm.exponent))
		if polarForm.exponent == Constants.pi { // sin is too inaccurate
			self.imaginary = 0
		} else {
			self.imaginary = Number(polarForm.coefficient * sin(polarForm.exponent))
		}
	}
	
	public var polarForm : (coefficient: Double, exponent: Double) {
		return (self.abs.real.double, atan2(imaginary.double, real.double))
	}
	
	public func power(_ v: Double) -> Complex<Number> {
		// if d < 0 && v < 1 { return nil }
		var pF = self.polarForm
		pF.coefficient = pF.coefficient.power(v)
		pF.exponent = pF.exponent * v
		// print(pF)
		return Complex(polarForm: pF)
	}
}


public func *= <N : BasicArithmetic>(lhs: inout Complex<N>, rhs: Complex<N>) {
	let l = lhs
	lhs.real = l.real * rhs.real - l.imaginary * rhs.imaginary
	lhs.imaginary = l.real * rhs.imaginary + l.imaginary * rhs.real
	// print(l, "*", rhs, "=", lhs)
}

public func * <N : BasicArithmetic>(lhs: Complex<N>, rhs: Complex<N>) -> Complex<N> {
	var l = lhs
	l *= rhs
	return l
}

public func += <N : BasicArithmetic>(lhs: inout Complex<N>, rhs: Complex<N>) {
	lhs.real += rhs.real
	lhs.imaginary += rhs.imaginary
}

public func + <N : BasicArithmetic>(lhs: Complex<N>, rhs: Complex<N>) -> Complex<N> {
	var l = lhs
	l += rhs
	return l
}

public func -= <N : BasicArithmetic>(lhs: inout Complex<N>, rhs: Complex<N>) {
	lhs.real -= rhs.real
	lhs.imaginary -= rhs.imaginary
}

public func - <N : BasicArithmetic>(lhs: Complex<N>, rhs: Complex<N>) -> Complex<N> {
	var l = lhs
	l -= rhs
	return l
}

public func < <N : BasicArithmetic>(lhs: Complex<N>, rhs: Complex<N>) -> Bool {
	if lhs.real == 0 && rhs.real == 0 { return lhs.imaginary < rhs.imaginary }
	return lhs.real < rhs.real
}

public func == <N : BasicArithmetic>(lhs: Complex<N>, rhs: Complex<N>) -> Bool {
	return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
}

func += < N : BasicArithmetic >(lhs: inout Complex<N>, rhs: N) {
	lhs.real += rhs
}

func + < N : BasicArithmetic >(lhs: Complex<N>, rhs: N) -> Complex<N> {
	var lhs = lhs
	lhs += rhs
	return lhs
}

func + < N : BasicArithmetic >(lhs: N, rhs: Complex<N>) -> Complex<N> {
	var rhs = rhs
	rhs += lhs
	return rhs
}

public func /= <N : BasicArithmetic>(lhs: inout Complex<N>, rhs: Complex<N>) {
	let d = rhs.conjugate
	let num = lhs * d
	let den = rhs * d
	assert(den.imaginary == 0)
	lhs = Complex<N>(real: num.real / den.real, imaginary: num.imaginary / den.real)
}

public func / <N : BasicArithmetic>(lhs: Complex<N>, rhs: Complex<N>) -> Complex<N> {
	var l = lhs
	l /= rhs
	return l
}

prefix public func - < N : BasicArithmetic > (lhs: Complex<N>) -> Complex<N> {
	var lhs = lhs
	lhs.real = -lhs.real
	lhs.imaginary = -lhs.imaginary
	return lhs
}











