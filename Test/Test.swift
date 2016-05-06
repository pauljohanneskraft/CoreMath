//
//  Test.swift
//  Math
//
//  Created by Paul Kraft on 06.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

extension XCTestCase {
    func measureThrowingBlock(block: () throws -> Void) {
        measureBlock {
            do {
                try block()
            } catch let e {
                print("did throw", e)
            }
        }
    }
}
