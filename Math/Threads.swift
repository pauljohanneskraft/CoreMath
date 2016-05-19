//
//  Threads.swift
//  Math
//
//  Created by Paul Kraft on 19.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Sequence where Self.Iterator.Element : Hashable {
    typealias Element = Self.Iterator.Element
    public func loop<U>(_ block: (Element) -> U) -> [(Element,U)] {
        let group = dispatch_group_create()!
        var cs = [(Element,U)]()
        let lockQueue = dispatch_queue_create("Math.LoopLockQueue", nil)!
        for i in self {
            dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                let c = block(i)
                dispatch_sync(lockQueue) { cs.append((i,c)) }
            })
        }
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        return cs
    }
}










