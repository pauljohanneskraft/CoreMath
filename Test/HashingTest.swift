//
//  HashingTest.swift
//  Math
//
//  Created by Paul Kraft on 12.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest

@testable import Math

class HashingTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func testThis() {
        var hashTable = HashTable<Word, Word>(buckets: 0x10)

        measureThrowingBlock {
            hashTable = HashTable<Word, Word>(buckets: 0x10)
            
            try hashTable.correctBucketCount()
            
            let max = 0xFFF
            
            try hashTable.correctBucketCount(max)
            
            hashTable.increaseBuckets = true
            hashTable.decreaseBuckets = false
            
            for i in 0..<max {
                hashTable[Word(max-i)] = Word(i)
            }
        }
        print(hashTable)
        print("bucketCount \(hashTable.buckets), count: \(hashTable.count), avgBucketSize: \(hashTable.avgBucketSize)")
    }
    */
}
