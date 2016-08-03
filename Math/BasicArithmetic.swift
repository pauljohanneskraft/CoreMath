//
//  BasicArithmetic.swift
//  Math
//
//  Created by Paul Kraft on 03.08.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol BasicArithmetic : CustomStringConvertible, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Hashable, Comparable {
    init(integerLiteral: Int)
    init(floatLiteral: Double)
    
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
    
    static func += (lhs: inout Self, rhs: Self)
    static func -= (lhs: inout Self, rhs: Self)
    static func *= (lhs: inout Self, rhs: Self)
    static func /= (lhs: inout Self, rhs: Self)
    
    prefix static func - (lhs: Self) -> Self
}

extension BasicArithmetic {
    var abs    : Self { return self < 0 ? -self : self }
    var isZero : Bool { return abs <= 1e-14 }
}

extension BasicArithmetic {
    public var reducedDescription : String {
        if let s = self as? Double {
            if s.isNaN || s.isInfinite { return "\(s)" }
            if s > Double(Int.min) && s < Double(Int.max) {
                let si = Int(s)
                if (Double(si) - s).isZero { return "\(si)" }
            }
        }
        return self.description
    }
    
    func coefficientDescription(first: Bool) -> String {
        
        let n : Self
        var res = ""
        if !first { n = self.abs; res += self < 0 ? "- " : "+ " }
        else { n = self }
        
        switch n {
        case 0, 1:  return res
        case -1:    return "-"
        default:    return res + n.reducedDescription
        }
    }
}







