//
//  InterpolationTests.swift
//  MathTests
//
//  Created by Paul Kraft on 24.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

@testable import Math
import XCTest

class InterpolationTests: XCTestCase {
    func testIsInterpolation<I: Interpolation>(_ i: I.Type) {
        XCTAssert(i == I.self)
        // This test shouldn't really fail, it's more about the compiler errors,
        // when trying to call this with an argument that doesn't conform to Interpolation.
    }
    
    func testProtocol() {
        testIsInterpolation(NearestNeighborInterpolation.self)
        testIsInterpolation(NewtonPolynomialInterpolation.self)
        testIsInterpolation(LinearInterpolation.self)
    }
    
    func testLinearInterpolation() {
        let array = [(x: 0, y: 10), (x: 1.0, y: 15.0)]
        let interpolation = LinearInterpolation(points: array)
        
        XCTAssertEqual(interpolation[3.4], 15.0)
        XCTAssertEqual(interpolation[0.5], 12.5)
        XCTAssertEqual(interpolation[1/3], 10.0 + ( 5/3))
        XCTAssertLessThan((interpolation[2/3] - (10.0 + (10/3))).abs, 1e-12)
    }
    
    func testNearestNeighborInterpolation() {
        let array = [(x: 0, y: 10), (x: 1.0, y: 15.0)]
        let interpolation = NearestNeighborInterpolation(points: array)
        
        XCTAssertEqual(interpolation[0.4], 10)
        XCTAssertEqual(interpolation[0.6], 15)
        XCTAssertEqual(interpolation[-0.5], 10)
        XCTAssertEqual(interpolation[1.1], 15)
        XCTAssertEqual(interpolation[0.5], 15) // prefers y-value of bigger x-value, if distance is equal
        XCTAssertEqual(interpolation[Double.pi / 6], 15)
        XCTAssertEqual(interpolation[Double.pi / 7], 10)
    }
    
    func testNewtonPolynomialInterpolation2() {
        // let array = [(x: 0, y: 10), (x: 1.0, y: 15.0)]
        // let interpolation = NewtonPolynomialInterpolation(points: array)
        
        /*
        XCTAssertEqual(interpolation[0.4], 10)
        XCTAssertEqual(interpolation[0.6], 15)
        XCTAssertEqual(interpolation[-0.5], 10)
        XCTAssertEqual(interpolation[1.1], 15)
        XCTAssertEqual(interpolation[0.5], 15) // prefers y-value of bigger x-value, if distance is equal
        XCTAssertEqual(interpolation[Double.pi / 6], 15)
        XCTAssertEqual(interpolation[Double.pi / 7], 10)
         */
    }
    
    func testInsertSorted() {
        var array = (0..<10).map { $0.double }
        array.insertSorted(0.5)
        array.insertSorted(-0.5)
        array.insertSorted(10.5)
        array.insertSorted(8.75)
        array.insertSorted(9.25)
        array.insertSorted(3.25)
        
        XCTAssertEqual(array, [-0.5, 0.0, 0.5, 1.0, 2.0, 3.0, 3.25, 4.0, 5.0, 6.0, 7.0, 8.0, 8.75, 9.0, 9.25, 10.5])
        print(array)
    }
    
    func testIFFT() {
        let array = (1..<5).map { $0.double }
        let fourier = array.discreteFourierTransform
        let transformed = fourier.fastInverseFourierTransform
        print("dft:", fourier)
        print("dft-idft:", transformed)
        for index in array.indices {
            let error = (C(array[index]) - transformed[index]).abs
            XCTAssertLessThan(error, 9.1e16)
        }
    }
    
    func testFFT() {
        let array = [
            C( 5), C(real: -1, imaginary: -2),
            C(-7), C(real: +3, imaginary: -2)
        ]
        let transformed = array.fastFourierTransform.fastInverseFourierTransform
        for index in array.indices {
            let error = (array[index] - transformed[index]).abs
            XCTAssertLessThan(error, 2.2205e-16)
        }
    }
    
