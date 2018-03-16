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
    func testLinux() {
        print(Double.greatestFiniteMagnitude)
        print(Double.max.bitPattern)
        XCTAssertEqual(.max, Double(bitPattern: UInt64(bitPattern: Int64(0x7FEFFFFFFFFFFFFF))))
        print(Double.leastNormalMagnitude)
        print(Int(bitPattern: UInt(Double.min.bitPattern)))
        XCTAssertEqual(.min, Double(bitPattern: UInt64(bitPattern: Int64(0x10000000000000))))
    }
}
