//
//  PlotWindow.swift
//  Math
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa
import CorePlot

private enum PlotWindow {
    static var origin = CGPoint(x: 0, y: (NSScreen.main?.frame.height ?? 0) - size.height)
    static var size = CGSize(width: 480, height: 360)
    static var defaultFrame: CGRect {
        origin.x += 30
        origin.y -= 30
        print("origin:", origin)
        return CGRect(origin: origin, size: size)
    }
}

extension Function {
    func plotWindow(in range: SamplingRange) -> NSWindow {
        return plotWindow(frame: PlotWindow.defaultFrame, in: range)
    }
    
    func plotWindow(frame: CGRect, in range: SamplingRange) -> NSWindow {
        let window = NSWindow()
        window.setFrame(frame, display: true)
        let viewController = PlotViewController(title: description, function: sampled(in: range),
                                                range: range, window: window)
        window.contentViewController = viewController
        window.styleMask = [.resizable, .closable, .titled, .miniaturizable]
        return window
    }
    
    func interpolatingWindow<I: Interpolation>(in range: SamplingRange, using: I.Type) -> NSWindow {
        return interpolatingWindow(frame: PlotWindow.defaultFrame, in: range, using: using)
    }
    
    func interpolatingWindow<I: Interpolation>(frame: CGRect, in range: SamplingRange,
                                               using interpolation: I.Type) -> NSWindow {
        let sampled = self.sampled(in: range).interpolate(using: interpolation)
        let windowRange = SamplingRange(start: range.start, end: range.end, count: range.count * 200)
        let window = sampled.plotWindow(frame: frame, in: windowRange)
        window.title = "\(I.self): \(self)"
        guard let plotView = (window.contentViewController as? PlotViewController)?.plotView else {
            return window
        }
        
        let dataSource = FunctionPlotDataSource(function: self, range: windowRange)
        plotView.add(dataSource: dataSource, lineWidth: 1, color: .blue)
        return window
    }
}
