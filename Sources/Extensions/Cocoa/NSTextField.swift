//
//  NSTextField.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension NSTextField {
    convenience init(string: String, textColor: NSColor = .black) {
        self.init()
        self.stringValue = string
        self.font = NSFont.systemFont(ofSize: 15)
        self.textColor = textColor
        self.isEditable = false
        self.isSelectable = false
        self.bezelStyle = .squareBezel
        self.isBordered = false
        self.drawsBackground = false
        backgroundColor = .clear
    }
}
