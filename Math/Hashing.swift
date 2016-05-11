//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct HashTable <T: NumericType, U> : CustomStringConvertible {
    
    private(set) var table = [[(key: T, value: U)]]()
    private(set) var hash: T -> Int
    
    init(_ count : Int) { // convenience init
        self.init(_: count, hash: { return Int($0 % T(count)) })
    }
    
    init(_ count : Int, hash: T -> Int) {
        table = [[(key: T, value: U)]](count: count, repeatedValue: [])
        self.hash = hash
    }
    
    mutating func insert(key key: T, value: U) throws {
        try insert(element: (key, value))
    }
    
    mutating func insert(element new: (key: T, value: U)) throws {
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
    
    mutating func find(key key: T) throws -> (key: T, value: U) {
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
    
    mutating func remove(key old: T) throws -> (key: T, value: U) {
        let h = hash(old)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        for v in table[h].range {
            if old == table[h][v].key {
                return table[h].removeAtIndex(v)
            }
        }
        throw HashTableError.NotInList
    }
    
    private mutating func testHashFunction() throws -> Bool {
        try changeHash(hash: self.hash)
        var min = 0
        var max = 0
        var total = 0
        for i in 0..<Int(table.count) {
            let length = table[i].count
            if table[min].count > length { min = i }
            if table[max].count < length { max = i }
            total += length
        }
        let avg = total / Int(table.count)
        return max - min < avg
    }
    
    mutating func changeHash(hash newHash: T -> Int) throws {
        let oldHash = self.hash
        let oldTable = self.table
        do {
            self.hash = newHash
            self.table = [[(key: T, value: U)]](count: oldTable.count, repeatedValue: [])
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


struct HashTableNoChaining <T: NumericType, U> : CustomStringConvertible {
    
    private(set) var table = [(key: T, value: U)?]()
    private(set) var hash: T -> Int
    
    init(_ count : Int) { // convenience init
        self.init(_: count, hash: { return Int($0 % T(count)) })
    }
    
    init(_ count : Int, hash: T -> Int) {
        table = [(key: T, value: U)?](count: count, repeatedValue: nil)
        self.hash = hash
    }
    
    mutating func insert(key key: T, value: U) throws {
        try insert(element: (key, value))
    }
    
    mutating func insert(element new: (key: T, value: U)) throws {
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
    
    mutating func find(key key: T) throws -> (key: T, value: U) {
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
    
    mutating func remove(key old: T) throws -> (key: T, value: U) {
        let h = hash(old)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        if let t = table[h] {
            if old == t.key {
                table[h] = nil
                return t
            }
        }
        throw HashTableError.NotInList
    }
    
    mutating func changeHash(hash newHash: T -> Int) throws {
        let oldHash = self.hash
        let oldTable = self.table
        do {
            self.hash = newHash
            self.table = [(key: T, value: U)?](count: oldTable.count, repeatedValue: nil)
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



