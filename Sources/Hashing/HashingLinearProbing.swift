//
//  HashingLinearProbing.swift
//  Math
//
//  Created by Paul Kraft on 22.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation
/*
public struct HashTableLinearProbing<Key : Hashable, Value> : HashTableType {
    public typealias Element = (key: Key, value: Value)
    var table: [Element?]
    init() {}
    public init(arrayLiteral elements: Element...) {
        
    }
    subscript(k: Key) -> Value? {
        get {
            
        }
        set {
            return try execute(key: k) { (tuple) -> Value? in
                return tuple?.value
            }
        }
    }
    public func hash(_ key: Key) -> Int {
        return 0
    }
    public mutating func execute<T>(key: Key, _ block: (tuple: inout Element?) throws -> T) throws -> T {
        var h = hash(key)
        var tuple = table[h]
        var i = 0
        let c = count
        while tuple != nil && i < c {
            if tuple!.key == key { return try block(tuple: &table[h]) }
            h = ((h + 1) % count)
            tuple = table[h]
            i += 1
        }
        return try block(tuple: &tuple)
    }
    var count : Int {return 0} // TODO
}*/
