//
//  CustomPlotView.swift
//  Math
//
//  Created by Paul Kraft on 05.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa
import CorePlot

public class CustomInterpolationPlotView: NSView {
    
    let functionPopUpButton = NSPopUpButton()
    let interpolationPopUpButton = NSPopUpButton()
    let samplingRangeView = SamplingRangeView()
    let plotView = PlotView(frame: .zero)
    
    var functions = [Function]() {
        didSet {
            functionPopUpButton.removeAllItems()
            functionPopUpButton.addItems(withTitles: functions.map { $0.description })
            for item in functionPopUpButton.itemArray {
                item.target = self
                item.action = #selector(update)
            }
        }
    }
    
    var interpolations = [Interpolation.Type]() {
        didSet {
            interpolationPopUpButton.removeAllItems()
            let interpolationTitles = interpolations.map {
                "\($0)".replacingOccurrences(of: "Interpolation", with: "").splitCamelCase()
            }
            interpolationPopUpButton.addItems(withTitles: interpolationTitles)
            for item in interpolationPopUpButton.itemArray {
                item.target = self
                item.action = #selector(update)
            }
        }
    }
    
    var selectedFunction: Function {
        return functions[functionPopUpButton.indexOfSelectedItem]
    }
    
    var selectedInterpolation: Interpolation.Type {
        return interpolations[interpolationPopUpButton.indexOfSelectedItem]
    }
    
    func interpolationRange(of range: SamplingRange) -> SamplingRange {
         return SamplingRange(start: range.start, end: range.end, count: min(range.count * 50, 1_000))
    }
    
    func addDelegates() {
        samplingRangeView.samplingRangeViewDelegate = self
    }
    
    func setup(functions: [Function], interpolations: [Interpolation.Type],
               range: SamplingRange) {
        self.functions = functions
        self.interpolations = interpolations
        self.samplingRangeView.range = range
        setConstraints()
        addDelegates()
        update()
    }
    
    func setConstraints() {
        let innerStackView = NSStackView(orientation: .horizontal, alignment: .bottom, distribution: .fill, subviews: [
            functionPopUpButton, interpolationPopUpButton, samplingRangeView
        ])
        
        innerStackView.heightAnchor.constraint(equalToConstant: 38).isActive = true
        innerStackView.backgroundColor = .clear
        
        let outerStackView = NSStackView(orientation: .vertical, alignment: .height, distribution: .gravityAreas,
                                         subviews: [ innerStackView, plotView ])
        innerStackView.leftAnchor.constraint(equalTo: outerStackView.leftAnchor, constant: 10).isActive = true
        innerStackView.rightAnchor.constraint(equalTo: outerStackView.rightAnchor, constant: -10).isActive = true
        
        outerStackView.backgroundColor = .white
        
        addSubviewWithoutResizingMask(outerStackView)
        
        outerStackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        outerStackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        outerStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        outerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc
    func update() {
        plotView.removeAllPlots()
        guard let range = samplingRangeView.range,
            range.end > range.start, !range.isEmpty, range.count < 1_000
            else { return }
        let interpolationRange = self.interpolationRange(of: range)
        let function = selectedFunction
        plotView.setup(function: function, range: interpolationRange)
        let interpolated = function.sampled(in: range).interpolate(using: selectedInterpolation)
        plotView.add(dataSource: FunctionPlotDataSource(function: interpolated, range: interpolationRange),
                     lineWidth: 3, color: .blue)
        plotView.addDots(dataSource: FunctionPlotDataSource(function: function, range: range), size: 8, color: .white)
    }
}

extension CustomInterpolationPlotView: SamplingRangeViewDelegate {
    func samplingRangeView(_ view: SamplingRangeView, didChange range: SamplingRange?) {
        update()
    }
}

extension CustomInterpolationPlotView: NSTextFieldDelegate {
    public override func controlTextDidEndEditing(_ obj: Notification) {
        update()
    }
}

extension CustomInterpolationPlotView {
    public static func createInterpolatingWindow(
        frame: CGRect, functions: [Function], interpolations: [Interpolation.Type],
        range: SamplingRange) -> NSWindow {
        let window = NSWindow()
        window.setFrame(frame, display: true)
        let viewController = CustomPlotViewController(title: "Plots", functions: functions,
                                                      interpolations: interpolations, range: range, window: window)
        window.contentViewController = viewController
        window.styleMask = [.resizable, .closable, .titled, .miniaturizable]
        return window
    }
}
