//
//  DFATest.swift
//  Math
//
//  Created by Paul Kraft on 07.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math

class DFATest: XCTestCase {
    
    func testDFASimple() {
        
    }
    
    func testDFAVerySimple() {
        
        let state0 = DeterministicFiniteAutomatonState<Character>(id: 0) {
            switch $0 {
            case "a":   return 0
            case "b":   return 1
            default:    return nil
            }
        }
        
        let state1 = DeterministicFiniteAutomatonState<Character>(id: 1) {
            switch $0 {
            case "a":   return 0
            case "b":   return 1
            default:    return nil
            }
        }
        
        let automaton = DeterministicFiniteAutomaton(alphabet: ["a", "b"],
                                                     initialState: 0, finalStates: [1],
                                                     states: [state0, state1])!
        
        XCTAssert( automaton.accepts(word: "aaaabb"))
        XCTAssert(!automaton.accepts(word: "abbbba"))
        XCTAssert( automaton.accepts(word: "b"))
        XCTAssert(!automaton.accepts(word: "aa"))
        XCTAssert( automaton.accepts(word: "abab"))
        XCTAssert(!automaton.accepts(word: "ac"))
    }
}
