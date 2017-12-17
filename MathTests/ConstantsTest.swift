//
//  ConstantsTest.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class ConstantsTest: XCTestCase {
	func testEverything() {
        let accuracy = 1e-21
		XCTAssert(Constants.pi == .pi)
		XCTAssert(Constants.tau == .pi * 2)
        XCTAssertEqual(Constants.Math.e, .eulersNumber)
        XCTAssertLessThan(abs(0.577_215_664_901_532_860_606_512_090_082_402 - Constants.Math.gamma), accuracy)
        XCTAssert(type(of: Constants.Math.i) == C.self)
        XCTAssertEqual(Constants.Math.i.imaginary, 1)
        XCTAssertEqual(Constants.Math.i.real, 0)
        XCTAssertEqual(Constants.Math.i, C.i)
        XCTAssertEqual((1 + sqrt(5)) / 2, Constants.Math.goldenRatio)
        XCTAssertEqual(Constants.Physics.c, 299_792_458)
        XCTAssertLessThan(abs(1.602_176_620e-19 - Constants.Physics.e), accuracy)
        XCTAssertLessThan(abs(6.671_281_9039e-11 - Constants.Physics.G), accuracy)
        XCTAssertLessThan(abs(6.626_070_04e-34 - Constants.Physics.h), accuracy)
        XCTAssertLessThan(abs(8.854_187_8176e-12 - Constants.Physics.e_0), accuracy)
        XCTAssertLessThan(abs(1.054_571_8001e-34 - Constants.Physics.h_), accuracy)
        XCTAssertLessThan(abs(4e-7 * .pi - Constants.Physics.y_0), accuracy)
        XCTAssertLessThan(abs(9.807_215 - Constants.Physics.g), accuracy)
	}
    
    func testPiUsingCoprimes() {
        
        func gcd(_ num0: Int, _ num1: Int) -> Int {
            var a = num0
            var b = num1
            while a != b {
                if a > b { a -= b } else { b -= a }
            }
            return a
        }
        
        var coprimes = 0
        var cofactor = 0
        
        var count: Int {
            return coprimes + cofactor
        }
        
        var pi: Float = .nan
        
        let inner = 0..<100
        
        let sqrt6 = sqrt(6.0)
        
        defer {
            XCTAssert("\(pi)".starts(with: "3.14"))
            print("done")
        }
        
        while true {
            
            for _ in inner {
                let a = Int.random.abs
                let b = Int.random.abs
                
                if gcd(a, b) > 1 { cofactor += 1 } else { coprimes += 1 }
            }
            pi = Float(sqrt6/sqrt(Double(coprimes)/Double(count)))
            guard !"\(pi)".starts(with: "3.14") else { return }
            
            if coprimes > 500_000 || cofactor > 500_000 {
                cofactor = 0
                coprimes = 0
            }
        }
    }
}
