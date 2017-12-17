//
//  PlotView.swift
//  Math
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa
import CorePlot

class PlotView: CPTGraphHostingView {
    private(set) var graph: CPTGraph = (CPTTheme(named: .plainWhiteTheme)?.newGraph() as? CPTGraph) ?? CPTXYGraph()
    private(set) var plots = [(plot: CPTPlot, dataSource: CPTPlotDataSource)]()
    
    func removeAllPlots() {
        plots.forEach { graph.remove($0.plot) }
        plots.removeAll()
    }
    
    @discardableResult
    func add(dataSource: CPTPlotDataSource, lineWidth: CGFloat = 2, color: NSColor = .red) -> CPTPlot {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor(cgColor: color.cgColor)
        lineStyle.lineWidth = lineWidth
        return add(dataSource: dataSource, lineStyle: lineStyle)
    }
    
    @discardableResult
    func add(dataSource: CPTPlotDataSource, lineStyle: CPTMutableLineStyle?) -> CPTPlot {
        let plot = CPTScatterPlot(frame: .zero)
        plot.dataLineStyle = lineStyle
        add(plot: plot, dataSource: dataSource)
        return plot
    }
    
    private func add(plot: CPTPlot, dataSource: CPTPlotDataSource) {
        plot.dataSource = dataSource
        graph.add(plot)
        plots.append((plot, dataSource))
    }
    
    func addDots(dataSource: CPTPlotDataSource, size: CGFloat = 8, color: NSColor = .white) {
        let plot = CPTScatterPlot(frame: .zero)
        plot.dataLineStyle = nil
        let symbol = CPTPlotSymbol.ellipse()
        symbol.fill = CPTFill(color: CPTColor(cgColor: color.cgColor))
        symbol.size = CGSize(square: size)
        plot.plotSymbol = symbol
        add(plot: plot, dataSource: dataSource)
    }
    
    func remove(plot: CPTPlot) {
        plots = plots.filter { $0.plot != plot }
        graph.remove(plot)
    }
    
    func setupGraphBorders() {
        graph.paddingLeft = 10
        graph.paddingRight = 10
        graph.paddingTop = 10
        graph.paddingBottom = 10
    }
    
    func setupGraphSpaces(function: Function, range: SamplingRange) -> (min: Double, max: Double) {
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            fatalError("\(graph) doesn't have a defaultPlotSpace.")
        }
        plotSpace.allowsUserInteraction = true

        let distance = range.interval * 50
        plotSpace.xRange = CPTPlotRange(
            location: NSNumber(value: range.start - distance),
            length: NSNumber(value: (range.end - range.start) + distance * 2))
        let values = range.map { function.call(x: $0) }.filter { !$0.isNaN && !$0.isInfinite }
        
        let min = values.min() ?? 0
        let max = values.max() ?? 1
        let size = max - min
        plotSpace.yRange = CPTPlotRange(location: NSNumber(value: min - size / 10),
                                        length: NSNumber(value: (max - min) + (size / 5)))
        return (min, max)
    }
    
    func setupGraphAxisSet(range: SamplingRange, min: Double, max: Double) {
        guard let axisSet = graph.axisSet as? CPTXYAxisSet else {
            fatalError("\(graph) doesn't have an axisSet.")
        }
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = NSNumber(value: (range.end - range.start) / 10)
            x.orthogonalPosition    = NSNumber(value: 0)
            x.minorTicksPerInterval = 0
            let lineStyle = CPTMutableLineStyle()
            lineStyle.lineColor = .lightGray()
            lineStyle.lineWidth = 0.5
            x.majorGridLineStyle = lineStyle
            x.labelingPolicy = .automatic
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength   = NSNumber(value: (max - min) / 10)
            y.minorTicksPerInterval = 0
            y.orthogonalPosition    = NSNumber(value: 0)
            let lineStyle = CPTMutableLineStyle()
            lineStyle.lineColor = .lightGray()
            lineStyle.lineWidth = 0.5
            y.majorGridLineStyle = lineStyle
            y.labelingPolicy = .automatic
        }
    }
    
    @discardableResult
    func setup(function: Function, range: SamplingRange) -> CPTPlot {
        print("\(PlotView.self).setup(delegate:)")
        setupGraphBorders()
        let (min, max) = setupGraphSpaces(function: function, range: range)
        setupGraphAxisSet(range: range, min: min, max: max)
        let dataSource = FunctionPlotDataSource(function: function, range: range)
        let plot = add(dataSource: dataSource, lineWidth: 3.5, color: .red)
        hostedGraph = graph
        graph.hostingView = self
        return plot
    }
}
