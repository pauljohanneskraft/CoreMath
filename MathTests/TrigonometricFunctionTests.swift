//
//  TrigonometricFunctionTests.swift
//  Math
//
//  Created by Paul Kraft on 28.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class TrigonometricFunctionTests: XCTestCase {
	
    static var allTests: [(String, (TrigonometricFunctionTests) -> () throws -> Void )] {
        return [
            ("test1", test1),
            ("testPropertiesSin", testPropertiesSin)
        ]
    }
    
	func testPropertiesSin() {
		let sin = Trigonometric.sin
		let cos = Trigonometric.cos
		XCTAssert(sin.derivative	==  cos		)
		XCTAssert(sin.integral		== -cos		)
		XCTAssert(cos.derivative	== -sin		)
		XCTAssert(cos.integral		==  sin		)
		XCTAssert(sin.description	== "sin(x)"	)
		XCTAssert(cos.description	== "cos(x)"	)
	}

	func test1() {
		let f1 = Trigonometric.sin.integral + Trigonometric.cos.derivative
		print(f1)
		print(f1.call(x: Constants.pi/2))
		XCTAssert(f1.call(x: Constants.pi/2) == -1)
		let f2 = f1 + 1.0
		print(f2.debugDescription)
		print(f2.call(x: Constants.pi/2))
		XCTAssert(f2.call(x: Constants.pi/2) == 0)
	}

}
