//
//  TeXTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class TeXTests: XCTestCase {
	func testNecessaryTypes() {
		conformsToLaTeXConvertible(
			Int  (1),
			Int8 (1),
			Int16(1),
			Int32(1),
			Int64(1)
			)
	}
	
	func conformsToLaTeXConvertible(_ array: Any...) {
		for type in array {
			XCTAssert(type is LaTeXConvertible, "\(type(of: type)): \(type)")
		}
	}
}
