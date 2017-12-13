//
//  NFA.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

extension NFA {
    public struct State {
        public init(transition: @escaping (Character) -> Set<Int>) {
            self.transition = transition
        }
        
        var transition: (Character) -> Set<Int>
    }
}

public struct NFA<Character> {
    let initialState: Set<Int>
    let states: [Int: State]
    let finalStates: Set<Int>
    
    public init(states: [Int: State], initialStates: Set<Int>, finalStates: Set<Int>) {
        self.states = states
        self.initialState = initialStates
        self.finalStates = Set(finalStates)
    }
    
    public func accepts<S: Sequence>(word: S) throws -> Bool where S.Iterator.Element == Character {
        var indices = initialState
        var nextIndices = Set<Int>()
        for character in word {
            nextIndices.removeAll()
            for index in indices {
                guard let next = states[index]?.transition(character) else { throw DFAError.statesIncomplete }
                nextIndices.formUnion(next)
            }
            indices = nextIndices
        }
        return !finalStates.isDisjoint(with: indices)
    }
    
    enum DFAError: Error {
        case statesIncomplete
    }
}
