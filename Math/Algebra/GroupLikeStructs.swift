//
//  GroupLikeStructs.swift
//  Math
//
//  Created by Paul Kraft on 16.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct GroupLike<Element where Element: Hashable, Element : Comparable> : SemigroupType, Commutative {
    init(set: Set<Element>, op: (Element,Element) -> Element, neutralElement: Element? = nil, inv: ((Element) -> Element)? = nil) {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.inv = inv
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element?
    let inv : ((Element) -> Element)?
    let sign : Character? = "+"
    
    var strictestType : Any?  {
        
        switch test() {
            
        case ( false , _     , _     , _     , _     ): return nil
            
        case ( true  , false , _     , _     , _     ): return try? Magma(self)
            
        case ( true  , true  , false , _     , _     ): return try? Semigroup(self)
            
        case ( true  , true  , true  , false , _     ): return try? Monoid(self)
            
        case ( true  , true  , true  , true  , false ): return try? Group(self)
            
        case ( true  , true  , true  , true  , true  ): return try? AbelianGroup(self)
            
        }
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

struct Magma<Element where Element : Hashable, Element : Comparable> : MagmaType {
    init(set: Set<Element>, op: (Element, Element) -> Element, sign: Character? = nil) throws {
        self.set = set
        self.op = op
        if test() != true {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = sign
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        if test() != true {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = groupLike.sign
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    var eq : (Element, Element) -> Bool = { $0 == $1 }
    var sign : Character?
}

struct Semigroup<Element where Element : Hashable, Element : Comparable> : SemigroupType {
    init(set: Set<Element>, op: (Element, Element) -> Element, sign: Character? = nil) throws {
        self.set = set
        self.op = op
        if test() != (true, true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = sign
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        if test() != (true, true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = groupLike.sign
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    var eq : (Element, Element) -> Bool = { $0 == $1 }
    var sign : Character?
}

struct Monoid<Element where Element : Hashable, Element : Comparable> : MonoidType {
    init(set: Set<Element>, op: (Element, Element) -> Element, neutralElement: Element, sign: Character? = nil) throws {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        if test() != (true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = sign
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.neutralElement = groupLike.neutralElement!
        if test() != (true, true,true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = groupLike.sign
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element
    var sign : Character?
}

struct Group<Element where Element : Hashable, Element : Comparable> : GroupType {
    init(set: Set<Element>, op: (Element, Element) -> Element, neutralElement: Element, inv: (Element) -> Element, sign: Character? = nil) throws {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.inv = inv
        if test() != (true, true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = sign
    }
    init(_ groupLike: GroupLike<Element>) throws {
        self.set = groupLike.set
        self.op = groupLike.op
        self.neutralElement = groupLike.neutralElement!
        self.inv = groupLike.inv!
        if test() != (true, true,true, true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = groupLike.sign
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element
    let inv : (Element) -> Element
    var sign : Character?
}

struct AbelianGroup<Element where Element : Hashable, Element : Comparable> : AbelianGroupType {
    init(set: Set<Element>, op: (Element, Element) -> Element, neutralElement: Element, inv: (Element) -> Element, sign: Character? = nil) throws {
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
        if test() != (true, true,true, true, true) {
            throw GroupLikeError.TypeNotMatching
        }
        self.sign = groupLike.sign
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { $0 == $1 }
    let neutralElement : Element
    let inv : (Element) -> Element
    var sign : Character?
}













