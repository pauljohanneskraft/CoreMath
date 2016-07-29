//
//  ConstantsTest.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class ConstantsTest: XCTestCase {
    func testPi() {
        print(constants.pi)
    }
    
    func testTau() {
        assert(constants.tau == constants.pi * 2)
        print(constants.tau)
    }
    
}
