//
//  DoubleExtensions.swift
//  Math
//
//  Created by Paul Kraft on 16.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Double {
    private static let fastInverseSquareRootMagicNumber: Int64 = 0x5fe6eb50c7b537a9
    
    public var fastInverseSquareRoot: Double {
        var copy = self
        var int = copy.memoryRebound(to: Int64.self)
        int = Double.fastInverseSquareRootMagicNumber - (int >> 1)
        let double = int.memoryRebound(to: Double.self)
        return double
    }
}
