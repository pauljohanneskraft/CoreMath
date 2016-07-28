//
//  GroupLike.swift
//  Math
//
//  Created by Paul Kraft on 16.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct GroupLike<Element where Element : Hashable, Element: Comparable> : SemigroupProtocol, Commutative {
    init(set: Set<Element>, op: (Element,Element) -> Element, neutralElement: Element? = nil, inv: ((Element) -> Element)? = nil, sign: Character = "•") {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.inv = inv
        self.sign = sign
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element?
    let inv : ((Element) -> Element)?
    let sign : Character
    
    var strictestType : Any?  {
        
        switch test() {
            
        case ( false , _     , _     , _     , _     ): return nil
            
        case ( true  , false , _     , _     , _     ): return try! Magma(self)
            
        case ( true  , true  , false , _     , _     ): return try! Semigroup(self)
            
        case ( true  , true  , true  , false , _     ): return try! Monoid(self)
            
        case ( true  , true  , true  , true  , false ): return try! Group(self)
            
        case ( true  , true  , true  , true  , true  ): return try! AbelianGroup(self)
            
        }
    }
    
    var possibleProtocols : (magma: Magma<Element>?, semigroup: Semigroup<Element>?, monoid: Monoid<Element>?, group: Group<Element>?, abelianGroup: AbelianGroup<Element>?)  {
        return (try? Magma(self), try? Semigroup(self), try? Monoid(self), try? Group(self), try? AbelianGroup(self))
    }
    
    func test() -> (closed: Bool, associative: Bool, neutralElement: Bool, invertible: Bool, commutative: Bool) {
        return (testClosure(), testAssociative(), testNeutralElement(), testInverse(), testCommutative())
    }
    
    func testNeutralElement() -> Bool {
        if neutralElement == nil { return false }
        for u in set { if !testNeutralElement(u) { return false } }
        return true
    }
    
    private func testNeutralElement(_ u: Element) -> Bool {
        return eq(op(u, neutralElement!), u)
    }
    
    func testInverse() -> Bool {
        if neutralElement == nil || inv == nil { return false }
        for u in set { if !testInverse(u) { return false } }
        return true
    }
    private func testInverse(_ u: Element) -> Bool {
        return eq(op(inv!(u), u), neutralElement!)
        // return (!u • u) == neutralElement
    }
}

struct Magma<Element where Element : Hashable, Element: Comparable> : MagmaProtocol {
    init(set: Set<Element>, op: (Element, Element) -> Element, sign: Character = "•") throws {
        self.set = set
        self.op = op
        self.sign = sign
        if test() != true {
            throw GroupLikeError.TypeNotMatching
        }
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.sign = groupLike.sign
        if test() != true {
            throw GroupLikeError.TypeNotMatching
        }
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    var eq : (Element, Element) -> Bool = { $0 == $1 }
    let sign : Character
}

struct Semigroup<Element where Element : Hashable, Element: Comparable> : SemigroupProtocol {
    init(set: Set<Element>, op: (Element, Element) -> Element, sign: Character = "•") throws {
        self.set = set
        self.op = op
        self.sign = sign
        if test() != (true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.sign = groupLike.sign
        if test() != (true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    var eq : (Element, Element) -> Bool = { $0 == $1 }
    let sign : Character
}

struct Monoid<Element where Element : Hashable, Element: Comparable> : MonoidProtocol {
    init(set: Set<Element>, op: (Element, Element) -> Element, neutralElement: Element, sign: Character = "•") throws {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.sign = sign
        if test() != (true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.neutralElement = groupLike.neutralElement!
        self.sign = groupLike.sign
        if test() != (true, true,true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element
    let sign : Character
}

struct Group<Element where Element : Hashable, Element: Comparable> : GroupProtocol {
    init(set: Set<Element>, op: (Element, Element) -> Element, neutralElement: Element, inv: (Element) -> Element, sign: Character = "•") throws {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.inv = inv
        self.sign = sign
        if test() != (true, true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.neutralElement = groupLike.neutralElement!
        self.inv = groupLike.inv!
        self.sign = groupLike.sign
        if test() != (true, true,true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element
    let inv : (Element) -> Element
    let sign : Character
}

struct AbelianGroup<Element where Element : Hashable, Element: Comparable> : AbelianGroupProtocol {
    init(set: Set<Element>, op: (Element, Element) -> Element, neutralElement: Element, inv: (Element) -> Element, sign: Character = "•") throws {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.inv = inv
        self.sign = sign
        if test() != (true, true, true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.neutralElement = groupLike.neutralElement!
        self.inv = groupLike.inv!
        self.sign = groupLike.sign
        if test() != (true, true,true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element
    let inv : (Element) -> Element
    let sign : Character
}













