//
//  ViewTests.swift
//  MathTests
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math
import Cocoa
import CorePlot

class ViewTests: XCTestCase {
    override func setUp() {
        AppDelegate.start(name: "Math")
    }
    
    override func tearDown() {
        // NSApp?.run()
    }
    
    func testCustomInterpolationPlotWindow() {
        print("halloIchBins".splitCamelCase().lowercased() == "hallo Ich Bins".lowercased())
        let functions = InterpolationTests.functions + [Functions.sin / x, Functions.cos / x]
        let interpolations: [Interpolation.Type] = [
            CubicSplineInterpolation.self, NewtonPolynomialInterpolation.self,
            NearestNeighborInterpolation.self, LinearInterpolation.self
        ]
        let range = SamplingRange(start: -10, end: 10, count: 21)
        let frame = CGRect(origin: .zero, size: CGSize(width: 600, height: 300))
        let window = CustomInterpolationPlotView.createInterpolatingWindow(frame: frame,
                                                              functions: functions, interpolations: interpolations,
                                                              range: range)
        window.minSize = frame.size
        AppDelegate.shared?.open(window: window)
    }
    
    func testInterpolationPlots() {
        let functions = InterpolationTests.functions
        let random = Int.random.abs % functions.count
        print(random, functions[random])
        let function = Functions.sin / x // functions[random]
        testInterpolationPlots(function: function, using: CubicSplineInterpolation.self)
        testInterpolationPlots(function: function, using: NewtonPolynomialInterpolation.self)
        testInterpolationPlots(function: function, using: NearestNeighborInterpolation.self)
        testInterpolationPlots(function: function, using: LinearInterpolation.self)
    }
    
    func testInterpolationPlots<I: Interpolation>(function: Function, using: I.Type) {
        let range = SamplingRange(start: 0.2, end: 10, count: 12)
        testInterpolationPlot(for: function, in: range, using: using)
    }
    
    func testInterpolationPlot<I: Interpolation>(for function: Function, in range: SamplingRange, using: I.Type) {
        let window = function.interpolatingWindow(in: range, using: using)
        AppDelegate.shared?.open(window: window)
    }
    
    func testTransformPlots() {
        let frame = CGRect(origin: .zero, size: CGSize(width: 600, height: 300))
        let range = SamplingRange(start: 0, end: 2*Double.pi, count: 10)
        let window = DiscreteFourierPlotView.createWindow(frame: frame, functions: InterpolationTests.functions,
                                                          range: range)
        AppDelegate.shared?.open(window: window)
    }
}

final class AppDelegate: NSObject, ApplicationDelegate {
    static var shared: AppDelegate?
    var windows = [NSWindow]()
    
    override required init() {
        super.init()
        AppDelegate.shared = self
    }
}
