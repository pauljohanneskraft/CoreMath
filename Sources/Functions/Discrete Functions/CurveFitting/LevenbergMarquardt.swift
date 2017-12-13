//
//  LevenbergMarquardt.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct LevenbergMarquardt {
    public var curveFittingFunction: CurveFittingFunction
    public let discreteFunction: DiscreteFunction
    
    let gradientDifference: Double
    let parameterCount: Int
    let pointCount: Int
    let idMatrix: DenseMatrix<Double>
    
    var matrixMatrix: VerticalDenseVector<Double>
    var gradientMatrix: DenseMatrix<Double>
    var evaluatedData: [Double]
    
    public init(curveFittingFunction: CurveFittingFunction, discreteFunction: DiscreteFunction,
                gradientDifference: Double, damping: Double) {
        self.curveFittingFunction = curveFittingFunction
        self.discreteFunction = discreteFunction
        self.gradientDifference = gradientDifference
        self.parameterCount = curveFittingFunction.parameters.count
        self.pointCount = discreteFunction.points.count
        self.idMatrix = DenseMatrix.identity(parameterCount) * (damping * gradientDifference * gradientDifference)
        self.matrixMatrix = VerticalDenseVector<Double>(elements: [Double](repeating: 0, count: pointCount))
        self.gradientMatrix = DenseMatrix(
            [[Double]](repeating: [Double](repeating: 0, count: pointCount), count: parameterCount)
        )
        self.evaluatedData = discreteFunction.points.map { $0.y }
        self.error = Double.max
    }
    
    public var error: Double
    
    mutating func gradientFunction(function: CurveFittingFunction) {
        var function = function
        
        for param in 0..<parameterCount {
            function.parameters[param] += gradientDifference
            for point in 0..<pointCount {
                let discretePoint = discreteFunction.points[point]
                gradientMatrix[param, point] = evaluatedData[point] - function.call(x: discretePoint.x)
            }
        }
    }
    
    mutating func matrixFunction() {
        error = 0.0
        for i in 0..<pointCount {
            let diff = discreteFunction.points[i].y - evaluatedData[i]
            matrixMatrix.elements[i] = diff
            error += abs(diff)
        }
    }
    
    mutating func step() {
        for i in evaluatedData.indices {
            evaluatedData[i] = curveFittingFunction.call(x: discreteFunction.points[i].x)
        }
        gradientFunction(function: curveFittingFunction)
        matrixFunction()
        let inverse = (idMatrix + (gradientMatrix * gradientMatrix.transposed)).inverse
        let pMatrix = DenseMatrix([curveFittingFunction.parameters])
            - (inverse * gradientMatrix * matrixMatrix * gradientDifference).transposed
        curveFittingFunction.parameters = pMatrix[0]
    }
    
    public mutating func execute(maxIterations: Int = 100, errorTolerance: Double = 10e-3) {
        var iteration = 0
        while iteration < maxIterations && error >= errorTolerance {
            step()
            iteration += 1
        }
    }
}
