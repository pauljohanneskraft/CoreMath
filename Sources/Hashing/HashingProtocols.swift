//
//  HashingProtocols.swift
//  Math
//
//  Created by Paul Kraft on 22.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation


protocol HashTableType : ArrayLiteralConvertible {
    associatedtype Key : Hashable
    associatedtype Value
    init()
    init(count: Int)
    var count : Int { get }
    var array : [(Key, Value)] { get }
    func insert(element: (Key, Value)) throws
    func insert(elements: (Key, Value)...) throws
    func insert(elements: [(Key, Value)]) throws
    func overwrite(element: (Key, Value)) throws
    func execute(key: Key, block: (Key) throws -> Value) throws -> Value
    func remove(key: Key) throws
    subscript(key: Key) -> Value? { get set }
}