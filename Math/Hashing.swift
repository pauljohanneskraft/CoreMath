//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct HashTable <K : Hashable, V> : CustomStringConvertible {
    
    private(set) var table          : [[(key: K, value: V)]]
    private(set) var hashFunction   : K -> Int
    
    init(_ f: K -> Int) {
        self.init()
        hashFunction = f
    }
    
    init(_ array: [(K, V)]) throws {
        self.init()
        for v in array {
            try insert(element: v)
        }
    }
    
    init(_ array: [(K, V)], buckets: Int) throws {
        self.init(buckets)
        for v in array {
            try insert(element: v)
        }
    }
    
    init() {
        self.init(0x10)
    }
    
    init(_ buckets : Int) { // convenience init
        self.init(_: buckets, hashFunction: { return $0.hashValue })
    }
    
    init(_ buckets : Int, hashFunction: K -> Int) {
        table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
        self.hashFunction = hashFunction
    }
    
    mutating func insert(elements: (K,V)...) throws {
        try insert(elements)
    }
    
    mutating func insert(elements: [(K,V)]) throws {
        for v in elements {
            try insertNoCorrection(element: v)
        }
        try correctBucketCount()
    }
    
    mutating func insertNoCorrection(element new: (K,V)) throws {
        let h = hash(new.0)
        if !table.range.contains(h) {
            throw HashTableError.BadHashFunction
        }
        for v in table[h].range {
            if new.0 == table[h][v].key {
                throw HashTableError.InList
            }
        }
        table[h].append(new)
    }
    
    mutating func insertNoCorrection(key key: K, value: V) throws {
        try insert(element: (key, value))
    }
    
    mutating func insert(key key: K, value: V) throws {
        try insert(element: (key, value))
    }
    
    mutating func insert(element new: (key: K, value: V)) throws {
        try insertNoCorrection(element: new)
        try correctBucketCount()
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
    
    func sumOfBucketCounts() -> Int {
        var array : [Int] = []
        for i in table {
            array.append(i.count)
        }
        if let e = array.combineAll({ $0 + $1 }) {
            print("sum of " + array + " is " + e)
            return e
        }
        return 0
    }
    
    mutating func correctBucketCount() throws {
        print("correcting bucket count?")
        let max = table.max { $0.count > $1.count }.count
        var tc = table.count >> 1
        if tc < 3 {
            print("did end because tc * 2 < 5: " + table.count)
            return
        }
        if max > sumOfBucketCounts() / tc {
            print("increasing bucket count!")
            try changeBucketCount(tc)
        }
        print("max: " + max + ", table.count * 2: " + tc)

        let min = table.max { $0.count < $1.count }.count
        tc = (table.count << 1)
        if tc < 5 {
            print("did end because tc / 2 < 3: " + table.count)
            return
        }
        if min < sumOfBucketCounts() / tc {
            print("decreasing bucket count!")
            try changeBucketCount(tc)
            return
        }
        print("min: " + min + ", table.count: " + table.count)
    }
    
    func hash(key: K) -> Int {
        var h = (hashFunction(key) % table.count)
        while h < 0 {
            h += table.count
        }
        print("hashes " + key + " to " + h)
        return (h % table.count)
    }
    
    private mutating func changeBucketCount(buckets: Int) throws {
        try changeBucketCount(buckets, f: hashFunction)
    }
    
    private mutating func changeBucketCount(buckets: Int, f: K -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        do {
            let newHash = f
            self.hashFunction = newHash
            self.table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
            for bucket in oldTable {
                for element in bucket {
                    try insertNoCorrection(element: element)
                }
            }
            print("new bucket count is " + buckets)
        } catch _ {
            self.hashFunction = oldHash
            self.table = oldTable
            throw HashTableError.BadHashFunction
        }
    }

    
    mutating func hash(newHash: K -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        do {
            self.hashFunction = newHash
            self.table = [[(key: K, value: V)]](count: oldTable.count, repeatedValue: [])
            for bucket in oldTable {
                for element in bucket {
                    try insert(element: element)
                }
            }
        } catch _ {
            self.hashFunction = oldHash
            self.table = oldTable
            throw HashTableError.BadHashFunction
        }
    }
    
    func sort() {
        for arr in table {
            arr.sort { return $0.key.hashValue < $1.key.hashValue }
        }
    }
    
    var array : [(key: K, value: V)] {
        var array = [(key: K, value: V)]()
        for arr in table {
            for v in arr {
                array.append(v)
            }
        }
        return array
    }
    
    var count : Int {
        var c = 0
        for arr in table {
            c += arr.count
        }
        return c
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



