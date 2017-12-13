//
//  CurveFittingTests.swift
//  MathTests
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math

class CurveFittingTests: XCTestCase {
    
    func testCurveFitting(function: Function,
                          range: SamplingRange = SamplingRange(start: 1, interval: 0.125, count: 20),
                          fitter: CurveFittingFunction,
                          correctParams: [Double]) {
        let sampled = function.sampled(in: range)
        let tolerance = 1e-15
        var levenbergMarquardt = LevenbergMarquardt(curveFittingFunction: fitter,
                                                    discreteFunction: sampled)
        levenbergMarquardt.execute(maxIterations: 1_000, gradientDifference: 10e-2,
                                   damping: 1.5, errorTolerance: tolerance)
        let fitted = levenbergMarquardt.curveFittingFunction
        guard function.description != fitted.function.description else { return }
        print("\(function) != \(fitted.function)")
        XCTAssertLessThanOrEqual(levenbergMarquardt.error, tolerance)
        for index in fitted.parameters.indices {
            let correctParam = correctParams[index]
            let calculatedParam = fitted.parameters[index]
            XCTAssertLessThanOrEqual(abs(Float(correctParam - calculatedParam)), Float(tolerance))
        }
    }
    
    func testExponential() {
        let function = 2.3^x
        let fitter = ExponentialCurveFitting(parameters: [0, 1, 2])
        let range = SamplingRange(start: -10, interval: 0.25, count: 100)
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [0, 1, 2.3])
    }
    
    func testPolynomial() {
        let range = SamplingRange(start: 0, interval: 1, count: 10)
        let function = 0.2 + 0.4*x + 0.6*(x^2) + 0.8*(x^3)
        let fitter = PolynomialCurveFitting(parameters: [1, 2, 3, 4])
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [0.2, 0.4, 0.6, 0.8])
    }
    
    func testSine() {
        let function = 0.2 + 3.456 * Sin(x/2)
        let range = SamplingRange(start: 0, interval: 1, count: 10)
        let fitter = TrigonometricCurveFitting(parameters: [0, 4, 0.8], kind: .sin)
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [0.2, 3.456, 0.5])
    }
    
    func testCosine() {
        let function = 6.7 + 0.4 * Cos(x/2)
        let range = SamplingRange(start: 0, interval: 1, count: 10)
        let fitter = TrigonometricCurveFitting(parameters: [0, 4, 0.8], kind: .cos)
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [6.7, 0.4, 0.5])
    }
    
    func testCosh() {
        let function = 6.7 + 0.4 * Cosh(0.5*x)
        let range = SamplingRange(start: 0, interval: 1, count: 10)
        let fitter = TrigonometricCurveFitting(parameters: [0, 4, 0.8], kind: .cosh)
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [6.7, 0.4, 0.5])
    }
    
    func testSinh() {
        let function = 6.7 + 0.4 * Sinh(0.5*x)
        let range = SamplingRange(start: 1, interval: 1, count: 10)
        let fitter = TrigonometricCurveFitting(parameters: [0, 4, 0.8], kind: .sinh)
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [6.7, 0.4, 0.5])
    }
    
    func testLogarithm() {
        let function = 6.7 + Log(2, x)
        let range = SamplingRange(start: 1, interval: 1, count: 10)
        let fitter = LogarithmicCurveFitting(parameters: [0, 2.3])
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [6.7, 2])
    }
}
