//
//  Automaton.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

/*
protocol Automaton {
    associatedtype State: AutomatonState
    associatedtype CurrentState
    associatedtype Iterator: AutomatonIterator
    var states:         Set<State>      { get }
    var alphabet:       Set<Character>  { get }
    var initialState:   CurrentState    { get }
    var iterator:       Iterator        { get }
}
*/

/*
    var isInFinalState: Bool { get }
    mutating func transition(symbol: Character) throws
}

extension Automaton {
    mutating func accepts(word: String) -> Bool {
        resetToInitialState()
        do {
            for character in word.characters {
                try transition(symbol: character)
            }
        } catch _ { return false }
        return isInFinalState
    }
}
*/

enum AutomatonError: Error {
    case characterNotInAlphabet
    case faultyState
}
