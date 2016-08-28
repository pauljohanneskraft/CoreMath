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
	public var DBL_MAX : Double { return unsafeBitCast(9218868437227405311, to: Double.self) }
	public var DBL_MIN : Double { return unsafeBitCast(   4503599627370496, to: Double.self) }
	public func random() -> Int { return Glibc.random() }
#else
	public func random() -> Int { return Int(arc4random()) << 32 | Int(arc4random()) }
#endif
