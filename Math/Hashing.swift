//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct HashList <T: NumericType, U> {
    
    private(set) var list = [[(key: T, value: U)]]()
    private(set) var m : UInt = 10
    
    init(_ count : UInt) {
        m = count
        list = [[(key: T, value: U)]]()
        for _ in 0..<count {
            list.append([])
        }
    }
    
    mutating func insert(new: (key: T, value: U)) throws {
        let h = hash(new.key)
        for v in list[h] {
            if new.key == v.key {
                throw HashListError.AlreadyInList
            }
        }
        list[h].append(new)
    }
    
    func hash(value : T) -> Int {
        return Int(value % T(m))
    }
    
}