    func testDiscreteFunction() {
        let discreteFunction = DiscreteFunction(points: [(0, 0), (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6)])
        let df = discreteFunction.derivative
        XCTAssert(df.equals(to: DiscreteFunction(points: (1...6).map { (x: Double($0), y: 1) })))
        let dfi = df.integral
        let fi = discreteFunction.integral
        let dfi2 = fi.derivative
        print(discreteFunction, "'s derivative is", df)
        print(df, "'s integral is", dfi)
        print(discreteFunction, "'s integral is", fi)
        print(fi, "'s derivative is", dfi2)
        XCTAssert(dfi.equals(to: dfi2))
        let dfiReal = DiscreteFunction(points: [(1, 0), (2, 1), (3, 2), (4, 3), (5, 4), (6, 5)])
        XCTAssert(dfi.equals(to: dfiReal))
    }
    
    func testDiscreteFunction2() {
        let discreteFunction = DiscreteFunction(points: [(0, 0), (0.5, 1), (1, 2), (1.5, 3), (2, 4), (2.5, 5), (3, 6)])
        let df = discreteFunction.derivative
        let dfi = df.integral
        let fi = discreteFunction.integral
        let dfi2 = fi.derivative
        print(discreteFunction, "'s derivative is", df)
        print(df, "'s integral is", dfi)
        print(discreteFunction, "'s integral is", fi)
        print(fi, "'s derivative is", dfi2)
        XCTAssert(dfi.equals(to: dfi2))
        let dfiReal = DiscreteFunction(points: [(0.5, 0), (1, 1), (1.5, 2), (2, 3), (2.5, 4), (3, 5)])
        XCTAssert(dfi.equals(to: dfiReal))
    }
    
    func testDiscreteFunction3() {
        let discreteFunction = DiscreteFunction(points: [(0, 0), (0.75, 1), (1, 2), (1.5, 3), (2, 4), (2.5, 5), (3, 6)])
        let df = discreteFunction.derivative
        let dfi = df.integral
        let fi = discreteFunction.integral
        let dfi2 = fi.derivative
        print("derivative is", df)
        print("derivative's integral is", dfi)
        print("integral is", fi)
        print("integral's derivative is", dfi2)
        // XCTAssert(dfi.equals(to: dfi2), "\(dfi) != \(dfi2)")
        let dfiReal = DiscreteFunction(points: [(0.75, 0), (1, 1), (1.5, 2), (2, 3), (2.5, 4), (3, 5)])
        // XCTAssert(dfi.equals(to: dfiReal), "\(dfi) != \(dfiReal)")
        print(dfiReal)
    }
    
    func testNewtonPolynomialInterpolation() {
        let function = DiscreteFunction(points: [(-1, -3), (1, 1), (3, -3)])
        let interpolated = function.interpolate(using: NewtonPolynomialInterpolation.self)
        XCTAssertEqual(interpolated.call(x: 0), 0)
    }
    
    func testInterpolation() {
        testInterpolation(using: LinearInterpolation.self)
        testInterpolation(using: CubicSplineInterpolation.self)
        testInterpolation(using: NearestNeighborInterpolation.self)
        testInterpolation(using: NewtonPolynomialInterpolation.self)
    }
    
    func testInterpolation<I: Interpolation>(using: I.Type) {
        testInterpolation(for: Functions.sin, using: I.self)
        testInterpolation(for: Functions.cos, using: I.self)
        testInterpolation(for: Constant(0), using: I.self)
        testInterpolation(for: x^5.0, using: I.self)
        testInterpolation(for: 10^x, using: I.self)
        testInterpolation(for: 3 * (3^x), using: I.self)
        testInterpolation(for: (2^x) / 3, using: I.self)
        testInterpolation(for: (x^4) * Functions.sin / (6^x), using: I.self)
    }
    
    func testInterpolation<I: Interpolation>(for function: Function, using: I.Type) {
        let start = 0.0, interval = 0.125, count = 10
        let original = function.sampled(start: start, interval: interval, count: count)
        let interpolated = original
            .interpolate(using: using.self)
            .sampled(start: start, interval: interval, count: count)
        XCTAssertEqual(interpolated.points.map { $0.x }, original.points.map { $0.x })
        XCTAssertEqual(interpolated.points.map { Float($0.y) }, original.points.map { Float($0.y) })
    }
}
