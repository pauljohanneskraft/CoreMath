//
//  main.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Cocoa

/*
var hT = HashTable<Int, Int>(buckets: 0x2)

printMeasure("NonArrayEntry") {
    hT.resetBuckets = false
    for i in 0..<1000 {
        hT[i] = 100
    }
    hT.resetBuckets = true
    try hT.correctBucketCount()
}

printMeasure("ErrorIsSafeHere", { return 0 }, {
    throw ArrayError.NotUnique
    }, { return "Hallo" })

printMeasure("SameTypes", { return 0 }, {
    return -2.3
    }, { return "Hallo" })

hT = HashTable<Int, Int>(buckets: 0x10)
    
printMeasure("ArrayEntry") {
    var arr = [(key: Int, value: Int)]()
    for i in 0..<1000 {
        arr.append((i,100))
    }
    try hT.insert(arr)
}

printMeasure {
    try hT.hash { $0.hashValue }
}
printMeasure {
   try hT.changeBucketCount(200)
}

printMeasure {
    try hT.changeBucketCount(100)
}

printMeasure {
    try hT.changeBucketCount(200)
}

printMeasure {
    try hT.changeBucketCount(100, f: { $0.hashValue })
}

try hT.changeBucketCount(1)
print("didChange")
print(hT)

 */

/*
var str = "😇😄😅😁😂"

str[0...3] = "😁😂"

for i in 0..<str.characters.count { print(str[0...i]) }


do {
let c = try solve([[1,2,0,1], [1,1,-1,2], [-1,0,2,-1],[-2,3,7,1]], [6,-4,2,-2])
} catch let e { print(e) }
*/

// var c = async(0..<100) { (a) -> Int in return a }

// print(c)
// print(c.count)

/*

var a : [Int] = []

var b = asyncUnordered(0..<100) { $0 }

var d = asyncUnordered(b) { ($0 - 10) << 1 }

print(d)
*/

extension Bool : Comparable {}

public func < (lhs: Bool, rhs: Bool) -> Bool {
    return !lhs && rhs
}

func == (lhs: Bool, rhs: Bool) -> Bool {
    return (lhs && rhs) || (!lhs && !rhs)
}

let logicalAnd = GroupLike( // Monoid
    set:            Set<Bool>([true, false]),
    op:             { $0 && $1 },
    neutralElement: true,
    inv:            { !$0 },
    sign:           "&"
)

let logicalOr = GroupLike( // Monoid
    set:            Set<Bool>([true, false]),
    op:             { $0 || $1 },
    neutralElement: false,
    inv:            { !$0 },
    sign:           "|"
)

let logicalXor = GroupLike( // Abelian Group
    set:            Set<Bool>([true, false]),
    op:             { $0 != $1 },
    neutralElement: false,
    inv:            { $0 },
    sign:           "⨁"
)

print(logicalAnd.strictestType!)
print(logicalAnd.test())
print(logicalOr.strictestType!)
print(logicalOr.test())
print(logicalXor.strictestType!)
print(logicalXor.test())

let numbersUntilPrimeAdd = GroupLike( // Abelian Group
    set:            Z(7),
    op:             { (a,b) -> Int in return ((a + b) % 7) },
    neutralElement: 0,
    inv:            { (a) -> Int in return ((7 - a) % 7) },
    sign:           "+"
)

print(numbersUntilPrimeAdd.strictestType!)
print(numbersUntilPrimeAdd.test())

block {
    let e = 0
    print(e)
}

print(constants.pi)

print(constants.pi.inaccuracy)

print("268746587365834676347269682cnnwx3643,t4sm7n6x")

/*

let values = [3, 42, 51, 17, 29, 23, 24, 3, 18, 40, 14, 23, 23, 40]

func hash(_ u: Int) -> Int {
    return (3*u) % 13
}

var hashesValues = [(Int, Int)]()

for i in values {
    hashesValues.append((i, hash(i)))
}

print(hashesValues)


*/







