//
//  TermTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math

class TermTests: XCTestCase {
    func test1() {
        let f1 = Trigonometric.sine + Trigonometric.cosine
        print(f1)
        print(f1.call(x: constants.pi/4))
    }
}
