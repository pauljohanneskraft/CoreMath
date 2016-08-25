//
//  BasicArithmeticTests.swift
//  Math
//
//  Created by Paul Kraft on 25.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class BasicArithmeticTests: XCTestCase {
	
    func testConformanceToAdvancedNumeric() {
		conformsToAdvancedNumeric(Int   .self)
		conformsToAdvancedNumeric(Int8  .self)
		conformsToAdvancedNumeric(Int16 .self)
		conformsToAdvancedNumeric(Int32 .self)
		conformsToAdvancedNumeric(Int64 .self)
    }
	
	func conformsToAdvancedNumeric<N : AdvancedNumeric>(_ type: N.Type) {
		print(type, "\tconforms to AdvancedNumeric.")
	}

}
