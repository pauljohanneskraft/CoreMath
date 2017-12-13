//
//  LevenbergMarquardt.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

struct LevenbergMarquardt {
    var curveFittingFunction: CurveFittingFunction
    var discreteFunction: DiscreteFunction
    
    var error: Double {
        return discreteFunction.points.reduce(into: 0) { $0 += abs($1.y - curveFittingFunction.call(x: $1.x)) }
    }
    
    mutating func gradientFunction(evaluatedData: [Double], gradientDifference: Double) -> DenseMatrix<Double> {
        let n = curveFittingFunction.parameters.count
        let m = discreteFunction.points.count
        
        var ans = [[Double]](repeating: [Double](repeating: 0, count: m), count: n)
        
        for param in 0..<n {
            var auxParams = curveFittingFunction.parameters
            auxParams[param] += gradientDifference
            curveFittingFunction.parameters = auxParams
            for point in 0..<m {
                let discretePoint = discreteFunction.points[point]
                ans[param][point] = evaluatedData[point] - curveFittingFunction.call(x: discretePoint.x)
            }
        }
        return DenseMatrix(ans)
    }
    
    func matrixFunction(evaluatedData: [Double]) -> DenseMatrix<Double> {
        let array = discreteFunction.points.indices.map {
            discreteFunction.points[$0].y - evaluatedData[$0]
        }
        return DenseMatrix([array])
    }
    
    mutating func step(damping: Double, gradientDifference: Double) -> [Double] {
        let coefficient = damping * gradientDifference * gradientDifference
        var id = DenseMatrix<Double>.identity(curveFittingFunction.parameters.count)
        id *= coefficient
        
        let function = curveFittingFunction
        let evaluatedData = discreteFunction.points.map { function.call(x: $0.x) }
        
        let gradientFunc = gradientFunction(evaluatedData: evaluatedData, gradientDifference: gradientDifference)
        let matrixF = matrixFunction(evaluatedData: evaluatedData)
        let matrixFunc = matrixF.transposed
        // (id + (gradientFunc * gradientFunc.transposed))
        let inverse = (id + (gradientFunc * gradientFunc.transposed)).inverse
        var paramsMatrix = DenseMatrix([function.parameters])
        paramsMatrix -= (inverse * gradientFunc * matrixFunc * gradientDifference).transposed
        return paramsMatrix[0] ?? []
    }
    
    mutating func execute(maxIterations: Int = 100,
                          gradientDifference: Double = 10e-2,
                          damping: Double = 0,
                          errorTolerance: Double = 10e-3) {
        var iteration = 0
        while iteration < maxIterations && error >= errorTolerance {
            let parameters = step(damping: damping, gradientDifference: gradientDifference)
            curveFittingFunction.parameters = parameters
            iteration += 1
        }
    }
}
