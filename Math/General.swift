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
func <-> <T>( left: inout T, right: inout T) {
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
    for i in blocks.indices {
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

@warn_unused_result func measure<T>(_ block: () throws -> T ) rethrows -> (time: NSTimeInterval, result: T) {
    var start : NSDate = NSDate()
    var end   : NSDate = NSDate()
    var res   : T
    start = NSDate()
    res = try block()
    end = NSDate()
    return (end.timeIntervalSince1970 - start.timeIntervalSince1970, res)
}

@warn_unused_result
public func asyncWithIndex<S : Sequence, U  where S.Iterator.Element : Hashable>
    (_ sequence: S, _ block: (S.Iterator.Element) -> U)
    -> [S.Iterator.Element:U] {
        
        let group = dispatch_group_create()!
        var dict : [S.Iterator.Element:U] = [:]
        let lockQueue = dispatch_queue_create("Math.LoopLockQueue", nil)!
        
        for i in sequence {
            dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let c = block(i)
                dispatch_sync(lockQueue) { dict[i] = c }
            }
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        return dict
}

@warn_unused_result
public func asyncUnordered<S : Sequence, U  where S.Iterator.Element : Hashable>
    (_ sequence: S, _ block: (S.Iterator.Element) -> U)
    -> [U] {
        
        let group = dispatch_group_create()!
        var arr : [U] = []
        let lockQueue = dispatch_queue_create("Math.LoopLockQueue", nil)!
        
        for i in sequence {
            dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let c = block(i)
                dispatch_sync(lockQueue) { arr.append(c) }
            }
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        return arr
}


public func async<S : Sequence>(_ sequence: S, _ block: (S.Iterator.Element) -> ()) {
    let group = dispatch_group_create()!
    for i in sequence {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
            { block(i) }
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    
}