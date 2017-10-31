//
//  NFA.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct NondeterministicFiniteAutomaton<Character: Hashable> {
    var stateLookup: [Int:NondeterministicFiniteAutomatonState<Character>]
    var states: Set<NondeterministicFiniteAutomatonState<Character>> {
        return Set(stateLookup.values)
    }
    var alphabet:       Set<Character>
    var initialStates:  Set<Int>
    var finalStates:    Set<Int>

    init?(alphabet: Set<Character>,
          initialStates: Set<Int>,
          finalStates: Set<Int>,
          states: Set<NondeterministicFiniteAutomatonState<Character>>) {
        
        self.alphabet = alphabet
        self.finalStates = finalStates
        self.initialStates = initialStates
        self.stateLookup = [:]
        for state in states {
            stateLookup[state.id] = state
        }
        for state in initialStates {
            guard stateLookup[state] != nil else { return nil }
        }
    }
    
    func accepts<S: Sequence>(word: S) -> Bool where S.Iterator.Element == Character {
        var iterator = NondeterministicFiniteAutomatonIterator(automaton: self)
        return iterator.accepts(word: word)
    }
    
    func generateDFA() -> DeterministicFiniteAutomaton<Character> {
        var newStates = [Int:DeterministicFiniteAutomatonState<Character>]()
        
        let currentStates = self.initialStates.map { self.stateLookup[$0]! }
        var nextStates = Set<NondeterministicFiniteAutomatonState<Character>>()
        var id = 0
        
        while currentStates.contains(where: { !self.finalStates.contains($0.id) }) {
            for character in self.alphabet {
                for state in currentStates {
                    let n = state.transition(character).map({ self.stateLookup[$0] }).flatMap({ $0 })
                    nextStates.formUnion(n)
                }
            }
            id += 1
        }
        
        
        for state in self.states {
            
        }
    }
}
