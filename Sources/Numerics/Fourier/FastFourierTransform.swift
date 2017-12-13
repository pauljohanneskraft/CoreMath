//
//  FastFourierTransform.swift
//  Math
//
//  Created by Paul Kraft on 24.11.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension Array where Element: Numeric & ComplexConvertible {
    public typealias Number = Element.Number
    
    public var discreteFourierTransform: [Complex<Number>] {
        let count = self.count, indices = self.indices
        let omega = Complex<Number>(coefficient: 1.0, exponent: -2 * Double.pi / count.double)
        
        return indices.map { i in
            let omegaI = omega.power(i.double)
            return indices.reduce(into: 0) { acc, j in
                acc += omegaI.power(j.double) * self[j].complex
            }
        }
    }
    
    private func fastFourierTransform(omega: Complex<Number>) -> [Complex<Number>] {
        let count = self.count
        guard count > 1 else {
            return map { $0.complex }
        }
        
        var v = [Complex<Number>](repeating: 0, count: count)
        
        let m = count >> 1
        let omega2 = omega.power(2)
        let (even, odd) = butterfly()
        let z1 = even.fastFourierTransform(omega: omega2)
        let z2 = odd.fastFourierTransform(omega: omega2)
        
        for j in 0..<m {
            let complex = omega.power(Double(j)) * z2[j]
            v[j] = z1[j] + complex
            v[m+j] = z1[j] - complex
        }
        
        return v
    }
    
    public var fastFourierTransform: [Complex<Number>] {
        let omega = Complex<Number>(coefficient: 1, exponent: -2 * Double.pi / count.double)
        return fastFourierTransform(omega: omega)
    }
    
    public var fastInverseFourierTransform: [Complex<Number>] {
        let count = self.count
        let omega = Complex<Number>(coefficient: 1, exponent: 2 * Double.pi / count.double)
        return fastFourierTransform(omega: omega).map { $0 / Complex(count) }
    }
}

extension Collection where Index == Int, IndexDistance == Index {
    fileprivate func butterfly() -> (even: [Element], odd: [Element]) {
        let count = self.count
        let even = stride(from: 0, to: count, by: 2).map { self[$0] }
        let odd = stride(from: 1, to: count, by: 2).map { self[$0] }
        return (even, odd)
    }
}
