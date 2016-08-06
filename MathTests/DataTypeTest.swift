//
//  DataTypeTest.swift
//  Math
//
//  Created by Paul Kraft on 01.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

protocol TypeTest {
    associatedtype DataType
    
    var elements : [DataType] { get }
    
}
extension TypeTest {
    
    func forAll<T>(_ char: String = "_", assert cond: (DataType, T) -> Bool = { _,_ in return true }, _ f: (DataType) -> T) {
        let n = self.elements
        var avgtime = 0.0
        for r in n {
            let start = NSDate().timeIntervalSinceReferenceDate
            let fr = f(r)
            let end = NSDate().timeIntervalSinceReferenceDate
            let time = end-start
            print("\(char)(\(r))", "=", fr, "in", time)
            assert(time >= 0.0)
            avgtime += time
            assert(cond(r, fr))
        }
        print("avg time:", avgtime / Double(n.count), "total:", avgtime)
    }
    
    func forAll<T>(_ char: String = "_", assert cond: (DataType, DataType, T) -> Bool = { _,_,_ in return true }, _ f: (DataType, DataType) -> T) {
        let n = self.elements
        var avgtime = 0.0
        for r in n {
            for q in n {
                let start = NSDate().timeIntervalSinceReferenceDate
                let frq = f(r, q)
                let end = NSDate().timeIntervalSinceReferenceDate
                let time = end-start
                print(r, char, q, "=", frq, "in", time)
                assert(time >= 0)
                avgtime += time
                assert(cond(r,q, frq))
            }
        }
        print("avg time:", avgtime / Double(n.count * n.count), "total:", avgtime)
    }
}
