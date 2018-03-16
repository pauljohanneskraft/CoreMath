//
//  CurveFitting.swift
//  Math
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol CurveFittingFunction {
    var parameters: [Double] { get set }
    var function: Function { get }
    
    func call(x: Double) -> Double
    func call(withoutCoefficients: Double) -> Double
}

extension CurveFittingFunction {
    public func call(x: Double) -> Double {
        return (parameters.get(at: 0) ?? 0) + (parameters.get(at: 1) ?? 1) * call(withoutCoefficients: x)
    }
}

extension DiscreteFunction {    
    public func curveFit(using: (CurveFittingFunction & EmptyInitializable).Type, initialParameters: [Double],
                         maxIterations: Int = 100, gradientDifference: Double = 10e-2,
                         damping: Double = 1.5, errorTolerance: Double = 1e-15) -> CurveFittingFunction {
        var cff = using.init()
        cff.parameters = initialParameters
        return curveFit(using: cff, maxIterations: maxIterations, gradientDifference: gradientDifference,
                        damping: damping, errorTolerance: errorTolerance)
    }
    
    public func curveFit(using cff: CurveFittingFunction, maxIterations: Int = 100, gradientDifference: Double = 10e-2,
                         damping: Double = 1.5, errorTolerance: Double = 1e-15) -> CurveFittingFunction {
        var levenbergMarquardt = LevenbergMarquardt(curveFittingFunction: cff, discreteFunction: self,
                                                    gradientDifference: gradientDifference, damping: damping)
        levenbergMarquardt.execute(maxIterations: maxIterations, errorTolerance: errorTolerance)
        return levenbergMarquardt.curveFittingFunction
    }
}
