//
//  TrigonometricFunctions.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public struct Trigonometric {
    static let sine     = Term<Double>(description: "sin(x)") { sin($0) }
    static let cosine   = Term<Double>(description: "cos(x)") { cos($0) }
    static let tangent  = Term<Double>(description: "tan(x)") { tan($0) }
}

public struct LogarithmicFunctions {
    static let baseE   = Term<Double>(description:    "ln(x)") { log  ($0) }
    static let base10  = Term<Double>(description: "log10(x)") { log10($0) }
    static let base2   = Term<Double>(description:  "log2(x)") { log2 ($0) }
}

