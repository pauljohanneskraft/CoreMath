//
//  LinuxCompatibilityTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class LinuxCompatibilityTests: XCTestCase {    
    static var allTests : [(String, (LinuxCompatibilityTests) -> () throws -> ())] {
        return [("testLinux", testLinux)]
    }
    
    func testLinux() {
        print(DBL_MAX.hashValue)
        print(unsafeBitCast(Double.max, to: Int.self))
        XCTAssert(Double.max == unsafeBitCast( 0x7FEFFFFFFFFFFFFF, to: Double.self))
        print(DBL_MIN.hashValue)
        print(unsafeBitCast(Double.min, to: Int.self))
        XCTAssert(Double.min == unsafeBitCast(   0x10000000000000, to: Double.self))
        // print("-----------------------------------------")
        // for _ in 0..<100 { print(Math.random()) }
    }
}
