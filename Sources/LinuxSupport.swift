//
//  LinuxSupport.swift
//  Math
//
//  Created by Paul Kraft on 26.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol TimeProtocol {
    init()
    func timeIntervalSince(_: Self) -> Double
}

#if os(Linux)
	import Glibc
	public let DBL_MAX: Double = unsafeBitCast( 0x7FEFFFFFFFFFFFFF, to: Double.self)
	public let DBL_MIN: Double = unsafeBitCast(   0x10000000000000, to: Double.self)
	public func random() -> Int { return Glibc.random() }
    
    public struct Time: TimeProtocol {
        
        let time: clock_t
        
        public init() {
            self.time = clock()
        }
        
        public func timeIntervalSince(_ time: Time) -> Double {
            return Double(self.time - time.time)
        }
        
    }
    public func pow(_ base: Double, _ exponent: Double) -> Double {
        return Glibc.pow(base, exponent)
    }
    
#else
    
    import Foundation
	public func random() -> Int { return Int(arc4random()) << 32 | Int(arc4random()) }
    public typealias Time = Date
    extension Time: TimeProtocol {}
    public func pow(_ base: Double, _ exponent: Double) -> Double {
        return Foundation.pow(base, exponent)
    }
    
#endif
