//
//  FunctionTests.swift
//  MathTests
//
//  Created by Paul Kraft on 18.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class FunctionTests: XCTestCase {
    func testZeros() {
        let polynomial = PolynomialFunction(Polynomial<Double>([0, 0, 0, 1]))
        print(polynomial)
        guard let zero = polynomial.newtonsMethod(at: 0.3, maxCount: Int.max, tolerance: 0) else {
            XCTAssert(false)
            return
        }
        print("(x: \(zero), y: \(polynomial.call(x: zero)))")
    }
    
    func testSecantMethod() {
        let polynomial = PolynomialFunction(Polynomial<Double>([0, 0, 0, 1]))
        print(polynomial)
        let zero = polynomial.secantMethod(x0: 1, x1: -2, maxIterations: .max, tolerance: 0)
        print("(x: \(zero), y: \(polynomial.call(x: zero)))")
    }
    
    func testBisectionMethod() {
        let polynomial = PolynomialFunction(Polynomial<Double>([0, 0, 0, 1]))
        print(polynomial)
        let zero = polynomial.bisectionMethod(range: -2...1, maxIterations: .max, tolerance: 0)
        XCTAssert(zero.isPoint)
        let zeroMidpoint = Double(Float(zero.midpoint))
        print("(x: \(zeroMidpoint), y: \(polynomial.call(x: zeroMidpoint)))")
    }
    
    func testBisectionMethodFloat() {
        let polynomial = PolynomialFunction(Polynomial<Double>([0, 0, 0, 1]))
        print(polynomial)
        let range = polynomial.bisectionMethod(range: -2...1, maxIterations: .max)
        let zero = polynomial.findZeroUsingFloatAccuracy(range: range)
        print(zero)
    }
    
    func testPolynomialRoots() {
        var polynomial = Polynomial<Double>(1)
        print(polynomial)
        polynomial *= Polynomial<Double>([-0.3, 1])
        print(polynomial)
        polynomial *= Polynomial<Double>([-0.4, 1])
        print(polynomial)
        polynomial *= Polynomial<Double>([-0.5, 1])
        print(polynomial)
        polynomial *= Polynomial<Double>([-0.6, 1])
        print(polynomial)
        polynomial *= Polynomial<Double>([-0.7, 1])
        print(polynomial)
    }
    
    func testPolynomialZeros() {
        let polynomial = (0..<10).reduce(into: Polynomial<Double>(1.0)) { acc, _ in
            let poly = Polynomial([Int.random(inside: -40...40).double, 1])
            acc *= poly
            print(poly)
        }
        print(polynomial, polynomial.zeros)
    }
}
