//
//  General.swift
//  Math
//
//  Created by Paul Kraft on 29.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// The <-> operator can be used to simply swap two elements 
// e.g. two array items when used like this: 
// 
// array[i] <-> array[j]
//

infix operator <-> { associativity left precedence 140 assignment }
func <-> <T>(inout left: T, inout right: T) {
    swap(&left, &right)
}

func nocatch<T>(block: () throws -> T ) -> T? {
    do {
        return try block()
    } catch let e {
        print("Error: \(e)")
        return nil
    }
}

import Cocoa

func printMeasure<T>(desc: String = "Test", _ blocks: (() throws -> T)...) {
    for i in blocks.range {
        let desc = "\(desc)\((blocks.count < 2 ? "" : " \(i)"))"
        do {
            let m = try measure {
                return try blocks[i]()
            }
            var res = "returned \(m.result)"
            res = (res != "returned ()" ? res : "finished")
            print("\(desc) \(res) after \(Float(m.time)) s.")
        } catch let e {
            print("Error in \(desc): \(e)")
        }
    }
}

@warn_unused_result func measure<T>(block: () throws -> T ) rethrows -> (time: NSTimeInterval, result: T) {
    var start : NSDate = NSDate()
    var end : NSDate = NSDate()
    var res : T
    start = NSDate()
    res = try block()
    end = NSDate()
    return (end.timeIntervalSince1970 - start.timeIntervalSince1970, res)
}