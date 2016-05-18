//
//  Protocols.swift
//  Math
//
//  Created by Paul Kraft on 15.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Cocoa

protocol ElementaryCalculation : Addable, Subtractable, Multipliable, Divisible {}

protocol Multipliable {
    func * (left: Self, right: Self) -> Self
    func *=( left: inout Self, right: Self)
}

protocol Addable {
    func + (left: Self, right: Self) -> Self
    func += ( left: inout Self, right: Self)
}

protocol Subtractable {
    func - (left: Self, right: Self) -> Self
    func -= ( left: inout Self, right: Self)
}

protocol Divisible {
    func / (left: Self, right: Self) -> Self
    func /= ( left: inout Self, right: Self)
}