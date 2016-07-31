//
//  TermTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math

class TermTests: XCTestCase {
    
    func test1() {
        let f1 = Trigonometric.sin.integral + Trigonometric.cos.derivate
        print(f1)
        print(f1.call(x: Constants.pi/4))
    }
    
    func testDoubleAddition() {
        let f1 = Trigonometric.sin.integral + Trigonometric.cos.derivate + 1.0
        print(f1)
        print(f1.call(x: Constants.pi/4))
    }
    
    func testExponentialE() {
        var exp = Exponential(base: Constants.e)
        print(exp * 1.0)
        print(exp.derivate)
        print(exp.integral)
    }
    
    func testEqualitySuperEasy() {
        let one1 = ConstantFunction(value: 1.0)
        let one2 = ConstantFunction(value: 1.0)
        print(one1, one2, one1 == one2)
        
        let two1 = Exponential(base: 2.0)
        let two2 = Exponential(base: 2.0)
        print(two1, two2, two1 == two2)
        
        let three1 = Trigonometric.sin
        let three2 = Trigonometric.cos.derivate
        print(three1, three2, three1 == three2)
    }
    
    func testEqualityEasy() {
        let one1 = Term(ConstantFunction(value: 1.0), ConstantFunction(value: 1.0))
        let one2 = ConstantFunction(value: 1.0)
        print(one1, "=?=", one2, "->", one1.reduced, "=?=", one2.reduced, "=>", one1 == one2)
        
        let two1 = Equation(Exponential(base: 2.0), ConstantFunction(value: 0.0))
        let two2 = Exponential(base: 2.0)
        print(two1, "=?=", two2, "->", two1.reduced, "=?=", two2.reduced, "=>", two1 == two2)
        
        let three1 = Trigonometric.sin + ConstantFunction(value: 0.0)
        let three2 = Trigonometric.cos.derivate
        print(three1, "=?=", three2, "->", three1.reduced, "=?=", three2.reduced, "=>", three1 == three2)
    }
    
    func testIntegralFromTo() {
        let one = PolynomialFunction(Double.x(3))
        print(one, one.integral, one.integral(from: 1, to: -1))
    }
    
    func testPolynomialTerms() {
        let poly1 = Polynomial<Double>((2,3), (4,5), (2.0,4))
        let poly2 = Polynomial<Double>((6,2), (5,1), (2.0,0))
        let poly1f = PolynomialFunction(poly1)
        let poly2f = PolynomialFunction(poly2)
        let t = Term(poly1f, poly2f, Trigonometric.sin)
        print(t, "->", t.reduced)
        print(t.reduced.call(x: 1.345))
        print(t.call(x: 1.345))
    }
}





