//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct HashTableElement<K> : Hashable {
    let key : Int
    var elem : K?
    var hashValue : Int { return key }
}

func ==<K>(lhs: HashTableElement<K>, rhs: HashTableElement<K>) -> Bool {
    return lhs.key == rhs.key
}

struct HashTable <K: Hashable, V> {
    
    //P.ERFORMANCE: making table of type [[[(K,V)]]] with the second list being hashed, too?
    private(set) var table          : [[(key: K, value: V)]]
    private(set) var hashFunction   : K -> Int
    
    init(_ f: K -> Int) {
        self.init(0x10, hashFunction: f)
    }
    
    init(_ array: [(key: K, value: V)]) throws {
        self.init()
        try insert(array)
    }
    
    init(_ array: [(key: K, value: V)], buckets: Int) throws {
        self.init(buckets)
        try insert(array)
    }
    
    init() {
        self.init(0x10)
    }
    
    init(_ buckets : Int) { // convenience init
        self.init(_: buckets, hashFunction: { $0.hashValue })
    }
    
    init(_ buckets : Int, hashFunction: K -> Int) {
        table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
        self.hashFunction = hashFunction
    }
    
    //P.ERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: (key: K, value: V)...) throws {
        try insert(elements)
    }
    
    //P.ERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: [(key: K, value: V)]) throws {
        for v in elements {
            try insertNoCorrection(element: v)
        }
        // print("tries to correct in \(#function)")
        try correctBucketCount()
    }
    
    subscript(key: K) -> V? {
        get {
            do {
                return try self.get(key: key).value
            } catch _ {
                return nil
            }
        }
        set {
            do {
                if newValue != nil {
                    try overwriteOrAdd(element: (key, newValue!))
                }
            } catch let e {
                print(e)
            }
        }
    }
    
    //I.DEA private?
    mutating func insertNoCorrection(element new: (key: K, value: V)) throws {
        // print("inserting " + new)
        try executeForKey(new.key) {
            b,i in
                if i != nil { throw HashTableError.InList }
                else        { self.table[b].append(new) }
        }
    }
    
    mutating func overwriteOrAdd(element new: (key: K, value: V)) throws {
        try executeForKey(new.key) {
            b, i in
                if i != nil { self.table[b][i!] = new   }
                else        { self.table[b].append(new) }
        }
    }
    
    func executeForKey<T>(key: K, f: (Int,Int?) throws -> T) throws -> T {
        let h = try hash(key)
        let i = table[h].find { key == $0.key }
        return try f(h,i)
    }
    
    func executeForUniqueKey<T>(key: K, f: (Int,Int?) throws -> T) throws -> T {
        let h = try hash(key)
        let i = try table[h].findUnique { key == $0.key }
        return try f(h,i)
    }
    
    mutating func overwrite(element new: (key: K, value: V)) throws {
        try executeForKey(new.key) {
            b, i in
                if i != nil { self.table[b][i!] = new    }
                else        { throw HashTableError.NotInList }
        }
    }
    
    mutating func insert(element new: (key: K, value: V)) throws {
        try insertNoCorrection(element: new)
        //P.ERFORMANCE useful? maybe saving counter and only testing after 10 insertions...
        try correctBucketCount()
    }
    
    func get(key key: K) throws -> (key: K, value: V) {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b][i!] }
                throw HashTableError.NotInList
        }
    }
    
    //T.ODO removeSavely - using findUnique
    
    mutating func remove(key key: K) throws -> (key: K, value: V) {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b].removeAtIndex(i!) }
                else        { throw HashTableError.NotInList }
        }
    }
    
    //F.IX needs mathematical basis
    mutating func correctBucketCount() throws {
        print("tries correction")
        var quotient = (count / table.count) >> 4
        while quotient > 0 {
            try changeBucketCount(table.count << 1)
            quotient = (count / table.count) >> 0x10
        }
    }
    
    func hash(key: K) throws -> Int {
        return ((hashFunction(key) + table.count) % table.count)
    }
    
    internal mutating func changeBucketCount(buckets: Int) throws {
        try changeBucketCount(buckets, f: hashFunction)
    }
    
    internal mutating func changeBucketCount(buckets: Int, f: K -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        do {
            self.hashFunction = f
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
            print("setting new hash")
            self.hashFunction = newHash
            self.table = [[(key: K, value: V)]](count: oldTable.count, repeatedValue: [])
            for bucket in oldTable {
                for element in bucket {
                    try insertNoCorrection(element: element)
                }
            }
            try correctBucketCount()
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
    
    var array : [V] {
        var array = [V]()
        for arr in table {
            for v in arr {
                array.append(v.value)
            }
        }
        return array
    }
    
    var buckets : Int {
        return table.count
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