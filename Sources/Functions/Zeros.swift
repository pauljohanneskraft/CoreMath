//
//  Zeros.swift
//  Math
//
//  Created by Paul Kraft on 18.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Double {
    public static var floatLeastNonzeroMagnitude: Double {
        return Double(Float.leastNonzeroMagnitude)
    }
}

extension Function {
    
    public func newtonsMethod(at x: Double, maxCount: Int = 1_000,
                              tolerance: Double = .floatLeastNonzeroMagnitude) -> Double? {
        let derivative = self.derivative
        var x = x
        
        for _ in 0..<maxCount {
            let y = call(x: x)
            guard abs(y) > tolerance else { return x }
            let dy = derivative.call(x: x)
            x -= y / dy
        }
        
        return nil
    }
    
    /*
    public func roots(in range: SamplingRange, alreadyFound: Set<Double> = [])
     -> (roots: Set<Double>, result: Function) {
        print("checking for roots", self)
        guard !(self is Constant) else { return ([], self) }
        var zeros = Set<Double>()
        var function: Function = self
        range.forEach { x in
            guard let root = Double(guessZero(at: x).reducedDescription),
                root.isReal, !alreadyFound.contains(root)
                else { return }
            zeros.insert(findZeroUsingFloatAccuracy(at: root))
            function = function / PolynomialFunction(Polynomial([-root, 1]))
            let functionZeros = function.roots(in: range, alreadyFound: alreadyFound)
            zeros.formUnion(functionZeros.roots)
            function = functionZeros.result
        }
        
        print("found", zeros)
        
        return (zeros, function)
    }
    */
    
    public func secantMethod(x0: Double, x1: Double, maxIterations: Int = 1_000,
                             tolerance: Double = .floatLeastNonzeroMagnitude) -> Double {
        var x0 = x0, x1 = x1, y0 = call(x: x0)
        
        for _ in 0..<maxIterations {
            let y1 = call(x: x1)
            guard y1.isReal else { return x0 }
            guard abs(y1) > tolerance else { return x1 }
            let prevX1 = x1
            x1 -= y1 * (x1 - x0) / (y1 - y0)
            x0 = prevX1
            y0 = y1
        }
        return x1
    }
    
    public func bisectionMethod(range: ClosedRange<Double>, maxIterations: Int = 10_000,
                                tolerance: Double = .floatLeastNonzeroMagnitude) -> ClosedRange<Double> {
        guard maxIterations > 1, range.length > tolerance else { return range }
        let midpoint = range.midpoint
        let y = call(x: midpoint)
        guard abs(y) != 0 else { return midpoint...midpoint }
        let isEqual = (range.lowerBound.sign == y.sign)
        return bisectionMethod(range: isEqual ? midpoint...range.upperBound : range.lowerBound...midpoint,
                               maxIterations: maxIterations - 1, tolerance: tolerance)
    }
    
    public func findZeroUsingFloatAccuracy(at doubleX: Double) -> Double {
        let floatX = Double(Float(doubleX))
        let floatY = abs(call(x: floatX))
        let doubleY = abs(call(x: doubleX))
        return doubleY < floatY ? doubleX : floatX
    }
    
    public func findZeroUsingFloatAccuracy(range: ClosedRange<Double>) -> Double {
        let newRange = Float(range.lowerBound)...Float(range.upperBound)
        guard !newRange.isPoint else {
            return findZeroUsingFloatAccuracy(at: range.midpoint)
        }
        let a = Double(newRange.lowerBound), ay = abs(call(x: a))
        let b = Double(newRange.midpoint  ), by = abs(call(x: b))
        let c = Double(newRange.upperBound), cy = abs(call(x: c))
        if ay < by {
            return ay < cy ? a : c
        } else {
            return by < cy ? b : c
        }
    }
}

extension ClosedRange where Bound: FixedWidthInteger {
    public var midpoint: Bound {
        let (value, overflow) = upperBound.addingReportingOverflow(lowerBound)
        guard overflow else { return value }
        let rest = (upperBound & 1) + (lowerBound & 1)
        return (upperBound >> 1) + (lowerBound >> 1) + (rest >> 1)
    }
    
    public var length: Bound {
        let sub = upperBound.subtractingReportingOverflow(lowerBound)
        return sub.overflow ? Bound.max : sub.partialValue
    }
    
    public var isPoint: Bool {
        return upperBound == lowerBound
    }
}

extension ClosedRange where Bound: FloatingPoint {
    public var midpoint: Bound {
        return (upperBound + lowerBound) / 2
    }
    
    public var length: Bound {
        return upperBound - lowerBound
    }
    
    public var isPoint: Bool {
        return upperBound == lowerBound
    }
}
