//
//  Test.swift
//  Test
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

@testable import Math

extension XCTestCase {
    func measureThrowingBlock<T>(block: () throws -> T) -> T? {
        var a : T?
        measure {
            do { a = try block() }
            catch let e { print("Error: \(e)") }
            // a = nocatch(block)
        }
        return a
    }
}