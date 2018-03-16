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

extension Array {
    public mutating func insertSorted(_ element: Element, where order: (Element, Element) throws -> Bool) rethrows {
        guard let index = try index(where: { try !order($0, element) }) else {
            append(element)
            return
        }
        insert(element, at: index)
    }
}

extension Array {
    @discardableResult
    public mutating func insertSortedNoDuplicates(_ element: Element,
                                                  where order: (Element, Element) throws -> Bool,
                                                  equal: (Element, Element) -> Bool) throws -> Int {
        guard let index = try index(where: { try !order($0, element) }) else {
            append(element)
            return count - 1
        }
        guard !equal(self[index], element) else {
            throw ArrayError.duplicate
        }
        insert(element, at: index)
        return index
    }
}

enum ArrayError: Error {
    case duplicate
}

extension Array where Element: Comparable {
    public mutating func insertSorted(_ element: Element) {
        insertSorted(element, where: <)
    }
    
    @discardableResult
    public mutating func insertSortedNoDuplicates(_ element: Element) throws -> Int {
        return try insertSortedNoDuplicates(element, where: <, equal: ==)
    }
}

extension Collection {
    func get(at index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

extension Double: All {}
extension Int: All {}
extension Int64: All {}
extension Float: All {}

func log(base: Double, of: Double) -> Double {
    return log(of) / log(base)
}

extension Float {
    public static var inaccuracy: Float {
        return nextafterf(1, .max) - 1
    }
}

extension Double {
    public static var inaccuracy: Double {
        return nextafter(1, .max) - 1
    }
}

extension Double {
    public static var eulersNumber: Double {
        return Constants.Math.e
    }
}

extension Double {
    public var isReal: Bool {
        return isFinite && !isNaN
    }
}

extension Float {
    public var isReal: Bool {
        return isFinite && !isNaN
    }
}

extension Int {
    var divisors: [Int] {
        let range = 1..<((self + 1).sqrt + 1) / 2
        return range.reduce(into: [Int]()) { result, divisor in
            guard self % divisor == 0 else { return }
            result.append(divisor)
            result.append(self - divisor)
        }
    }
}
