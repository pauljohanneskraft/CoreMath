//
//  HashingChaining.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation



protocol HashTableElementType : Hashable {
    associatedtype Key : Hashable
    associatedtype Element
    init(elem: Element)
    var key : Key       { get }
    var value : Element { get }
    var hashValue : Int { get }
}
extension HashTableElementType {
    var hashValue : Int { return key.hashValue }
    var tuple : (Int, Element) { return (hashValue, value) }
}

struct HashTable <K: Hashable, V> : ArrayLiteralConvertible, CustomStringConvertible {
    typealias Element = (key: K, value: V)
    
    // PERFORMANCE: making table of type [[[(K,V)]]] with the second list being hashed, too?
    private(set) var hashFunction   : (K) -> Int   = { $0.hashValue }
    private(set) var maxBucketSize  : Int = 4 // 2 ^ 4 = 16
    private(set) var table          = [[Element]](repeating: [], count: 0x10)
    
    init(arrayLiteral elements: Element...) {
        print("here")
        do {
            try self.init(_: elements)
        } catch let e {
            print("Error: \(e)")
            self.init(buckets: 0x10)
        }
    }
    
    var resetBuckets   : Bool       = true {
        didSet {
            if !oldValue && resetBuckets {
                increaseBuckets = true
                decreaseBuckets = true
                do { try correctBucketCount() } catch _ {}
            }
            if !resetBuckets {
                increaseBuckets = false
                decreaseBuckets = false
            }
        }
    }
    var decreaseBuckets: Bool = true { didSet { if decreaseBuckets && (!oldValue || !resetBuckets) { resetBuckets = true } } }
    var increaseBuckets: Bool = true { didSet { if increaseBuckets && (!oldValue || !resetBuckets) { resetBuckets = true } } }
    
    init(_ array: [(key: K, value: V)], buckets: Int = 0x10) throws {
        self.init(buckets: buckets, resetBuckets: false)
        try insert(array)
    }
    
    init(buckets: Int = 0x10, resetBuckets: Bool = true, hashFunction: (K) -> Int = { $0.hashValue }) {
        self.table = [[(key: K, value: V)]](repeating: [], count: buckets < 4 ? 4 : buckets.nextPowerOf2)
        self.hashFunction = hashFunction
        self.resetBuckets = resetBuckets
    }
    
    //PERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: (key: K, value: V)...) throws {
        try insert(elements)
    }
    
    //PERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(_ elements: [(key: K, value: V)]) throws {
        try correctBucketCount(count + elements.count)
        let oldResetBuckets = resetBuckets
        self.resetBuckets = false
        for v in elements {
            try insert(element: v)
        }
        print("tries to correct in \(#function)")
        self.resetBuckets = oldResetBuckets
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
                else               { try remove(key: key) }
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
    
    mutating func overwriteOrAdd(element new: (key: K, value: V)) throws {
        try executeForKey(new.key) {
            b, i in
                if i != nil { self.table[b][i!] = new   }
                else        { self.table[b].append(new) }
        }
        try correctBucketCount()
    }
    
    func executeForKey<T>(_ key: K, f: (Int,Int?) throws -> T) throws -> T {
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
    
    func get(key: K) throws -> (key: K, value: V) {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b][i!] }
                throw HashTableError<K,V>.NotInList(key: key)
        }
    }
    
    //TODO removeSavely - using findUnique
    mutating func remove(key: K) throws -> (key: K, value: V) {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b].remove(at: i!) }
                else        { throw HashTableError<K,V>.NotInList(key: key) }
        }
    }
    
    mutating func correctBucketCount(_ count: Int) throws {
        // print("tries correction")
        if !resetBuckets { return }
        // setting 16 as max per bucket
        // buckets * size = count
        // => buckets * 16 >= count
        // count > buckets / 16
        let minBuckets = 4
        let LOGmaxBucketSize = Int(log2(Double(maxBucketSize)))
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
    
    mutating func correctBucketCount() throws {
        try correctBucketCount(count)
    }
    
    var avgBucketSize : Int {
        return count / buckets
    }
    
    func hash(_ key: K) throws -> Int {
        var h = hashFunction(key) % table.count
        while h < 0 {
            h = (h + table.count) % table.count
        }
        return h
    }
    
    // if f stays the same -> some buckets can stay the same
    internal mutating func changeBucketCount(_ buckets: Int) throws {
        let oldTable = self.table
        let oldResetBuckets = self.resetBuckets
        do {
            let buckets = buckets.nextPowerOf2
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
                self.table = [[(key: K, value: V)]](repeating: [], count: buckets)
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
    
    internal mutating func changeBucketCount(_ buckets: Int, f: (K) -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        let oldResetBuckets = self.resetBuckets
        do {
            let buckets = buckets.nextPowerOf2
            self.resetBuckets = false
            self.hashFunction = f
            self.table = [[(key: K, value: V)]](repeating: [], count: buckets)
            for bucket in oldTable {
                for element in bucket {
                    try insert(element: element)
                }
            }
            self.resetBuckets = oldResetBuckets
            print("new function, new bucket count is \(self.buckets), count: \(self.count), avgBucketSize: \(self.avgBucketSize)")
        } catch let e {
            self.resetBuckets = oldResetBuckets
            self.hashFunction = oldHash
            self.table = oldTable
            print(e)
            throw HashTableError<K,V>.BadHashFunction
        }
    }

    
    mutating func hash(_ newHash: (K) -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        let oldResetBuckets = self.resetBuckets
        do {
            self.resetBuckets = false
            print("setting new hash")
            self.hashFunction = newHash
            self.table = [[(key: K, value: V)]](repeating: [], count: oldTable.count)
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

    mutating func sort() {
        for i in table.indices {
            table[i].sort { return $0.key.hashValue < $1.key.hashValue }
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
        var desc = "HashTable\(Element.self)\n"
        for i in table.indices {
            desc += "bucket \(i+1): \(table[i])\n"
        }
        return desc
    }
}
 /*
protocol HashTableType {
    associatedtype Element : Hashable
    associatedtype Table   : Collection
    
    var hashFunction: (Element) -> Int { get set }
    func hash(elem: Element) -> Int
    
    var table: Table { get }
    var count : Int { get set }
    
    func insert(elem: Element) throws
    func overrideOrAdd(elem: Element) throws
    func insert<C : Collection>(elem: C) throws
}

extension HashTableType {
    func hash(elem: Element) -> Int {
        return elem.hashValue.abs % count
    }
}

*/



















