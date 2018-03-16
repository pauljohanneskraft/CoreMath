//
//  NFATest.swift
//  Math
//
//  Created by Paul Kraft on 07.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Math
import XCTest

class NFATest: XCTestCase {
    
    func testNFA_Medium() {
        
        let state0 = NFA<Bool>.State {
            switch $0 {
            case false:
                return [0, 1]
            case true:
                return [0, 2]
            }
        }
        
        let state1 = NFA<Bool>.State {
            switch $0 {
            case false:
                return [3]
            case true:
                return []
            }
        }
        
        let state2 = NFA<Bool>.State {
            switch $0 {
            case false:
                return []
            case true:
                return [3]
            }
        }
        
        let state3 = NFA<Bool>.State {
            switch $0 {
            case false:
                return [3]
            case true:
                return [3]
            }
        }
        
        let automaton = NFA(states: [0: state0, 1: state1, 2: state2, 3: state3], initialStates: [0], finalStates: [3])
        
        XCTAssertEqual(try? automaton.accepts(word: [true, false, false, true, false]), true)
    }
    
    func testNFAVerySimple() {
        
        let state0 = NFA<Character>.State {
            switch $0 {
            case "a":
                return [0]
            case "b":
                return [1]
            default:
                return []
            }
        }
        
        let state1 = NFA<Character>.State {
            switch $0 {
            case "a":
                return [0]
            case "b":
                return [1]
            default:
                return []
            }
        }
        
        let automaton = NFA(states: [0: state0, 1: state1], initialStates: [0], finalStates: [1])
        
        XCTAssertEqual(try? automaton.accepts(word: "aaaabb"), true)
        XCTAssertEqual(try? automaton.accepts(word: "abbbba"), false)
        XCTAssertEqual(try? automaton.accepts(word: "b"), true)
        XCTAssertEqual(try? automaton.accepts(word: "aa"), false)
        XCTAssertEqual(try? automaton.accepts(word: "abab"), true)
    }

}
