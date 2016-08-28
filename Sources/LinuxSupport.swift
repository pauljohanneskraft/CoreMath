//
//  LinuxSupport.swift
//  Math
//
//  Created by Paul Kraft on 26.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

#if os(Linux)
	import Glibc
	public let DBL_MAX : Double = unsafeBitCast(9218868437227405311, to: Double.self)
	public let DBL_MIN : Double = unsafeBitCast(   4503599627370496, to: Double.self)
	public func random() -> Int { return Glibc.random() }
#else
	public func random() -> Int { return Int(arc4random()) << 32 | Int(arc4random()) }
#endif
