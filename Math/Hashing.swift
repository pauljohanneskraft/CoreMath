//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation


protocol HashTableElementType {
    associatedtype Element
    init(elem: Element)
    var key : Int { get }
    var elem : Element { get }
    var hashValue : Int { get }
}
extension HashTableElementType {
    var hashValue : Int { return key }
}

struct HashTable <K: Hashable, V> : ArrayLiteralConvertible, CustomStringConvertible {
    typealias Element = (key: K, value: V)
    
    //P.ERFORMANCE: making table of type [[[(K,V)]]] with the second list being hashed, too?
    private(set) var table          = [[Element]](count: 0x10, repeatedValue: [])
    private(set) var hashFunction   : K -> Int   = { $0.hashValue }
    private(set) var maxBucketSize  : Int = 4 // 2 ^ 4 = 16
    
    init(arrayLiteral elements: Element...) {
        do {
            try self.init(_: elements)
        } catch let e {
            print("Error: \(e)")
            self.init()
        }
    }
    
    var resetBuckets   : Bool       = true {
        didSet {
            if !oldValue && resetBuckets {
                increaseBuckets = true
                decreaseBuckets = true
            }
            if !resetBuckets {
                increaseBuckets = false
                decreaseBuckets = false
            }
        }
    }
    var decreaseBuckets: Bool = true { didSet { if decreaseBuckets && (!oldValue || !resetBuckets) { resetBuckets = true } } }
    var increaseBuckets: Bool = true { didSet { if increaseBuckets && (!oldValue || !resetBuckets) { resetBuckets = true } } }
    
    init(_ f: K -> Int) {
        self.hashFunction = f
    }
    
    init(_ array: [(key: K, value: V)]) throws {
        self.init(array.count >> 2)
        try insert(array)
    }
    
    init(_ array: [(key: K, value: V)], buckets: Int) throws {
        self.init(buckets, resetBuckets: false)
        try insert(array)
    }
    
    init() {}
    
    init(_ buckets: Int, resetBuckets: Bool) {
        table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
    }
    
    init(_ buckets : Int) { // convenience init
        self.init(_: buckets, resetBuckets: false)
    }
    
    init(_ buckets : Int, hashFunction: K -> Int) {
        self.init(buckets, hashFunction: hashFunction, resetBuckets: false)
    }
    
    init(_ buckets : Int, hashFunction: K -> Int, resetBuckets: Bool) {
        table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
        self.hashFunction = hashFunction
        self.resetBuckets = resetBuckets
    }
    
