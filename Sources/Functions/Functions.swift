//
//  Functions.swift
//  Math
//
//  Created by Paul Kraft on 01.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

func Sin (_ function: Function) -> Function { return trig(f: function, kind: .sin ) }
func Cos (_ function: Function) -> Function { return trig(f: function, kind: .cos ) }
func Sinh(_ function: Function) -> Function { return trig(f: function, kind: .sinh) }
func Cosh(_ function: Function) -> Function { return trig(f: function, kind: .cosh) }

func Cos (_ double: Double) -> Function { return Constant(cos (double)) }
func Sin (_ double: Double) -> Function { return Constant(sin (double)) }
func Sinh(_ double: Double) -> Function { return Constant(sinh(double)) }
func Cosh(_ double: Double) -> Function { return Constant(cosh(double)) }

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
