//
//  NFATest.swift
//  Math
//
//  Created by Paul Kraft on 07.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

// swiftlint:disable force_try

class NFATest: XCTestCase {
    
    func testNFA_Medium() {
        
        let state0 = NFA<Bool>.State {
            switch $0 {
            case false: return [0, 1]
            case true:  return [0, 2]
            }
        }
        
        let state1 = NFA<Bool>.State {
            switch $0 {
            case false: return [3]
            case true:  return []
            }
        }
        
        let state2 = NFA<Bool>.State {
            switch $0 {
            case false: return []
            case true:  return [3]
            }
        }
        
        let state3 = NFA<Bool>.State {
            switch $0 {
            case false: return [3]
            case true:  return [3]
            }
        }
        
        let automaton = NFA(states: [0: state0, 1: state1, 2: state2, 3: state3], initialStates: [0],
                                 finalStates: [3])
        
        print(try! automaton.accepts(word: [true, false, false, true, false]))
    }

    func testNFAVerySimple() {
        
        let state0 = NFA<Character>.State {
            switch $0 {
            case "a":   return [0]
            case "b":   return [1]
            default:    return [ ]
            }
        }
        
        let state1 = NFA<Character>.State {
            switch $0 {
            case "a":   return [0]
            case "b":   return [1]
            default:    return [ ]
            }
        }
        
        let automaton = NFA(states: [0: state0, 1: state1], initialStates: [0], finalStates: [1])
        
        XCTAssert( try! automaton.accepts(word: "aaaabb"))
        XCTAssert(!(try! automaton.accepts(word: "abbbba")))
        XCTAssert( try! automaton.accepts(word: "b"))
        XCTAssert(!(try! automaton.accepts(word: "aa")))
        XCTAssert( try! automaton.accepts(word: "abab"))
    }

}
