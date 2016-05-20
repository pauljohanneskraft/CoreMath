//
//  Threads.swift
//  Math
//
//  Created by Paul Kraft on 19.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

@warn_unused_result
public func asyncLoopReturnValues<S : Sequence, U  where S.Iterator.Element : Hashable>
    (_ sequence: S, _ block: (S.Iterator.Element) -> U)
    -> [S.Iterator.Element:U] {
        
        let group = dispatch_group_create()!
        var dict : [S.Iterator.Element:U] = [:]
        let lockQueue = dispatch_queue_create("Math.LoopLockQueue", nil)!
        
        for i in sequence {
            
            dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                
                let c = block(i)
                
                dispatch_sync(lockQueue) { dict[i] = c }
                
            })
            
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        
        return dict
}

public func asyncLoop<S : Sequence>(_ sequence: S, _ block: (S.Iterator.Element) -> ()) {
    
    let group = dispatch_group_create()!
    
    for i in sequence {
        
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
            
            block(i)
            
        })
        
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
    
}







