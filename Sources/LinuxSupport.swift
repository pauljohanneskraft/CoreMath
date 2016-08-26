//
//  LinuxSupport.swift
//  Math
//
//  Created by Paul Kraft on 26.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

#if os(Linux)
	public var DBL_MAX : Double { return unsafeBitCast(Int.max, to: Double.self) }
	public var DBL_MIN : Double { return unsafeBitCast(Int.min, to: Double.self) }
#else
	public func random() -> Int {
		return Int(arc4random())
	}
#endif
