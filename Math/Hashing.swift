//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct HashTable <K: NumericType, V> : CustomStringConvertible {
    
    private(set) var table  : [[(key: K, value: V)]]
    private(set) var hash   : K -> Int
    
    init(_ count : Int) { // convenience init
        self.init(_: count, hash: { return Int($0 % K(count)) })
    }
    
    init(_ count : Int, hash: K -> Int) {
        table = [[(key: K, value: V)]](count: count, repeatedValue: [])
        self.hash = hash
    }
    
    mutating func insert(key key: K, value: V) throws {
        try insert(element: (key, value))
    }
    
    mutating func insert(element new: (key: K, value: V)) throws {
        let h = hash(new.key)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        for v in table[h].range {
            if new.key == table[h][v].key {
                throw HashTableError.InList
            }
        }
        table[h].append(new)
    }
    
    mutating func find(key key: K) throws -> (key: K, value: V) {
        let h = hash(key)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        for v in table[h].range {
            if key == table[h][v].key {
                return table[h][v]
            }
        }
        throw HashTableError.NotInList
    }
    
    mutating func remove(key key: K) throws -> (key: K, value: V) {
        let h = hash(key)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        for v in table[h].range {
            if key == table[h][v].key {
                return table[h].removeAtIndex(v)
            }
        }
        throw HashTableError.NotInList
    }
    
    mutating func setHash(newHash: K -> Int) throws {
        let oldHash = self.hash
        let oldTable = self.table
        do {
            self.hash = newHash
            self.table = [[(key: K, value: V)]](count: oldTable.count, repeatedValue: [])
            for bucket in oldTable {
                for element in bucket {
                    try insert(element: element)
                }
            }
        } catch _ {
            self.hash = oldHash
            self.table = oldTable
            throw HashTableError.BadHashFunction
        }
    }
    
    var description: String {
        return String(table)
    }
    
}


struct HashTableNoChaining <K : NumericType, V> : CustomStringConvertible {
    
    private(set) var table  : [(key: K, value: V)?]
    private(set) var hash   : K -> Int
    
    init(_ count : Int) { // convenience init
        self.init(_: count, hash: { return Int($0 % K(count)) })
    }
    
    init(_ count : Int, hash: K -> Int) {
        table = [(key: K, value: V)?](count: count, repeatedValue: nil)
        self.hash = hash
    }
    
    mutating func insert(key key: K, value: V) throws {
        try insert(element: (key, value))
    }
    
    mutating func insert(element new: (key: K, value: V)) throws {
        let h = hash(new.key)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        if table[h] != nil {
            throw HashTableError.HashConflict
        } else {
            table[h] = new
        }
    }
    
    mutating func find(key key: K) throws -> (key: K, value: V) {
        let h = hash(key)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        if let t = table[h] {
            if t.key == key {
                return t
            }
        }
        throw HashTableError.NotInList
    }
    
    mutating func remove(key key: K) throws -> (key: K, value: V) {
        let h = hash(key)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        if let t = table[h] {
            if key == t.key {
                table[h] = nil
                return t
            }
        }
        throw HashTableError.NotInList
    }
    
    mutating func changeHash(hash newHash: K -> Int) throws {
        let oldHash = self.hash
        let oldTable = self.table
        do {
            self.hash = newHash
            self.table = [(key: K, value: V)?](count: oldTable.count, repeatedValue: nil)
            for element in oldTable {
                if element != nil {
                    try insert(element: element!)
                }
            }
        } catch _ {
            self.hash = oldHash
            self.table = oldTable
            throw HashTableError.BadHashFunction
        }
    }
    
    var description: String {
        return String(table)
    }
    
}



