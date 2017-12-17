//
//  Functions.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public func Sin (_ function: Function) -> Function { return TrigonometricFunction(content: function, kind: .sin ) }
public func Cos (_ function: Function) -> Function { return TrigonometricFunction(content: function, kind: .cos ) }
public func Sinh(_ function: Function) -> Function { return TrigonometricFunction(content: function, kind: .sinh) }
public func Cosh(_ function: Function) -> Function { return TrigonometricFunction(content: function, kind: .cosh) }

public enum Functions {
    public static let sin = Sin(x)
    public static let cos = Cos(x)
    public static let zero = ConstantFunction(0)
    public static let one = ConstantFunction(1)
    public static let x = _Polynomial(degree: 1)
}
