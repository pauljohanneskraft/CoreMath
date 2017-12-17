//
//  CustomPlotViewController.swift
//  Math
//
//  Created by Paul Kraft on 06.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

class CustomPlotViewController: NSViewController {
    let functions: [Function]
    let interpolations: [Interpolation.Type]
    let range: SamplingRange
    private weak var window: NSWindow! // swiftlint:disable:this implicitly_unwrapped_optional
    
    init(title: String, functions: [Function], interpolations: [Interpolation.Type],
         range: SamplingRange, window: NSWindow) {
        self.functions = functions
        self.window = window
        self.range = range
        self.interpolations = interpolations
        super.init(nibName: nil, bundle: nil)
        self.view = CustomInterpolationPlotView(frame: window.frame)
        viewDidLoad()
        window.title = title
    }
    
    var customPlotView: CustomInterpolationPlotView! { // swiftlint:disable:this implicitly_unwrapped_optional
        return view as? CustomInterpolationPlotView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customPlotView.setup(functions: functions, interpolations: interpolations, range: range)
    }
}
