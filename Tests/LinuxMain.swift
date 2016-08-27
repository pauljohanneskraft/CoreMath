//
//  LinuxMain.swift
//  Math
//
//  Created by Paul Kraft on 27.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Tests

var tests = [XCTestCaseEntry]()
tests += TermTests.allTests()
tests += RationalNumberTests.allTests()
tests += NumericTests.allTests()
tests += EnhancedNumberTests.allTests()
tests += ConstantsTests.allTests()
tests += ComplexTests.allTests()
tests += BasicArithmeticTests.allTests()
XCTMain(tests)
