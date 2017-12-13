//
//  PlotViewController.swift
//  Math
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa
import CorePlot

class PlotViewController: NSViewController {
    let function: Function
    let range: SamplingRange
    private weak var window: NSWindow!
    
    init(title: String, function: Function, range: SamplingRange, window: NSWindow) {
        self.function = function
        self.window = window
        self.range = range
        super.init(nibName: nil, bundle: nil)
        self.view = PlotView(frame: window.frame)
        viewDidLoad()
        window.title = title
    }
    
    var plotView: PlotView! {
        return view as? PlotView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        plotView.setup(function: function, range: range)
    }
}
