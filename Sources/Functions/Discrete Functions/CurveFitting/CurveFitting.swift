//
//  CurveFitting.swift
//  Math
//
//  Created by Paul Kraft on 12.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

protocol CurveFittingFunction {
    var parameters: [Double] { get set }
    func call(x: Double) -> Double
    var function: Function { get }
    func call(withoutCoefficients: Double) -> Double
}

extension CurveFittingFunction {
    func call(x: Double) -> Double {
        return (parameters.get(at: 0) ?? 0) + (parameters.get(at: 1) ?? 1) * call(withoutCoefficients: x)
    }
}
