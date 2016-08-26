//
//  GroupLike.swift
//  Math
//
//  Created by Paul Kraft on 16.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

struct GroupLike<Element> : SemigroupProtocol, Commutative where Element : Hashable, Element: Comparable {
	init(set: Set<Element>, op: @escaping (Element,Element) -> Element, neutralElement: Element? = nil, inv: ((Element) -> Element)? = nil, sign: Character = "•") {
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
		if let o = AbelianGroup(self)   { return o }
		if let o = Group(self)          { return o }
		if let o = Monoid(self)         { return o }
		if let o = Semigroup(self)      { return o }
		if let o = Magma(self)          { return o }
		return nil
	}
	
	var possibleProtocols : (magma: Magma<Element>?, semigroup: Semigroup<Element>?, monoid: Monoid<Element>?, group: Group<Element>?, abelianGroup: AbelianGroup<Element>?)  {
		return (Magma(self), Semigroup(self), Monoid(self), Group(self), AbelianGroup(self))
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

struct Magma<Element> : MagmaProtocol where Element : Hashable, Element: Comparable {
	init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.sign = sign
		if test() != true { return nil }
	}
	init?(_ groupLike: GroupLike<Element>) {
		self.set = groupLike.set
		self.op = groupLike.op
		self.sign = groupLike.sign
		if test() != true { return nil }
	}
	let set : Set<Element>
	let op : (Element, Element) -> Element
	var eq : (Element, Element) -> Bool = { $0 == $1 }
	let sign : Character
}

struct Semigroup<Element> : SemigroupProtocol where Element : Hashable, Element: Comparable {
	init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.sign = sign
		if test() != (true, true) { return nil }
	}
	init?(_ groupLike: GroupLike<Element>) {
		self.set = groupLike.set
		self.op = groupLike.op
		self.sign = groupLike.sign
		if test() != (true, true) { return nil }
	}
	let set : Set<Element>
	let op : (Element, Element) -> Element
	var eq : (Element, Element) -> Bool = { $0 == $1 }
	let sign : Character
}

struct Monoid<Element> : MonoidProtocol where Element : Hashable, Element: Comparable {
	init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, neutralElement: Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.sign = sign
		if test() != (true, true, true) { return nil }
	}
	init?(_ groupLike: GroupLike<Element>) {
		self.set = groupLike.set
		self.op = groupLike.op
		self.neutralElement = groupLike.neutralElement!
		self.sign = groupLike.sign
		if test() != (true, true,true) { return nil }
	}
	let set : Set<Element>
	let op : (Element, Element) -> Element
	let eq : (Element, Element) -> Bool = { $0 == $1 }
	let neutralElement : Element
	let sign : Character
}

struct Group<Element> : GroupProtocol where Element : Hashable, Element: Comparable {
	init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, neutralElement: Element, inv: @escaping (Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.inv = inv
		self.sign = sign
		if test() != (true, true, true, true) { return nil }
	}
	init?(_ groupLike: GroupLike<Element>) {
		self.set = groupLike.set
		self.op = groupLike.op
		self.neutralElement = groupLike.neutralElement!
		self.inv = groupLike.inv!
		self.sign = groupLike.sign
		if test() != (true, true,true, true) { return nil }
	}
	let set : Set<Element>
	let op : (Element, Element) -> Element
	let eq : (Element, Element) -> Bool = { $0 == $1 }
	let neutralElement : Element
	let inv : (Element) -> Element
	let sign : Character
}

struct AbelianGroup<Element> : AbelianGroupProtocol where Element : Hashable, Element: Comparable {
	init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, neutralElement: Element, inv: @escaping (Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.inv = inv
		self.sign = sign
		if test() != (true, true, true, true, true) { return nil }
	}
	init?(_ groupLike: GroupLike<Element>) {
		self.set = groupLike.set
		self.op = groupLike.op
		self.neutralElement = groupLike.neutralElement!
		self.inv = groupLike.inv!
		self.sign = groupLike.sign
		if test() != (true, true,true, true, true) { return nil }
	}
	let set : Set<Element>
	let op : (Element, Element) -> Element
	let eq : (Element, Element) -> Bool = { $0 == $1 }
	let neutralElement : Element
	let inv : (Element) -> Element
	let sign : Character
}













