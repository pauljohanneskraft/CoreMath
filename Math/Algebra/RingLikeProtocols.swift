//
//  RingLikeProtocols.swift
//  Math
//
//  Created by Paul Kraft on 16.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

/*
infix operator ⨁ {}
func ⨁ <T: RingType>(left: T.Element0, right: T.Element0) -> T.Element0 { return T.op0(left, right) }

infix operator ⨂ {}
func ⨂ <T: RingType>(left: T.Element1, right: T.Element1) -> T.Element1 { return T.op1(left, right) }
*/

internal protocol AbelianGroup0 : AbelianGroupType { // definition of an AbelianGroup to use for
    associatedtype Element0 : Hashable, Comparable
    // ⟨F, ⨁⟩
    // ⨁ is associative, commutative
    var set0 : Set<Element0> { get }
    var neutralElement0 : Element0 { get }
    var op0 : (Element0, Element0) -> Element0 { get }
    var inverse0 : (Element0) -> Element0 { get }
}

internal protocol Monoid1 {
    associatedtype Element1 : Hashable, Comparable
    // ⟨F \ {0}, ⨂⟩
    // ⨂ is associative
    var set1 : Set<Element1> { get }
    var op1 : (Element1, Element1) -> Element1 { get } // ⨂
    var neutralElement1 : Element1 { get }
}

internal protocol AbelianGroup1 : Monoid1 {
    // ⟨F \ {0}, ⨂⟩
    // ⨂ is commutative
    var inverse1 : Self { get }
}

protocol FieldType : RingType, AbelianGroup1 {
    // ⟨F, ⨁⟩                   is an AbelianGroup  -> AbelianGroup0
    // ⟨F \ { neutralElement0 }, ⨂⟩   is an AbelianGroup  -> AbelianGroup1
    // a ⨂ ( b ⨁ c ) = ( a ⨂ b ) ⨁ ( a ⨂ c )
    // ( a ⨁ b ) ⨂ c ) = ( a ⨂ c ) ⨁ ( b ⨂ c )
}

protocol RingType : AbelianGroup0, Monoid1 {
    // ⟨F, ⨁⟩                   is an AbelianGroup  -> AbelianGroup0
    // ⟨F \ { neutralElement0 }, ⨂⟩   is a Monoid         -> Monoid1
    // a ⨂ ( b ⨁ c ) = ( a ⨂ b ) ⨁ ( a ⨂ c )
    // ( a ⨁ b ) ⨂ c ) = ( a ⨂ c ) ⨁ ( b ⨂ c )
}

extension RingType where Element0 == Element1 {
    //T.ODO func homomorph<T : Ring where T.Element0 == Self.Element0, T.Element1 == Self.Element1>(other: T, f: Element0 -> Element0) {}
    func isRing() -> Bool {
        if (set0.count - 1) != (set1.count) { return false }
        var one = 0
        for v in set0 { if !set1.contains(v) { if one == 1 { return false } else { one = 1 } } }
        
        for u in set0 {
            for v in set0 {
                if !commutativeAddition(u,v)            { return false }
                for w in set0 {
                    if !associativeAddition(u,v,w)          { return false }
                    if !associativeMultiplication(u,v,w)    { return false }
                    if !rightDistributive(u,v,w)            { return false }
                    if !leftDistributive(u,v,w)             { return false }
                }
            }
        }
        return true
    }
    
    private func associativeAddition(_ u: Element0, _ v: Element0, _ w: Element0) -> Bool {
        // if ((u ⨁ v) ⨁ w) != (u ⨁ (v ⨁ w)) { return false }
        return true
    }
    
    private func commutativeAddition(_ u: Element0, _ v: Element0) -> Bool {
        // if (u ⨁ v) != (v ⨁ u) { return false }                   // ⨁ is commutative
        return true
    }
    
    private func associativeMultiplication(_ u: Element0, _ v: Element0, _ w: Element0) -> Bool {
        // if ((u ⨂ v) ⨂ w) != (u ⨂ (v ⨂ w)) { return false }      // ⨂ is associative
        return true
    }
    
    private func leftDistributive(_ u: Element0, _ v: Element0, _ w: Element0) -> Bool {
        // if (u ⨂ (v ⨁ w)) != (u ⨂ v) ⨁ (u ⨂ w) { return false } // ⨂ is  left-distributive over ⨁
        return true
    }
    
    private func rightDistributive(_ u: Element0, _ v: Element0, _ w: Element0) -> Bool {
        // if ((u ⨁ v) ⨂ w) != (u ⨂ v) ⨁ (v ⨂ w) { return false } // ⨂ is right-distributive over ⨁
        return true
    }
    
}

/*
protocol RngType {}
protocol SemiringType {}
protocol NearRingType {}
protocol CommutativeRingType {}
protocol DomainType {}
protocol IntegralDomainType {}
protocol DivisionRingType {}
protocol LatticeType {}
protocol ModuleType {}
protocol GroupWithOperatorsType {}
protocol VectorSpaceType {}
protocol AlgebraType {}
protocol AssociativeAlgebraType {}
protocol NonAssociativeAlgebraType {}
protocol LieAlgebraType {}
protocol GradedAlgebraType {}
protocol BialgebraType {}
*/