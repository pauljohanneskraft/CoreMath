//
//  DFATest.swift
//  Math
//
//  Created by Paul Kraft on 07.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

// swiftlint:disable force_try

class DFATest: XCTestCase {
    
    func testDFASimple() {
        
    }
    
    func testDFAVerySimple() {
        
        let state0 = DFA<Character>.State {
            switch $0 {
            case "a":   return 0
            case "b":   return 1
            default:    return 2
            }
        }
        
        let state1 = DFA<Character>.State {
            switch $0 {
            case "a":   return 0
            case "b":   return 1
            default:    return 2
            }
        }
        
        let state2 = DFA<Character>.State { _ in 2 }
        
        let automaton = DFA(states: [0: state0, 1: state1, 2: state2], initialState: 0, finalStates: [1])
        
        XCTAssert( try! automaton.accepts(word: "aaaabb"))
        XCTAssert(!(try! automaton.accepts(word: "abbbba")))
        XCTAssert( try! automaton.accepts(word: "b"))
        XCTAssert(!(try! automaton.accepts(word: "aa")))
        XCTAssert( try! automaton.accepts(word: "abab"))
        XCTAssert(!(try! automaton.accepts(word: "ac")))
    }
}
