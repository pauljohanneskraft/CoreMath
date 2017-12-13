//
//  LogarithmTests.swift
//  MathTests
//
//  Created by Paul Kraft on 04.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class LogarithmTests: XCTestCase {
    let functions = [
        Log(2, ConstantFunction(2)),
        Ln(x)
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
