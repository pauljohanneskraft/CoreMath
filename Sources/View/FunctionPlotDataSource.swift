//
//  FunctionPlotDataSource.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import CorePlot
import Foundation

class FunctionPlotDataSource: NSObject, CPTPlotDataSource {
    var function: Function
    var range: SamplingRange
    
    init(function: Function, range: SamplingRange) {
        self.function = function
        self.range = range
    }
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(range.count)
    }
    
    func numbers(for plot: CPTPlot, field fieldEnum: UInt, recordIndexRange indexRange: NSRange) -> [Any]? {
        let indexRange = indexRange.lowerBound..<indexRange.upperBound
        
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }
        
        switch field {
        case .X:
            return indexRange.map { range[$0] as NSNumber }
            
        case .Y:
            return indexRange.map { function.call(x: range[$0]) as NSNumber }
        }
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        
        guard let field = CPTScatterPlotField(rawValue: Int(fieldEnum)) else {
            return nil
        }
        
        switch field {
        case .X:
            return range[Int(idx)] as NSNumber
            
        case .Y:
            return function.call(x: range[Int(idx)]) as NSNumber
        }
    }
}
