//
//  Error.swift
//  Math
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// all errors concerning matrices

enum MatrixError: ErrorType {
    case NotMultipliable, NotAddable, Unsolvable
}

enum HashListError: ErrorType {
    case AlreadyInList
}