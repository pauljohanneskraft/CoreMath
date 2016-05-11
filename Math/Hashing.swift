//
//  Hashing.swift
//  Math
//
//  Created by Paul Kraft on 11.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct HashList <T: NumericType> {
    
    private(set) var list = [[T]]()
    private(set) var m : UInt = 10
    
    init(_ count : UInt) {
        m = count
        list = [[T]]()
        for _ in 0..<count {
            list.append([])
        }
    }
    
    mutating func insert(value : T) throws {
        let h = hash(value)
        for v in list[h] {
            if value == v {
                throw HashListError.AlreadyInList
            }
        }
        list[h].append(value)
    }
    
    func hash(value : T) -> Int {
        return Int(value % T(m))
    }
    
    
}









