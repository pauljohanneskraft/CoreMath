//
//  CGColor.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension CGColor {
    var nsColor: NSColor? {
        return NSColor(cgColor: self)
    }
}
