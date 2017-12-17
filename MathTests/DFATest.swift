//
//  DFATest.swift
//  Math
//
//  Created by Paul Kraft on 07.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class DFATest: XCTestCase {
    
    func testDFASimple() {
        
    }
    
    func testDFAVerySimple() {
        
        let state0 = DFA<Character>.State {
            switch $0 {
            case "a":
                return 0
            case "b":
                return 1
            default:
                return 2
            }
        }
        
        let state1 = DFA<Character>.State {
            switch $0 {
            case "a":
                return 0
            case "b":
                return 1
            default:
                return 2
            }
        }
        
        let state2 = DFA<Character>.State { _ in 2 }
        
        let automaton = DFA(states: [0: state0, 1: state1, 2: state2], initialState: 0, finalStates: [1])
        
        XCTAssertEqual(try? automaton.accepts(word: "aaaabb"), true)
        XCTAssertEqual(try? automaton.accepts(word: "abbbba"), false)
        XCTAssertEqual(try? automaton.accepts(word: "b"), true)
        XCTAssertEqual(try? automaton.accepts(word: "aa"), false)
        XCTAssertEqual(try? automaton.accepts(word: "abab"), true)
        XCTAssertEqual(try? automaton.accepts(word: "ac"), false)
    }
}
