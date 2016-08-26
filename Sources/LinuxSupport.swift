//
//  LinuxSupport.swift
//  Math
//
//  Created by Paul Kraft on 26.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

#if os(Linux)
	public func arc4random() -> UInt32 {
		return random()
	}
	public var DBL_MAX : Double { return unsafeBitCast(Int.max, to: Double.self) }
#endif
