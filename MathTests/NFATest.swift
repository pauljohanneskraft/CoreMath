//
//  NFATest.swift
//  Math
//
//  Created by Paul Kraft on 07.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
@testable import Math

class NFATest: XCTestCase {
    
    typealias NFA_Bool      = NondeterministicFiniteAutomaton<Bool>
    typealias NFAState_Bool = NondeterministicFiniteAutomatonState<Bool>
    
    func testNFA_Medium() {
        
        let state0 = NFAState_Bool(id: 0) {
            switch $0 {
            case false: return [0, 1]
            case true:  return [0, 2]
            }
        }
        
        let state1 = NFAState_Bool(id: 1) {
            switch $0 {
            case false: return [3]
            case true:  return []
            }
        }
        
        let state2 = NFAState_Bool(id: 2) {
            switch $0 {
            case false: return []
            case true:  return [3]
            }
        }
        
        let state3 = NFAState_Bool(id: 3) {
            switch $0 {
            case false: return [3]
            case true:  return [3]
            }
        }
        
        let automaton = NFA_Bool(alphabet: [true, false], initialStates: [0],
                                 finalStates: [3], states: [state0, state1, state2, state3])!
        
        print(automaton.accepts(word: [true, false, false, true, false]))
    }

    func testNFAVerySimple() {
        
        let state0 = NondeterministicFiniteAutomatonState<Character>(id: 0) {
            switch $0 {
            case "a":   return [0]
            case "b":   return [1]
            default:    return [ ]
            }
        }
        
        let state1 = NondeterministicFiniteAutomatonState<Character>(id: 1) {
            switch $0 {
            case "a":   return [0]
            case "b":   return [1]
            default:    return [ ]
            }
        }
        
        let automaton = NondeterministicFiniteAutomaton(alphabet: ["a", "b"], initialStates: [0],
                                                        finalStates: [1], states: [state0, state1])!
        
        XCTAssert( automaton.accepts(word: "aaaabb"))
        XCTAssert(!automaton.accepts(word: "abbbba"))
        XCTAssert( automaton.accepts(word: "b"))
        XCTAssert(!automaton.accepts(word: "aa"))
        XCTAssert( automaton.accepts(word: "abab"))
    }

}
