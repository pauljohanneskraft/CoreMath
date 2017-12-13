//
//  Functions.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public func Sin (_ function: Function) -> Function { return trig(f: function, kind: .sin ) }
public func Cos (_ function: Function) -> Function { return trig(f: function, kind: .cos ) }
public func Sinh(_ function: Function) -> Function { return trig(f: function, kind: .sinh) }
public func Cosh(_ function: Function) -> Function { return trig(f: function, kind: .cosh) }

public func Cos (_ double: Double) -> Function { return Constant(cos (double)) }
public func Sin (_ double: Double) -> Function { return Constant(sin (double)) }
public func Sinh(_ double: Double) -> Function { return Constant(sinh(double)) }
public func Cosh(_ double: Double) -> Function { return Constant(cosh(double)) }

private func trig(f: Function, kind: TrigonometricFunction.Kind) -> TrigonometricFunction {
    return TrigonometricFunction(content: f, kind: kind)
}

public enum Functions {
    public static let sin = Sin(x)
    public static let cos = Cos(x)
    public static let zero = ConstantFunction(0)
    public static let one = ConstantFunction(1)
    public static let x = _Polynomial(degree: 1)
}
