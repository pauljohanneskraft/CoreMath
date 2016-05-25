//
//  main.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Cocoa

/*
try block(false) {
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
}*/

block(false) {
    var str = "😇😄😅😁😂😇😄😅😁😂😇😄😅😁😂😇😄😅😁😂😇😄😅😁😂"
    for i in 0...str.characters.count {
        print("str[0..<\(i)]: \(str[0..<i])")
    }
    str[0..<10] = "😁😂"
    for i in 0...str.characters.count {
        print("str[0..<\(i)]: \(str[0..<i])")
    }
    print(str)
}

block(false) {
    do {
        let c = try solve([[1,2,0,1], [1,1,-1,2], [-1,0,2,-1],[-2,3,7,1]], [6,-4,2,-2])
    } catch let e {
        print(e)
    }
}

block(false) {
    var c = asyncUnordered(0..<100) { (a) -> Int in return a }
    print(c)
    print(c.count)
}

block(false) {
    var a : [Int] = []
    var b = asyncUnordered(0..<100) { a in return a }
    var d = asyncUnordered(b) { (a) -> Int in return ((a - 10) << 1) }
    print(d)
}

block(false) {
    let logicalAnd = GroupLike( // Monoid
        set:            Set<Bool>([true, false]),
        op:             { (a,b) -> Bool in return (a && b) },
        neutralElement: true,
        inv:            { (a) -> Bool in return !a },
        sign:           "&"
    )
    print(logicalAnd.strictestType!)
    print(logicalAnd.test())
}

block(false) {
    let logicalOr = GroupLike( // Monoid
        set:            Set<Bool>([true, false]),
        op:             { (a,b) -> Bool in return (a || b) },
        neutralElement: false,
        inv:            { (a) -> Bool in return !a },
        sign:           "|"
    )
    print(logicalOr.strictestType!)
    print(logicalOr.test())
}

block(false) {
    let logicalXor = GroupLike( // Abelian Group
        set:            Set<Bool>([true, false]),
        op:             { (a,b) -> Bool in return (a != b) },
        neutralElement: false,
        inv:            { (a) -> Bool in return a },
        sign:           "⨁"
    )
    print(logicalXor.strictestType!)
    print(logicalXor.test())
}

block(false) {
    let numbersUntilPrimeAdd = GroupLike( // Abelian Group
        set:            Z(7),
        op:             { (a,b) -> Int in return ((a + b) % 7) },
        neutralElement: 0,
        inv:            { (a) -> Int in return ((7 - a) % 7) },
        sign:           "+"
    )
    print(numbersUntilPrimeAdd.strictestType!)
    print(numbersUntilPrimeAdd.test())
}

block(false) {
    print(constants.pi)
    print(constants.pi.inaccuracy)
}

block(true) {
    print(1e20.inaccuracy)
    print((1e20 + 100.0).inaccuracy)
}

block(false) {
    let values = [3, 42, 51, 17, 29, 23, 24, 3, 18, 40, 14, 23, 23, 40]
    
    func hash(_ u: Int) -> Int {
        return (3*u) % 13
    }
    
    var hashesValues = [(Int, Int)]()
    
    for i in values {
        hashesValues.append((i, hash(i)))
    }
    
    print(hashesValues)
}

block(true) {
    let c = loopUntilNotNullAndNotThrowing {
        () -> Int? in
        let b : Int? = 3
        return b
    }
    print(c.dynamicType)
}