    //P.ERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: (key: K, value: V)...) throws {
        try insert(elements)
    }
    
    //P.ERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: [(key: K, value: V)]) throws {
        try correctBucketCount(count + elements.count)
        print("inserting " + elements.count + " elements.")
        for v in elements {
            // print("inserting " + new)
            try insert(v)
        }
        print("tries to correct in \(#function)")
        try correctBucketCount()
    }
    
    mutating func setBucketCount(buckets: Int) throws {
        let before = resetBuckets
        do {
            resetBuckets = false
            try changeBucketCount(buckets.nextPowerOf2)
        } catch let e {
            resetBuckets = before
            throw e
        }
    }
    
    subscript(key key: K) -> V? {
        get {
            do {
                return try self.get(key: key).value
            } catch _ {
                return nil
            }
        }
        set {
            do {
                if newValue != nil { try overwriteOrAdd(element: (key, newValue!)) }
                else          { do { try remove(key: key) } catch _ {} }
            } catch let e {
                print(e)
            }
        }
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
                    //print(".", terminator: "")
                    try overwriteOrAdd(element: (key, newValue!))
                }
            } catch let e {
                print(e)
            }
        }
    }
    
    //I.DEA private?
    mutating func overwriteOrAdd(element new: (key: K, value: V)) throws {
        try executeForKey(new.key) {
            b, i in
                if i != nil { self.table[b][i!] = new   }
                else        { self.table[b].append(new) }
        }
        try correctBucketCount()
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
                else        { throw HashTableError<K,V>.NotInList(key: new.key) }
        }
    }
    
    mutating func insert(element new: (key: K, value: V)) throws {
        try executeForKey(new.key) {
            b,i in
            if i != nil { throw HashTableError.InList(self.table[b][i!]) }
            else        { self.table[b].append(new) }
        }
        try correctBucketCount()
    }
    
    func get(key key: K) throws -> (key: K, value: V) {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b][i!] }
                throw HashTableError<K,V>.NotInList(key: key)
        }
    }
    
    //T.ODO removeSavely - using findUnique
    
    mutating func remove(key key: K) throws -> (key: K, value: V) {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b].removeAtIndex(i!) }
                else        { throw HashTableError<K,V>.NotInList(key: key) }
        }
    }
    
    mutating func correctBucketCount(count: Int) throws {
        // print("tries correction")
        if !resetBuckets { return }
        // setting 16 as max per bucket
        // buckets * size = count
        // => buckets * 16 >= count
        // count > buckets / 16
        let minBuckets = 4
        let LOGmaxBucketSize = 6
        // => maxBucketSize = 2 ^ (LOGmaxBucketSize)
        // => bucketSize between 2^(x-1) and 2^(x)
        // x = 4 => bucketSize between 4 and 8
        
        let c = (count >> LOGmaxBucketSize).nextPowerOf2
        
        if c <= minBuckets  {
            if buckets != minBuckets {
                if (minBuckets < buckets && decreaseBuckets) || (minBuckets > buckets && increaseBuckets) {
                    try changeBucketCount(minBuckets)
                }
            }
        }
        else {
            if c != buckets {
                if (c < buckets && decreaseBuckets) || (c > buckets && increaseBuckets) {
                    try changeBucketCount(c)
                }
            }
        }
        
        if avgBucketSize > (table.max { $0.count > $1.count }!.count << 2) {
            throw HashTableError<K,V>.BadHashFunction
        }
        
    }
    
    //F.IX needs mathematical basis
    mutating func correctBucketCount() throws {
        try correctBucketCount(count)
    }
    
    var avgBucketSize : Int {
        return count / buckets
    }
    
    func hash(key: K) throws -> Int {
        var h = hashFunction(key) % table.count
        while h < 0 {
            h = (h + table.count) % table.count
        }
        return h
    }
    
    // if f stays the same -> some buckets can stay the same
    internal mutating func changeBucketCount(buckets: Int) throws {
        let oldTable = self.table
        let oldResetBuckets = self.resetBuckets
        do {
            self.resetBuckets = false
            if buckets < self.buckets {
                let mid = oldTable.count / (self.buckets/buckets)
                self.table = [] + oldTable[0..<mid]
                for bucket in oldTable[mid..<oldTable.count] {
                    for element in bucket {
                        try insert(element: element)
                    }
                }
            } else {
                self.table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
                for bucket in oldTable {
                    for element in bucket {
                        try insert(element: element)
                    }
                }
            }
            self.resetBuckets = oldResetBuckets
            print("new bucket count is \(self.buckets), count: \(self.count), avgBucketSize: \(self.avgBucketSize)")
        } catch let e {
            self.resetBuckets = oldResetBuckets
            self.table = oldTable
            print(e)
            throw HashTableError<K,V>.BadHashFunction
        }
    }
    
    internal mutating func changeBucketCount(buckets: Int, f: K -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        let oldResetBuckets = self.resetBuckets
        do {
            self.resetBuckets = false
            self.hashFunction = f
            self.table = [[(key: K, value: V)]](count: buckets, repeatedValue: [])
            for bucket in oldTable {
                for element in bucket {
                    try insert(element: element)
                }
            }
            self.resetBuckets = oldResetBuckets
            print("new bucket count is \(self.buckets), count: \(self.count), avgBucketSize: \(self.avgBucketSize)")
        } catch let e {
            self.resetBuckets = oldResetBuckets
            self.hashFunction = oldHash
            self.table = oldTable
            print(e)
            throw HashTableError<K,V>.BadHashFunction
        }
    }

    
    mutating func hash(newHash: K -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        let oldResetBuckets = self.resetBuckets
        do {
            self.resetBuckets = false
            print("setting new hash")
            self.hashFunction = newHash
            self.table = [[(key: K, value: V)]](count: oldTable.count, repeatedValue: [])
            for bucket in oldTable {
                for element in bucket {
                    try insert(element: element)
                }
            }
            self.resetBuckets = oldResetBuckets
            try correctBucketCount()
        } catch _ {
            self.hashFunction = oldHash
            self.table = oldTable
            self.resetBuckets = oldResetBuckets
            throw HashTableError<K,V>.BadHashFunction
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