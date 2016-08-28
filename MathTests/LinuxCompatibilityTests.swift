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

	func test() {
		print(DBL_MAX.hashValue)
		XCTAssert(DBL_MAX == unsafeBitCast(DBL_MAX.hashValue, to: Double.self))
		print(DBL_MIN.hashValue)
		XCTAssert(DBL_MIN == unsafeBitCast(DBL_MIN.hashValue, to: Double.self))
		// print("-----------------------------------------")
		// for _ in 0..<100 { print(Math.random()) }
	}
	
}

#endif
