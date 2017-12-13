//
//  NSView.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension NSView {
    func addSubviewWithoutResizingMask(_ view: NSView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    func addSubviewsWithoutResizingMask(_ views: [NSView]) {
        views.forEach { addSubviewWithoutResizingMask($0) }
    }
}

extension NSView {
    var forcedLayer: CALayer! {
        wantsLayer = true
        return layer
    }
    
    var backgroundColor: NSColor? {
        get {
            return layer?.backgroundColor?.nsColor
        }
        set {
            forcedLayer?.backgroundColor = newValue?.cgColor
        }
    }
}
