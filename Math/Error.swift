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

enum HashTableError<K: Hashable, V>: ErrorType {
    case InList((key: K, value: V)), NotInList(key: K), BadHashFunction
}

enum ArrayError: ErrorType {
    case NotUnique
}

enum NumberError: ErrorType {
    case TooBigForType(String)
}