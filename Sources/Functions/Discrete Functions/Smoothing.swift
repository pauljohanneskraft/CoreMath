//
//  Smoothing.swift
//  Math
//
//  Created by Paul Kraft on 17.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension DiscreteFunction {
    public func smoothed(using range: CountableRange<Int>) -> DiscreteFunction {
        let maxIndex = points.count - 1
        let newPoints = self.points.indices.map { index -> Point in
            let range = max(index + range.lowerBound, 0)...min(index + range.upperBound - 1, maxIndex)
            let y = points[range].reduce(into: 0.0) { (acc: inout Double, point: Point) in acc += point.y }
            return (x: points[index].x, y: y / Double(range.count))
        }
        
        return DiscreteFunction(points: newPoints)
    }
    
    public func smoothed(using range: CountableClosedRange<Int>) -> DiscreteFunction {
        let maxIndex = points.count - 1
        let newPoints = self.points.indices.map { index -> Point in
            let range = max(index + range.lowerBound, 0)...min(index + range.upperBound, maxIndex)
            let y = points[range].reduce(into: 0.0) { (acc: inout Double, point: Point) in acc += point.y }
            return (x: points[index].x, y: y / Double(range.count))
        }
        
        return DiscreteFunction(points: newPoints)
    }
    
    public func smoothed(usingLast count: Int) -> DiscreteFunction {
        return smoothed(using: (-count)...0)
    }
}

extension DiscreteFunction {
    public func smoothWindow(frame: CGRect) -> NSWindow {
        let window = NSWindow()
        window.setFrame(frame, display: true)
        let range = self.range ?? SamplingRange(start: 0, end: 10, count: 10)
        let vc = PlotViewController(title: "Smooth", function: self, range: range, window: window)
        window.styleMask = [.resizable, .closable, .titled, .miniaturizable]
        func generator(p: [Double]) -> Function {
            return _Polynomial(degree: p[2])*p[1] + p[0]
        }
        let initialValues = [0, 1, 0.5]
        
        let smooth = smoothed(using: -10...10)
        let curveFit = customCurveFit(generator: generator, initialValues: initialValues).function
        let smoothCurveFit = smooth.customCurveFit(generator: generator, initialValues: initialValues).function
        
        let newRange = SamplingRange(start: range.start, end: range.end, count: range.count * 20)
        print(curveFit, smoothCurveFit)
        vc.plotView.add(dataSource: FunctionPlotDataSource(function: smoothCurveFit, range: newRange), lineWidth: 3, color: .blue)
        vc.plotView.add(dataSource: FunctionPlotDataSource(function: smooth, range: newRange), lineWidth: 3, color: .green)
        vc.plotView.add(dataSource: FunctionPlotDataSource(function: curveFit, range: newRange), lineWidth: 3, color: .black)
        return window
    }
}
