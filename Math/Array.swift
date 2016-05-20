//
//  Array.swift
//  Math
//
//  Created by Paul Kraft on 23.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

// extension to add swapping-capability, e.g. comfortable when sorting

import Foundation

extension Array {
    mutating func swap(_ left: Int, _ right: Int) {
        self[left] <-> self[right]
    }
    
    func toLaTeXVector() -> String {
        var out = "\\begin{pmatrix}\n"
        for value in self.dropLast() {
            out += "\(value) \\\\\n"
        }
        if let last = self.last {
            out += "\(last)\n"
        }
        return out + "\\end{pmatrix}"
    }
    
    func toLaTeX() -> String {
        var out = "\\begin{pmatrix}\n"
        for value in self.dropLast() {
            out += "\(value) & "
        }
        if let last = self.last {
            out += "\(last) \\\\\n"
        }
        return out + "\\end{pmatrix}"
    }
    
    func combineAll(_ f: (Element, Element) -> Element) -> Element? {
        if count < 5 {
            if count == 0 { return nil }
            if count == 1 { return self[0] }
            var res = f(self[0], self[1])
            for v in self.dropFirst().dropFirst() {
                res = f(res, v)
            }
            return res
        }
        let mid = count >> 1
        let left  = ([] + self[0..<mid]).combineAll(f)
        let right = ([] + self[mid..<count]).combineAll(f)
        if let l = left {
            if let r = right {
                return f(l,r)
            }
        }
        return nil
    }
    
    func find(_ f: (Element) -> Bool) -> Int? {
        if self.count == 0 { return nil }
        if self.count < 5 {
            for i in self.indices {
                if f(self[i]) { return i }
            }
            return nil
        }
        let mid = self.count >> 1
        let left = ([] + self[0..<mid]).find(f)
        if left != nil { return left }
        let right = ([] + self[mid..<count]).find(f)
        return right
    }
    
    func findUnique(_ f: (Element) -> Bool) throws -> Int? {
        if self.count == 0 { return nil }
        if self.count < 5 {
            var v : Int? = nil
            for i in self.indices {
                if f(self[i]) {
                    if v == i   { v = i }
                    else        { throw ArrayError.NotUnique }
                }
            }
            return v
        }
        let mid = count >> 1
        let left = ([] + self[0..<mid]).find(f)
        let right = ([] + self[mid..<count]).find(f)
        if left != nil && right != nil {
            throw ArrayError.NotUnique
        }
        return (left == nil ? right : left)
    }
    
    mutating func setAll(_ to: (Element) throws -> Element ) rethrows {
        for i in self.indices {
            self[i] = try to(self[i])
        }
    }
}

// division of an array and a number (simply divides every single item)

func / <T : NumericType>(left: [T], right: T) -> [T] {
    var left = left
    left /= right
    return left
}

func /= <T : NumericType>( left: inout [T], right: T) -> [T] {
    for valueIndex in 0..<left.count {
        left[valueIndex] = left[valueIndex] / right
    }
    return left
}

prefix func §<T : NumericType>(lhs: [T]) -> [[T]] {
    var res : [[T]] = []
    for v in lhs {
        res.append([v])
    }
    return res
}

infix operator ⋃ {}
func ⋃ <T> (left: Set<T>, right: Set<T>) -> Set<T> {
    return left.union(right)
}

infix operator ⋃= {}
func ⋃= <T> ( left: inout Set<T>, right: Set<T>) -> Set<T> {
    left.formUnion(right)
    return left
}


infix operator ⋂ {}
func ⋂ <T>(left: Set<T>, right: Set<T>) -> Set<T> {
    return left.intersection(right)
}

infix operator ⋂= {}
func ⋂= <T : Comparable>( left: inout Set<T>, right: Set<T>) -> Set<T> {
    left.formIntersection(right)
    return left
}


extension Dictionary {
    init(_ array: [(Key,Value)]) {
        self.init()
        for v in array { self[v.0] = v.1 }
    }
}

/*
extension Array where Element == (key: K, value: V) {
    init<K,V>(_ dict: [K:V]) {
        self = []
        for v in dict { self.append((v.key, v.value)) }
    }
}
*/





















