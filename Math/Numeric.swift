//
//  Numeric.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 04.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public protocol Numeric : BasicArithmetic, Randomizable {
    var integer : Int?   { get }
    var double : Double? { get }
    var sqrt : Self? { get }
    func power(_ v: Double) -> Self?
}

extension Numeric {
    public var sqrt : Self? {
        if let d = self.double {
            if d < 0 { return nil }
            return Self(floatLiteral: pow(d, 1.0/2))
        } else { return nil }
    }
    
    public func power(_ v: Double) -> Self? {
        if let d = self.double {
            if d < 0 && v < 1 { return nil }
            return Self(floatLiteral: pow(d, v))
        } else { return nil }
    }
}

extension Numeric {
    var isInteger : Bool {
        if let int = self.integer { return Self(integerLiteral: int) == self }
        return false
    }
}

extension Numeric {
    var primeFactors : [Int] {
        guard self.isInteger else { return [] }
        var this = self.integer!
        var i = 0
        var primes = Int.getPrimes(upTo: this)
        var factors = [Int]()
        while this > 1 {
            let p = primes[i]
            if this % p == 0 {
                this /= p
                factors.append(p)
            } else { i += 1 }
        }
        return factors
    }
    
    static func getPrimes(upTo: Int) -> [Int] {
        // print("did start", upTo)
        if upTo <= 1 { return [] }
        
        var candidate = 1
        var test      = 3
        var res       = [2]
        
        while candidate <= upTo {
            test = 3
            candidate += 2
            while candidate % test != 0 { test += 2 }
            if candidate == test { res.append(candidate) }
        }
        // print("did end", upTo)
        return res
    }
    
    static func getNextPrime(from: Int) -> Int {
        var candidate = from % 2 == 0 ? from : from - 1
        var test = 3
        while true {
            test = 3
            candidate += 2
            while candidate % test != 0 { test += 2 }
            if candidate == test { return candidate }
        }
    }
}

/*
prefix  operator | {}
postfix operator | {}

prefix  func | < N : Numeric > (elem: N) -> (f: (N) -> N, e: N) {
    return (f: { return $0.abs }, e: elem)
}
    
postfix func | < N : Numeric > ( t: (f: (N) -> N, e: N) ) -> N {
    return t.f(t.e)
}
*/

extension Complex where Number : Numeric {
    
    public var polarForm : (coefficient: Double, exponent: Double)? {
        let abs = self.abs.real
        if let di = imaginary.double, let dr = real.double {
            return (abs.double!, atan2(di, dr))
        }
        return nil
    }
    
    public func power(_ v: Double) -> Complex<Number>? {
        // if d < 0 && v < 1 { return nil }
        if var pF = self.polarForm {
            pF.coefficient = pF.coefficient.power(v)!
            pF.exponent = pF.exponent * v
            // print(pF)
            return Complex(polarForm: pF)
        }
        return nil
    }
}
