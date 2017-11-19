//
//  AutomatonState.swift
//  Math
//
//  Created by Paul Kraft on 06.05.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

protocol AutomatonState: Hashable {
    associatedtype Character
    associatedtype TransitionResult
    var id: Int { get }
    var description: String { get }
    var transition: (Character) -> TransitionResult { get }
    init(id: Int, description: String?, transition: @escaping (Character) -> TransitionResult)
}

extension AutomatonState {
    var hashValue: Int { return id }
    
    static func == (a: Self, b: Self) -> Bool {
        return a.id == b.id
    }
}
