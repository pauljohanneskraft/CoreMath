//
//  General.swift
//  Math
//
//  Created by Paul Kraft on 18.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol All {}

extension All {
    mutating func unsafePointer() -> UnsafePointer<Self> {
        return withUnsafePointer(to: &self) { $0 }
    }
    
    mutating func memoryRebound<T>(to: T.Type) -> T {
        return withUnsafePointer(to: &self) {
            $0.withMemoryRebound(to: to, capacity: 1) {
                $0.pointee
            }
        }
    }
    
    func modifyCopy<T>(_ using: (inout Self) throws -> T) rethrows -> T {
        var c = self
        return try using(&c)
    }
    
    func copy(_ using: (inout Self) throws -> Void = { _ in }) rethrows -> Self {
        var c = self
        try using(&c)
        return c
    }
}

extension Double: All {}
extension Int: All {}
extension Int64: All {}
extension Float: All {}
