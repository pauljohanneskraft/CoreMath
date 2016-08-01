//
//  NumericTests.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class NumericTests: XCTestCase, TypeTest {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    typealias Number = Int
    
    var elements: [Number] = []
    
    func testPrettyMuchEquals() {
        var i = 0
        while i < 1e7 {
            let one = Double.random
            let two = nextafter(one, DBL_MAX)
            let eq  = one == two
            let eqn = one =~ two
            if eq != eqn {
                print(i, "\t: Hooray!\t", one.reducedDescription, "\t", two.reducedDescription, "\t", eq, eqn)
            }
            i += 1
            // else { print(one, two) }
        }
    }

}
