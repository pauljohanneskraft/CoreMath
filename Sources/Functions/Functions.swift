//
//  Functions.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public enum Functions {
    public static let sin = sine
    public static let cos = cosine
    public static let zero = ConstantFunction(0)
    public static let one = ConstantFunction(1)
    public static let x = _Polynomial(degree: 1)
}

private let sine: CustomFunction = .init("sin(x)", function: { sin($0) }, integral: { -cosine }, derivative: { cosine })
private let cosine: CustomFunction = .init("cos(x)", function: { cos($0) }, integral: { sine }, derivative: { -sine })
