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

protocol HashTableType : CustomStringConvertible {
    associatedtype Element : Hashable
    
    // init(_ f: Element -> Int)
    // init(_ array: [Element]) throws
    // init()
    // init(_ buckets : Int)
    // init(_ buckets: Int, _ array: [Element]) throws
    // init(_ buckets : Int, hashFunction: Element -> Int)
    mutating func insert(elements: Element...) throws
    mutating func insert(elements: [Element]) throws
    mutating func insertNoCorrection(element new: Element) throws
    mutating func overwriteOrAdd(element: Element) throws
    mutating func executeForKey<T>(key: Element, f: (Int,Int?) throws -> T) throws -> T
    mutating func executeForUniqueKey<T>(key: Element, f: (Int,Int?) throws -> T) throws -> T
    mutating func overwrite(element: Element) throws
    mutating func insert(element new: Element) throws
    mutating func get(key key: Element) throws -> Element
    mutating func remove(key key: Element) throws -> Element
    mutating func correctBucketCount() throws
    func hash(key: Element) throws -> Int
    mutating func changeBucketCount(buckets: Int) throws
    mutating func changeBucketCount(buckets: Int, f: Element -> Int) throws
    mutating func hash(newHash: Element -> Int) throws
    func sort()
    var array : [Element] { get }
    var buckets : Int { get }
    var count : Int { get }
    var description: String { get }
}

struct HashTable <Element : Hashable> : HashTableType {
    
    //P.ERFORMANCE: making table of type [[[(K,V)]]] with the second list being hashed, too?
    private(set) var table          : [[Element]]
    private(set) var hashFunction   : Element -> Int
    
    init(_ f: Element -> Int) {
        self.init()
        hashFunction = f
    }
    
    init(_ array: [Element]) throws {
        self.init()
        for v in array {
            try insert(element: v)
        }
    }
    
    init(_ array: [Element], buckets: Int) throws {
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
    
    init(_ buckets : Int, hashFunction: Element -> Int) {
        table = [[Element]](count: buckets, repeatedValue: [])
        self.hashFunction = hashFunction
    }
    
    //P.ERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: Element...) throws {
        try insert(elements)
    }
    
    //P.ERFORMANCE maybe in parallel or hashing all first in parallel, then appending all?
    mutating func insert(elements: [Element]) throws {
        for v in elements {
            try insertNoCorrection(element: v)
        }
        try correctBucketCount()
    }
    
    //I.DEA private?
    mutating func insertNoCorrection(element new: Element) throws {
        try executeForKey(new) {
            b,i in
                if i != nil { throw HashTableError.InList }
                else        { self.table[b].append(new) }
        }
    }
    
    mutating func overwriteOrAdd(element: Element) throws {
        try executeForKey(element) {
            b, i in
                if i != nil { self.table[b][i!] = element   }
                else        { self.table[b].append(element) }
        }
    }
    
    mutating func executeForKey<T>(key: Element, f: (Int,Int?) throws -> T) throws -> T {
        let h = try hash(key)
        let i = table[h].find { key == $0 }
        return try f(h,i)
    }
    
    mutating func executeForUniqueKey<T>(key: Element, f: (Int,Int?) throws -> T) throws -> T {
        let h = try hash(key)
        let i = try table[h].findUnique { key == $0 }
        return try f(h,i)
    }
    
    mutating func overwrite(element: Element) throws {
        try executeForKey(element) {
            b, i in
                if i != nil { self.table[b][i!] = element    }
                else        { throw HashTableError.NotInList }
        }
    }
    
    mutating func insert(element new: Element) throws {
        try insertNoCorrection(element: new)
        //P.ERFORMANCE useful? maybe saving counter and only testing after 10 insertions...
        try correctBucketCount()
    }
    
    mutating func get(key key: Element) throws -> Element {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b][i!] }
                throw HashTableError.NotInList
        }
    }
    
    //T.ODO removeSavely - using findUnique
    
    mutating func remove(key key: Element) throws -> Element {
        return try executeForKey(key) {
            b, i in
                if i != nil { return self.table[b].removeAtIndex(i!) }
                else        { throw HashTableError.NotInList }
        }
    }
    
    //F.IX needs mathematical basis
    mutating func correctBucketCount() throws {
        print("correcting bucket count?")
        let max = table.max { $0.count > $1.count }.count
        var tc = table.count >> 1
        if tc < 3 {
            print("did end because tc * 2 < 5: " + table.count)
            return
        }
        if max > count / tc {
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
        if min < count / tc {
            print("decreasing bucket count!")
            try changeBucketCount(tc)
            return
        }
        print("min: " + min + ", table.count: " + table.count)
    }
    
    func hash(key: Element) throws -> Int {
        var h = (hashFunction(key) % table.count)
        while h < 0 {
            h += table.count
        }
        h = h % table.count
        if 0 < h || h >= count {
            throw HashTableError.BadHashFunction
        }
        return h
    }
    
    internal mutating func changeBucketCount(buckets: Int) throws {
        try changeBucketCount(buckets, f: hashFunction)
    }
    
    internal mutating func changeBucketCount(buckets: Int, f: Element -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        do {
            let newHash = f
            self.hashFunction = newHash
            self.table = [[Element]](count: buckets, repeatedValue: [])
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

    
    mutating func hash(newHash: Element -> Int) throws {
        let oldHash = self.hashFunction
        let oldTable = self.table
        do {
            self.hashFunction = newHash
            self.table = [[Element]](count: oldTable.count, repeatedValue: [])
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
            arr.sort { return $0.hashValue < $1.hashValue }
        }
    }
    
    var array : [Element] {
        var array = [Element]()
        for arr in table {
            for v in arr {
                array.append(v)
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