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
    
    func testPrintAll() {
        print(Constants.values)
    }
    
    
    func testPi() {
        print(Constants.pi)
    }
    
    func testTau() {
        assert(Constants.tau == Constants.pi * 2)
        print(Constants.tau)
    }
    
}
