//
//  LinuxCompatibilityTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

#if os(Linux)
#else
	
class LinuxCompatibilityTests: XCTestCase {

	func testLinux() {
		print(DBL_MAX.hashValue)
		print(unsafeBitCast(Double.max, to: Int.self))
		XCTAssert(Double.max == unsafeBitCast(DBL_MAX.hashValue, to: Double.self))
		print(DBL_MIN.hashValue)
		print(unsafeBitCast(Double.min, to: Int.self))
		XCTAssert(Double.min == unsafeBitCast(DBL_MIN.hashValue, to: Double.self))
		// print("-----------------------------------------")
		// for _ in 0..<100 { print(Math.Math.random()) }
	}
	
}

#endif
