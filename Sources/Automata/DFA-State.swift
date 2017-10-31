//
//  DFA-State.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

struct DeterministicFiniteAutomatonState<Character: Hashable>: AutomatonState, CustomStringConvertible {
    var id: Int
    var description: String
    var transition: (Character) -> Int?
    
    init(id: Int,
         description: String? = nil,
         transition: @escaping (Character) -> Int?) {
        self.id = id
        self.description = description ?? "\(id)"
        self.transition = transition
    }
}
