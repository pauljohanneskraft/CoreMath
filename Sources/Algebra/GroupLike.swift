//
//  GroupLike.swift
//  Math
//
//  Created by Paul Kraft on 16.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation
/*
public struct GroupLike<Element> : SemigroupProtocol, Commutative where Element : Hashable, Element: Comparable {
	public init(set: Set<Element>, op: @escaping (Element,Element) -> Element, neutralElement: Element? = nil, inv: ((Element) -> Element)? = nil, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.inv = inv
		self.sign = sign
	}
	public let set : Set<Element>
	public let op : (Element, Element) -> Element
	public let eq : (Element, Element) -> Bool = { $0 == $1 }
	let neutralElement : Element?
	let inv : ((Element) -> Element)?
	public let sign : Character
	
	public var strictestType : Any?  {
		if let o = AbelianGroup(self)   { return o }
		if let o = Group(self)          { return o }
		if let o = Monoid(self)         { return o }
		if let o = Semigroup(self)      { return o }
		if let o = Magma(self)          { return o }
		return nil
	}
	
	public var possibleTypes : (magma: Magma<Element>?, semigroup: Semigroup<Element>?, monoid: Monoid<Element>?, group: Group<Element>?, abelianGroup: AbelianGroup<Element>?)  {
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

public struct Magma<Element> : MagmaProtocol where Element : Hashable, Element: Comparable {
	public init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.sign = sign
		if test() != true { return nil }
	}
	public init?(_ groupLike: GroupLike<Element>) {
		self.init(set: groupLike.set, op: groupLike.op, sign: groupLike.sign)
	}
	public let set : Set<Element>
	public let op : (Element, Element) -> Element
	public var eq : (Element, Element) -> Bool = { $0 == $1 }
	public let sign : Character
}

public struct Semigroup<Element> : SemigroupProtocol where Element : Hashable, Element: Comparable {
	public init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.sign = sign
		if test() != (true, true) { return nil }
	}
	public init?(_ groupLike: GroupLike<Element>) {
		self.init(set: groupLike.set, op: groupLike.op, sign: groupLike.sign)
	}
	public let set : Set<Element>
	public let op : (Element, Element) -> Element
	public var eq : (Element, Element) -> Bool = { $0 == $1 }
	public let sign : Character
}

public struct Monoid<Element> : MonoidProtocol where Element : Hashable, Element: Comparable {
	public init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, neutralElement: Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.sign = sign
		if test() != (true, true, true) { return nil }
	}
	public init?(_ groupLike: GroupLike<Element>) {
		if let neutralElement = groupLike.neutralElement {
			self.init(set: groupLike.set, op: groupLike.op, neutralElement: neutralElement, sign: groupLike.sign)
		} else { return nil }
	}
	public let set : Set<Element>
	public let op : (Element, Element) -> Element
	public let eq : (Element, Element) -> Bool = { $0 == $1 }
	public let neutralElement : Element
	public let sign : Character
}

public struct Group<Element> : GroupProtocol where Element : Hashable, Element: Comparable {
	public init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, neutralElement: Element, inv: @escaping (Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.inv = inv
		self.sign = sign
		if test() != (true, true, true, true) { return nil }
	}
	public init?(_ groupLike: GroupLike<Element>) {
		if let neutralElement = groupLike.neutralElement, let inv = groupLike.inv {
			self.init(set: groupLike.set, op: groupLike.op, neutralElement: neutralElement, inv: inv, sign: groupLike.sign)
		} else { return nil }
	}
	public let set : Set<Element>
	public let op : (Element, Element) -> Element
	public let eq : (Element, Element) -> Bool = { $0 == $1 }
	public let neutralElement : Element
	public let inv : (Element) -> Element
	public let sign : Character
}

public struct AbelianGroup<Element> : AbelianGroupProtocol where Element : Hashable, Element: Comparable {
	public init?(set: Set<Element>, op: @escaping (Element, Element) -> Element, neutralElement: Element, inv: @escaping (Element) -> Element, sign: Character = "•") {
		self.set = set
		self.op = op
		self.neutralElement = neutralElement
		self.inv = inv
		self.sign = sign
		if test() != (true, true, true, true, true) { return nil }
	}
	public init?(_ groupLike: GroupLike<Element>) {
		if let neutralElement = groupLike.neutralElement, let inv = groupLike.inv {
			self.init(set: groupLike.set, op: groupLike.op, neutralElement: neutralElement, inv: inv, sign: groupLike.sign)
		} else { return nil }
	}
	public let set : Set<Element>
	public let op : (Element, Element) -> Element
	public let eq : (Element, Element) -> Bool = { $0 == $1 }
	public let neutralElement : Element
	public let inv : (Element) -> Element
	public let sign : Character
}
*/












