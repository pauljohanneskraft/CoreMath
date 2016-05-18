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
*/

do {
let c = try solve([[1,2,0,1], [1,1,-1,2], [-1,0,2,-1],[-2,3,7,1]], [6,-4,2,-2])
} catch let e { print(e) }

