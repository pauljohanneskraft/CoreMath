//
//  CurveFittingTests.swift
//  MathTests
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class CurveFittingTests: XCTestCase {
    
    func testCurveFitting(function: Function,
                          range: SamplingRange = SamplingRange(start: 1, interval: 0.125, count: 20),
                          fitter: CurveFittingFunction, correctParams: [Double]) {
        let sampled = function.sampled(in: range)
        let tolerance = Double(Float.inaccuracy)
        let fitted = sampled.curveFit(using: fitter, maxIterations: 100, gradientDifference: 10e-2,
                                      damping: 1.5, errorTolerance: tolerance)
        guard function.description != fitted.function.description else { print(function); return }
        print("\(function) != \(fitted.function)")
        // XCTAssertLessThanOrEqual(levenbergMarquardt.error, tolerance)
        for index in fitted.parameters.indices {
            let correctParam = correctParams[index]
            let calculatedParam = fitted.parameters[index]
            XCTAssertLessThanOrEqual(abs(Float(correctParam - calculatedParam)), Float(tolerance))
        }
    }
    
    func testCustomExponential() {
        testCustom(correctParameters: [2.3], initialParameters: [4]) { p in
            Exponential(base: p[0])
        }
    }
    
    func testPolynomial() {
        let range = SamplingRange(start: 0, interval: 1, count: 10)
        let function = 0.2 + 0.4*x + 0.6*(x^2) + 0.8*(x^3)
        let fitter = PolynomialCurveFitting(parameters: [1, 2, 3, 4])
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [0.2, 0.4, 0.6, 0.8])
    }
    
    func testSin() {
        let function = 0.2 + 3.456 * Sin(x/2)
        let range = SamplingRange(start: 0, interval: 1, count: 10)
        let fitter = TrigonometricCurveFitting(parameters: [0, 4, 0.8], kind: .sin)
        testCurveFitting(function: function, range: range, fitter: fitter, correctParams: [0.2, 3.456, 0.5])
    }
    
    func testCos() {
        let term = Term(Constant(0.4), TrigonometricFunction(content: Term(Constant(0.5), x), kind: .cos))
        let function = Constant(6.7) + term
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
    
    func testCustom() {
        let range = SamplingRange(start: 1, interval: 0.05, count: 100)
        testCustom(correctParameters: [6.5], initialParameters: [6.7], range: range) { p in Log(p[0], x) }
    }
    
    func testCustom2() {
        let range = SamplingRange(start: 0.1, interval: 0.001, count: 330)
        testCustom(correctParameters: [5, 3], initialParameters: [3.8, 2.9],
                   range: range) { (p: [Double]) -> Function in
            Equation(Logarithm(base: p[0], content: x), _Polynomial(degree: p[1]))
        }
    }
    
    func testCustom3() {
        testCustom(correctParameters: [0.6, 0.35], initialParameters: [1, 0.1]) { p in
            Term(TrigonometricFunction(content: _Polynomial(degree: p[0]), kind: .cos), _Polynomial(degree: p[1]))
        }
    }
    
    func testCustom4() {
        testCustom(correctParameters: [0.6, 0.36], initialParameters: [0.7, 0.5]) { p in
            Term(TrigonometricFunction(content: _Polynomial(degree: p[0]), kind: .sinh), _Polynomial(degree: p[1]))
        }
    }
    
    func testCustom(correctParameters: [Double], initialParameters: [Double],
                    range: SamplingRange = SamplingRange(start: 1, interval: 0.05, count: 38),
                    generator: @escaping ([Double]) -> Function) {
        XCTAssertEqual(correctParameters.count, initialParameters.count)
        let function = generator(correctParameters).reduced
        print(function)
        let samples = function.sampled(in: range)
        let curveFit = samples.customCurveFit(generator: generator, initialValues: initialParameters)
        XCTAssertEqual(correctParameters.map { $0.reducedDescription },
                       curveFit.parameters.map { $0.reducedDescription })
        XCTAssertEqual(function.description, curveFit.function.description)
    }
}
