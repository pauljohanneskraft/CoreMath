//
//  CustomFourierPlotViewController.swift
//  Math
//
//  Created by Paul Kraft on 07.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

class DiscreteFourierPlotViewController: NSViewController {
    init(title: String, functions: [Function], range: SamplingRange, window: NSWindow) {
        super.init(nibName: nil, bundle: nil)
        let plotView = DiscreteFourierPlotView(frame: window.frame)
        self.view = plotView
        plotView.setup(functions: functions, range: range)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiscreteFourierPlotView {
    public static func createWindow(frame: CGRect, functions: [Function], range: SamplingRange) -> NSWindow {
        let window = NSWindow()
        window.setFrame(frame, display: true)
        let viewController = DiscreteFourierPlotViewController(title: "Fourier", functions: functions,
                                                               range: range, window: window)
        window.contentViewController = viewController
        window.styleMask = [.resizable, .closable, .titled, .miniaturizable]
        return window
    }
}
