//
//  DFA-Iterator.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct DeterministicFiniteAutomatonIterator<Character: Hashable> {
    var currentState: DeterministicFiniteAutomatonState<Character>
    var automaton: DeterministicFiniteAutomaton<Character>
    
    init(automaton: DeterministicFiniteAutomaton<Character>) {
        self.automaton = automaton
        self.currentState = automaton.stateLookup[automaton.initialState]!
    }
    
    mutating func transition(_ character: Character) throws {
        guard automaton.alphabet.contains(character) else { throw AutomatonError.characterNotInAlphabet }
        guard let nextStateID = currentState.transition(character),
              let nextState = automaton.stateLookup[nextStateID]
              else { throw AutomatonError.faultyState }
        currentState = nextState
    }
    
    mutating func accepts<S: Sequence>(word: S) -> Bool where S.Iterator.Element == Character {
        self.currentState = automaton.stateLookup[automaton.initialState]!
        do {
            for character in word {
                try transition(character)
            }
        } catch _ { return false }
        return automaton.finalStates.contains(currentState.id)
    }
}
