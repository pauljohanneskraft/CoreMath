//
//  TrigonometricFunction.swift
//  Math
//
//  Created by Paul Kraft on 13.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension TrigonometricFunction {
    public enum Kind {
        case sin, sinh
        case cos, cosh
        
        public var function: (Double) -> Double {
            switch self {
            case .sin:
                return Darwin.sin
            case .cos:
                return Darwin.cos
            case .sinh:
                return Darwin.sinh
            case .cosh:
                return Darwin.cosh
            }
        }
        
        var integral: (sign: Bool, kind: Kind) {
            switch self {
            case .sin:
                return (true, .cos)
            case .cos:
                return (false, .sin)
            case .sinh:
                return (false, .cosh)
            case .cosh:
                return (false, .sinh)
            }
        }
        
        var derivative: (sign: Bool, kind: Kind) {
            switch self {
            case .sin:
                return (false, .cos)
            case .cos:
                return (true, .sin)
            case .sinh:
                return (false, .cosh)
            case .cosh:
                return (false, .sinh)
            }
        }
        
        func call(content: Double) -> Double {
            return self.function(content)
        }
    }
}

public struct TrigonometricFunction {
    public var content: Function
    public var kind: Kind
    
    public init(content: Function, kind: Kind) {
        self.content = content
        self.kind = kind
    }
}

extension TrigonometricFunction: Function {
    public var integral: Function {
        let (sign, int) = kind.integral
        return (sign ? -1 : 1.0) * TrigonometricFunction(content: content, kind: int) / content.derivative
    }
    
    public var derivative: Function {
        let (sign, der) = kind.derivative
        return (sign ? -1 : 1.0) * TrigonometricFunction(content: content, kind: der) * content.derivative
    }
    
    public var reduced: Function {
        return self
    }
    
    public func call(x: Double) -> Double {
        let c = content.call(x: x)
        return kind.call(content: c)
    }
    
    public func equals(to: Function) -> Bool {
        guard let other = to as? TrigonometricFunction else { return false }
        return other.kind == kind && other.content == content
    }
}

extension TrigonometricFunction: CustomStringConvertible {
    public var description: String {
        return "\(kind)(\(content))"
    }
}
