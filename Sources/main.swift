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
/*
block(false) {
    var str = "abcdefghijklmnopqrstuvwxyzäöüß"
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

block(false) {
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

block(false) {
    let c = loopUntilNotNullAndNotThrowing {
        () -> Int? in
        let b : Int? = 3
        return b
    }
    print(c.dynamicType)
}

block(false) {
    func hash(_ u: Int) -> Int {
        return (3*u) % 13
    }
}

/*block(true) {
    var infInt = InfiniteInt(UInt.max)
    infInt = (infInt + 1)
    print(infInt)
}*/

block(false) {
    var t = Thread()
    for i in 0..<10 {
        t.add {
            print(i)
        }
    }
    print("t.todo: \(t.todo)")
    t.join()
}

block(false) {
    var a = 1 // InfiniteInt(10000000)
    for i in 0..<100 {
        // a += InfiniteInt(1000000)
        print(a)
    }
}

block(false) {
    
    var a : Int8 = Int8.max
    a = a &+ 1
    print(a)
    print(a.hex)
    print(a.bin)
    print(a.dec)
    // print(a.oct)
    print(a == Int8.min)
    
    print("")
    
    var b : Int16 = Int16.max
    b = b &+ 1
    print(b)
    print(b.hex)
    print(b.bin)
    print(b.dec)
    print(b == Int16.min)
    
    print("")
    
    var c : Int32 = Int32.max
    c = c &+ 1
    print(c)
    print(c.bin)
    print(c.dec)
    print(c.hex)
    // print(c.oct) // 20_000_000_000
    print(c == Int32.min)
    
    print("")
    
    var d : Int64 = Int64.max
    d = d &+ 1
    print(d)
    print(d.bin)
    print(d.dec)
    print(d.hex)
    // print(d.oct)
    print(d == Int64.min)
    
}


block(true) {
    let a = [[0,1,2,3],[4,5,898403824908460,7],[8,3824068943,10,11], [12,13,14,15]]
    print(a.toLaTeX())
}


block(true) {
    let a = [0,1,2,3,4,5,6,7,8,9,10]
    print(a.filter {
        print($0)
        return ($0 > 3) })
}




*/


let a = [[0,1], [2,3]] ^^ 100






