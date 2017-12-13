//
//  NSStackView.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Cocoa

extension NSStackView {
    convenience init(orientation: NSUserInterfaceLayoutOrientation, alignment: NSLayoutConstraint.Attribute,
                     distribution: NSStackView.Distribution, subviews: [NSView] = []) {
        self.init()
        self.orientation = orientation
        self.alignment = alignment
        self.distribution = distribution
        backgroundColor = .clear
        addArrangedSubviewsWithoutResizingMask(subviews)
    }
    
    func addArrangedSubviewWithoutResizingMask(_ view: NSView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(view)
    }
    
    func addArrangedSubviewsWithoutResizingMask(_ views: [NSView]) {
        views.forEach { addArrangedSubviewWithoutResizingMask($0) }
    }
}
