//
//  NFA-Iterator.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct NondeterministicFiniteAutomatonIterator<Character: Hashable> {
    var currentStates: Set<NondeterministicFiniteAutomatonState<Character>>
    var automaton: NondeterministicFiniteAutomaton<Character>
    
    init(automaton: NondeterministicFiniteAutomaton<Character>) {
        self.automaton = automaton
        self.currentStates = Set(automaton.initialStates.map { automaton.stateLookup[$0]! })
    }
    
    mutating func transition(_ character: Character) throws {
        guard automaton.alphabet.contains(character) else { throw AutomatonError.characterNotInAlphabet }
        var nextStates = Set<NondeterministicFiniteAutomatonState<Character>>()
        for state in currentStates {
            for outgoingState in state.transition(character) {
                if let nextState = automaton.stateLookup[outgoingState] {
                    nextStates.insert(nextState)
                }
            }
        }
        print("transitioning from \(currentStates) to \(nextStates)")
        currentStates = nextStates
    }
    
    mutating func accepts<S: Sequence>(word: S) -> Bool where S.Iterator.Element == Character {
        do {
            for character in word {
                try transition(character)
            }
        } catch _ { return false }
        return currentStates.contains(where: { automaton.finalStates.contains($0.id) })
    }
}
