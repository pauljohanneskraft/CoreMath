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
    
    func testInt() {
        let min = Int(Int32.min) << 32
        let max = Int(UInt32.max) << 32
        let range = ClosedRange(min...max)
        print(range)
        for _ in 0..<1_000_000_000 {
            let number = Int.random(inside: range)
            XCTAssert(range.contains(number), "Range \(range) doesn't contain \(number).")
            if !(Int.min...Int.max).contains(number) {
                print(number)
            }
        }
    }
    
    func testInt32() {
        let min = Int32(Int16.random())
        let max = min + Int32(Int16.random()).abs
        let range = ClosedRange(min...max)
        print(min...max)
        let bigRange = ClosedRange(Int32.min...(-1)) // (Int32.max - Int32(Int16.max)))
        print(bigRange)
        let upperRange = ClosedRange(bigRange.upperBound...Int32.max)
        print(upperRange)
        for _ in 0..<(Int32.max >> 12) {
            let random32 = Int32.random(inside: bigRange)
            if upperRange.contains(random32) {
                print("found one")
            }
            XCTAssert(bigRange.contains(random32), "\(bigRange) doesn't contain \(random32)")

            let number = Int32.random(inside: range)
            XCTAssert(range.contains(number), "\(range) doesn't contain \(number)")
        }
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
                let a = Int.random(inside: Int32.min.integer...Int32.max.integer).abs
                let b = Int.random(inside: Int32.min.integer...Int32.max.integer).abs
                
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
