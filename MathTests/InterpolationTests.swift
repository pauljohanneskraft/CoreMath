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
    static let functions: [Function] = [
        Functions.sin, Functions.cos,
        Constant(0),
        Cosh(x/2),
        Sinh(0.8^x),
        (x^0.4) * Cosh(Sinh(0.5^x)),
        x^5.0, x^10 - 3*(5^x),
        x^0.5, Functions.sin * (x^0.5),
        Ln(x^10), Ln(10^x),
        (x^4).sampled(start: 1, count: 3),
        Fraction(numerator: (2^x), denominator: Constant(3)), 10^x, 3 * (3^x),
        (x^4) * Functions.sin / (6^x)
    ]
    
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
    
    func testNewtonPolynomialInterpolation3() {
        
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
        XCTAssert(df.equals(to: DiscreteFunction(points: (0...5).map { (x: Double($0), y: 1) })))
        let dfi = df.integral
        let fi = discreteFunction.integral
        let dfi2 = fi.derivative
        print(discreteFunction, "'s derivative is", df)
        print(df, "'s integral is", dfi)
        print(discreteFunction, "'s integral is", fi)
        print(fi, "'s derivative is", dfi2)
        XCTAssert(dfi.equals(to: dfi2))
        let dfiReal = DiscreteFunction(points: [(0, 0), (1, 1), (2, 2), (3, 3), (4, 4), (5, 5)])
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
        let dfiReal = DiscreteFunction(points: [(0, 0), (0.5, 1), (1, 2), (1.5, 3), (2, 4), (2.5, 5)])
        XCTAssert(dfi.equals(to: dfiReal))
    }
    
    func testDiscreteFunction3() {
        let discreteFunction = DiscreteFunction(points: [(0, 0), (0.75, 1), (1, 2), (1.5, 3), (2, 4), (2.5, 5), (3, 6)])
        let df = discreteFunction.derivative
        XCTAssertEqual(
            (df as? DiscreteFunction)?.points.map { $0.x } ?? [],
            Array(discreteFunction.points.map { $0.x }.dropLast()))
        XCTAssertEqual(
            (df as? DiscreteFunction)?.points.map { Float($0.y) } ?? [],
            [1.3333333333333333, 4.0, 2.0, 2.0, 2.0, 2.0])
        let dfi = df.integral
        XCTAssertEqual(
            (dfi as? DiscreteFunction)?.points.map { $0.x } ?? [],
            Array(discreteFunction.points.map { $0.x }.dropLast()))
        XCTAssertEqual(
            (dfi as? DiscreteFunction)?.points.map { Float($0.y) } ?? [],
            [0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
        let fi = discreteFunction.integral
        XCTAssertEqual(
            (fi as? DiscreteFunction)?.points.dropLast().map { $0.x } ?? [],
            Array(discreteFunction.points.map { $0.x }.dropLast()))
        XCTAssertEqual(
            (fi as? DiscreteFunction)?.points.map { $0.y } ?? [],
            [0.0, 0.0, 0.25, 1.25, 2.75, 4.75, 7.25])
        let dfi2 = fi.derivative
        XCTAssertEqual(
            (dfi2 as? DiscreteFunction)?.points.map { $0.x } ?? [],
            Array(discreteFunction.points.map { $0.x }.dropLast()))
        XCTAssertEqual(
            (dfi2 as? DiscreteFunction)?.points.map { Float($0.y) } ?? [],
            [0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
        XCTAssert(dfi.equals(to: dfi2))
        print("derivative is", df)
        print("derivative's integral is", dfi)
        print("integral is", fi)
        print("integral's derivative is", dfi2)
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
        for function in InterpolationTests.functions {
            equidistantInterpolation(for: function, using: using)
            nonEquidistantInterpolation(for: function, using: using)
        }
    }
    
    func nonEquidistantInterpolation<I: Interpolation>(for function: Function, using: I.Type) {
        let samples = [0.125, 0.23, 0.246, 0.431, 0.5, 0.628, 0.7, 3, 7]
        let original = function.sampled(at: samples)
        let interpolated = original.interpolate(using: using.self).sampled(at: samples)
        XCTAssertEqual(interpolated.points.map { $0.x },
                       original.points.map { $0.x })
        XCTAssertEqual(interpolated.points.map { Float($0.y) },
                       original.points.map { Float($0.y) },
                       "\(function) \(using)")
    }
    
    func equidistantInterpolation<I: Interpolation>(for function: Function, using: I.Type) {
        let start = 0.125, interval = 0.125, count = 10
        let original = function.sampled(start: start, interval: interval, count: count)
        let interpolated = original
            .interpolate(using: using.self)
            .sampled(start: start, interval: interval, count: count)
        XCTAssertEqual(interpolated.points.map { $0.x }, original.points.map { $0.x })
        let ys = interpolated.points.indices.map { abs(Float(interpolated.points[$0].y - original.points[$0].y)) }
        let error = ys.reduce(0) { $0 + $1 }
        XCTAssertLessThan(error, 1e-13)
    }
    
    func testSampling() {
        for function in InterpolationTests.functions {
            let start = Double.random.remainder(dividingBy: 100).abs
            let end = start + (Double.random.remainder(dividingBy: 100).abs + 10)
            let count = (Int.random % 200).abs + 50
            print("Sampling", function, "from", start, "to", end, "using", count, "points")
            testSampling(for: function, start: start, end: end, count: count)
        }
    }
    
    func testSampling(for function: Function, start: Double, end: Double, count: Int) {
        let interval = (end - start) / Double(count - 1)
        
        let sampled = function.sampled(start: start, end: end, count: count)
        testSamples(samples: sampled.points, start: start, end: end, count: count)
        
        let sampled2 = function.sampled(start: start, interval: interval, count: count)
        testSamples(samples: sampled2.points, start: start, end: end, count: count)
        
        let sampled3 = function.sampled(start: start, interval: interval, end: end)
        testSamples(samples: sampled3.points, start: start, end: end, count: count)
    }
    
    func testSamples(samples: [DiscreteFunction.Point], start: Double, end: Double, count: Int) {
        XCTAssertEqual(samples.count, count)
        XCTAssertEqual(samples.first?.x, start)
        XCTAssertEqual(Float(samples.last?.x ?? Double.greatestFiniteMagnitude), Float(end))
        
        let interval = (end - start) / Double(count - 1)
        
        for i in samples.indices.dropLast() {
            let this = samples[i]
            let next = samples[i + 1]
            XCTAssertEqual(Float(next.x - this.x), Float(interval))
        }
    }
}
