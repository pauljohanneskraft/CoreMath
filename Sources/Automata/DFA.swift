//
//  DFA.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct DeterministicFiniteAutomaton<Character: Hashable> {
    
    init?(alphabet: Set<Character>,
          initialState: Int,
          finalStates: Set<Int>,
          states: Set<DeterministicFiniteAutomatonState<Character>>) {
        
        self.alphabet = alphabet
        self.finalStates = finalStates
        self.initialState = initialState
        self.stateLookup = [:]
        for state in states {
            stateLookup[state.id] = state
        }
        guard stateLookup[initialState] != nil else { return nil }
    }
    
    var alphabet: Set<Character>
    let initialState: Int
    
    var states: Set<DeterministicFiniteAutomatonState<Character>> {
        return Set(stateLookup.values)
    }
    
    var finalStates: Set<Int>
    
    var stateLookup: [Int: DeterministicFiniteAutomatonState<Character>]
    
    private var iterator: DeterministicFiniteAutomatonIterator<Character> {
        return DeterministicFiniteAutomatonIterator(automaton: self)
    }
    
    func accepts<S: Sequence>(word: S) -> Bool where S.Iterator.Element == Character {
        var iterator = DeterministicFiniteAutomatonIterator(automaton: self)
        return iterator.accepts(word: word)
    }
}
