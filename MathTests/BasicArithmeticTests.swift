//
//  BasicArithmeticTests.swift
//  Math
//
//  Created by Paul Kraft on 25.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation
import Math
import XCTest

class BasicArithmeticTests: XCTestCase {
	
    static var allTests: [(String, (BasicArithmeticTests) -> () throws -> Void )] {
        return [
            ("testAbs", testAbs),
            ("testReducedDescription", testReducedDescription),
            ("testZ_", testZ_)
        ]
    }
    
	func testAbs() {
		for _ in 0..<100 { XCTAssert(Math.random().abs >= 0) }
	}
	
	func testReducedDescription() {
		for _ in 0..<10_000 {
			let a = Double(Int.random)
			XCTAssert(!a.reducedDescription.hasSuffix(".0"), "\(a)")
		}
	}
	
	func testZ_() {
		
		for _ in 0..<20 {
			let a = Math.random() & 0xFF
			let sz = Z_(a)
			let uz = Z_(UInt(a))
			let range = 0..<a
			for _ in 0..<100 {
				let sr = Math.random() & 0xFFF
				let ur = UInt(sr)
				XCTAssert(range.contains(sr) ? sz.contains(sr) : !sz.contains(sr))
				XCTAssert(range.contains(sr) ? uz.contains(ur) : !uz.contains(ur))
			}
		}
		
	}
	
}
