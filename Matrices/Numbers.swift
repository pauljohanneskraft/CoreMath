//
//  Numbers.swift
//  Matrices
//
//  Created by Paul Kraft on 22.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// import Cocoa

// partially from source: http://natecook.com/blog/2014/08/generic-functions-for-incompatible-types/

protocol NumericType {
    func  +(lhs: Self, rhs: Self) -> Self
    func  -(lhs: Self, rhs: Self) -> Self
    func  *(lhs: Self, rhs: Self) -> Self
    func  /(lhs: Self, rhs: Self) -> Self
    func  %(lhs: Self, rhs: Self) -> Self
    func !=(lhs: Self, rhs: Self) -> Bool
    func ==(lhs: Self, rhs: Self) -> Bool
    func  <(lhs: Self, rhs: Self) -> Bool
    func  >(lhs: Self, rhs: Self) -> Bool
    func <=(lhs: Self, rhs: Self) -> Bool
    func >=(lhs: Self, rhs: Self) -> Bool
    init(_ v: Int)
}

extension Double : NumericType {}
extension Float  : NumericType {}
extension Int    : NumericType {}
extension Int8   : NumericType {}
extension Int16  : NumericType {}
extension Int32  : NumericType {}
extension Int64  : NumericType {}
extension UInt   : NumericType {}
extension UInt8  : NumericType {}
extension UInt16 : NumericType {}
extension UInt32 : NumericType {}
extension UInt64 : NumericType {}

postfix func ++<T: NumericType>(inout left: T) -> T {
    let before = left
    ++left
    return before
}

prefix func ++<T: NumericType>(inout left: T) -> T {
    left = left + T(1)
    return left
}

postfix func --<T: NumericType>(inout left: T) -> T {
    let before = left
    --left
    return before
}

prefix func --<T: NumericType>(inout left: T) -> T {
    left = left - T(1)
    return left
}

func /= <T: NumericType>(inout left: T, right: T) -> T {
    left = left / right
    return left
}

func += <T: NumericType>(inout left: T, right: T) -> T {
    left = left + right
    return left
}

prefix func -<T:NumericType>(left: T) -> T {
    return T(0) - left
}

func abs<T: NumericType>(left: T) -> T {
    if left < T(0) { return -left }
    return left
}

