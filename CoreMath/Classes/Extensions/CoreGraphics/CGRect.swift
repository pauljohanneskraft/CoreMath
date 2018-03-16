//
//  CGRect.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
