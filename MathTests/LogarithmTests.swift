//
//  LogarithmTests.swift
//  MathTests
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math

class LogarithmTests: XCTestCase {
    let functions = [
        Logarithm(base: 2, content: ConstantFunction(2)),
        Logarithm(base: Constants.Math.e, content: x)
    ]
    
    func testCalculus() {
        functions.forEach { testCalculus(for: $0.reduced) }
    }
    
    func testCalculus(for function: Function) {
        print("f =", function)
        print("f' =", function.derivative)
        print("F =", function.integral)
        print("F' =", function.integral.derivative.debugDescription)
        // print("S(f') =", function.derivative.integral)
    }
}
