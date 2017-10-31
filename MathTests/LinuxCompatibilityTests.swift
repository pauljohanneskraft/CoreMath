//
//  LinuxCompatibilityTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class LinuxCompatibilityTests: XCTestCase {
    
    static var allTests : [(String, (LinuxCompatibilityTests) -> () throws -> ())] {
        return [("testLinux", testLinux)]
    }
    
    func testLinux() {
        print(Double.greatestFiniteMagnitude)
        print(Double.max.bitPattern)
        XCTAssert(Double.max == Double(bitPattern: UInt64(bitPattern: Int64(0x7FEFFFFFFFFFFFFF))))
        print(Double.leastNormalMagnitude)
        print(Int(bitPattern: UInt(Double.min.bitPattern)))
        XCTAssert(Double.min == Double(bitPattern: UInt64(bitPattern: Int64(0x10000000000000))))
        // print("-----------------------------------------")
        // for _ in 0..<100 { print(Math.random()) }
    }
    
}
