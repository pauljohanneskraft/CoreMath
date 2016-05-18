//
//  Error.swift
//  Math
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// all errors concerning matrices

enum MatrixError: ErrorProtocol {
    case NotMultipliable, NotAddable, Unsolvable, NoUniqueSolution
}

enum HashTableError<K: Hashable, V>: ErrorProtocol {
    case InList((key: K, value: V)), NotInList(key: K), BadHashFunction
}

enum ArrayError: ErrorProtocol {
    case NotUnique
}

enum NumberError: ErrorProtocol {
    case TooBigForType(String)
}