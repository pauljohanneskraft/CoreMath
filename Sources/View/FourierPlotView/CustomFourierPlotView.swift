//
//  CustomFourierPlotView.swift
//  Math
//
//  Created by Paul Kraft on 07.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa
import CorePlot

class DiscreteFourierPlotView: NSView {
    let functionPlotView = PlotView()
    let transformPlotView = PlotView()
    
    let functionPopUpButton = NSPopUpButton()
    let transformationPopUpButton = NSPopUpButton()
    let samplingRangeView = SamplingRangeView()
    
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
    
    var selectedFunction: Function {
        return functions[functionPopUpButton.indexOfSelectedItem]
    }
    
    var transformAbsoluteValues: Bool {
        return transformationPopUpButton.indexOfSelectedItem == 0
    }
    
    func removeAllPlots() {
        functionPlotView.removeAllPlots()
        transformPlotView.removeAllPlots()
    }
    
    func setup(functions: [Function], range: SamplingRange) {
        self.samplingRangeView.range = range
        self.functions = functions
        transformationPopUpButton.removeAllItems()
        transformationPopUpButton.addItems(withTitles: ["Absolute Value", "Angle"])
        for item in transformationPopUpButton.itemArray {
            item.target = self
            item.action = #selector(update)
        }
        samplingRangeView.samplingRangeViewDelegate = self
        setConstraints()
        update()
    }
    
    @objc
    func update() {
        removeAllPlots()
        guard let range = samplingRangeView.range else { return }
        let function = selectedFunction
        functionPlotView.setup(function: function, range: range)
        let functionPoints = function.sampled(in: range).points
        functionPlotView.addDots(dataSource: FunctionPlotDataSource(function: function, range: range))
        let transform = functionPoints.map({ C($0.y) }).fastFourierTransform
        
        let transformedPoints: [DiscreteFunction.Point]
        if transformAbsoluteValues {
            transformedPoints = transform.indices.map {
                (x: functionPoints[$0].x, y: transform[$0].polarForm.coefficient)
            }
        } else {
            transformedPoints = transform.indices.map {
                (x: functionPoints[$0].x, y: transform[$0].polarForm.exponent)
            }
        }
        let transformedFunction = DiscreteFunction(points: transformedPoints)
        let plot = transformPlotView.setup(function: transformedFunction, range: range)
        (plot as? CPTScatterPlot)?.dataLineStyle = nil
        transformPlotView.addDots(dataSource: FunctionPlotDataSource(function: transformedFunction, range: range),
                                  color: .white)
    }
    
    func setConstraints() {
        let topStackView = NSStackView(orientation: .horizontal, alignment: .width, distribution: .fill,
                                       subviews: [ functionPopUpButton, transformationPopUpButton, samplingRangeView ])
        
        topStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topStackView.backgroundColor = .black
        
        let downStackView = NSStackView(orientation: .horizontal, alignment: .width, distribution: .fillEqually,
                                        subviews: [ functionPlotView, transformPlotView ])
        downStackView.backgroundColor = .black
        
        let stackView = NSStackView(orientation: .vertical, alignment: .height, distribution: .fill,
                                    subviews: [ topStackView, downStackView ])
        stackView.backgroundColor = .black
        
        topStackView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10).isActive = true
        topStackView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -10).isActive = true
        
        addSubviewWithoutResizingMask(stackView)
        stackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

extension DiscreteFourierPlotView: SamplingRangeViewDelegate {
    func samplingRangeView(_ view: SamplingRangeView, didChange range: SamplingRange?) {
        update()
    }
}

extension DiscreteFunction {
    var range: SamplingRange? {
        guard points.count > 1 else { return nil }
        let interval = points[1].x - points[0].x
        return SamplingRange(start: points[0].x, interval: interval, count: points.count - 1)
    }
}
