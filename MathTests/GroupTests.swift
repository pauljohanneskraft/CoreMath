//
//  GroupTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class GroupTests: XCTestCase {
	
	func testGroupLikeAbelianGroups() {
		for i in [1,2,3,5,7] {
			let g = GroupLike(set: Z_(i), op: { ($0 + $1) % i }, neutralElement: 0, inv: { i - $0 }, sign: "+")
			let st = g.strictestType!
			XCTAssert(type(of: st) == AbelianGroup<Int>.self)
		}
	}
	
	func testGroupLikeGroups() {
		for i in Z_(20).sorted() {
			let g = GroupLike(set: Z_(i), op: { ($0 + $1) % i }, neutralElement: 0, inv: { i - $0 }, sign: "+")
			let st = g.strictestType
			XCTAssert(st != nil)
			// print(i, "\t", st) // XCTAssert(type(of: st) == AbelianGroup<Int>.self)
		}
	}
	
}
