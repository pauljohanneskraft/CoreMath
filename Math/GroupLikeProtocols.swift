//
//  GroupLikeProtocols.swift
//  Math
//
//  Created by Paul Kraft on 15.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//


protocol MagmaProtocol : CustomStringConvertible {
	associatedtype Element : Hashable, Equatable, Comparable
	var set : Set<Element> { get }
	var op : (Element, Element) -> Element { get }
	var sign : Character { get }
	var eq : (Element, Element) -> Bool { get }
	var description : String { get }
}

extension MagmaProtocol {
	var description: String {
		return "\(Self.self) ⟨ \(set.sorted()), \(sign) ⟩"
	}
	func test() -> Bool {
		return testClosure()
	}
	
	func testClosure() -> Bool {
		for u in set { for v in set { if !testClosure(u,v) { return false } } }
		return true
	}
	
	func testClosure(_ u: Element, _ v: Element) -> Bool {
		return set.contains(op(u,v))
	}
}


/*
func == <T: MagmaProtocol>(left: T.Element, right: T.Element) -> Bool { return T.eq(left, right) }

infix operator • {}
func • <T: MagmaProtocol>(left: T.Element, right: T.Element) -> T.Element { return T.op(left, right) }
*/

internal protocol Commutative : MagmaProtocol {}
extension Commutative {
	func testCommutative() -> Bool {
		for u in set { for v in set { if !testCommutative(u,v) { return false } } }
		// \forall u,v \in Set : (u • v) = (v • u)
		return true
	}
	func testCommutative(_ u: Element, _ v: Element) -> Bool {
		let a = op(v,u)
		let b = op(u,v)
		return eq(a, b)
	}
}

internal protocol hasNeutralElement : MagmaProtocol {
	var neutralElement : Element { get }
}

extension hasNeutralElement {
	func testNeutralElement() -> Bool {
		for u in set { if !testNeutralElement(u) { return false } }
		return true
	}
	func testNeutralElement(_ u: Element) -> Bool {
		return eq(op(u, neutralElement), u)
	}
}

// prefix func ! <T: Invertible> (element: T.Element) -> T.Element { return T.inverse(element) }

internal protocol Invertible : MagmaProtocol, hasNeutralElement {
	var inv : (Element) -> Element { get }
}

extension Invertible {
	func testInverse() -> Bool {
		for u in set { if !testInverse(u) { return false } }
		return true
	}
	func testInverse(_ u: Element) -> Bool {
		return eq(op(inv(u), u), neutralElement)
		// return (!u • u) == neutralElement
	}
}

internal protocol Idempotent : MagmaProtocol {}
extension Idempotent {  // • is idempotent
	func testIdempotent() -> Bool {
		for u in set { if !testIdempotent(u) { return false } }
		return true
	}
	func testIdempotent(_ u: Element) -> Bool {
		return eq(op(u,u), u)     // return (u • u) == u
	}
}

internal protocol Associative : MagmaProtocol {}

extension Associative {
	func testAssociative() -> Bool {
		for u in set { for v in set { for w in set { if !testAssociative(u,v,w) { return false } } } }
		// \forall u,v,w \in Set : ((u • v) • w) = (u • (v • w))
		return true
	}
	func testAssociative(_ u: Element, _ v: Element, _ w: Element) -> Bool {
		return eq(op(op(u,v), w), op(u, op(v,w))) // return ((u • v) • w) == (u • (v • w))
	}
}

protocol SemigroupProtocol : MagmaProtocol, Associative {}
extension SemigroupProtocol {
	func test() -> (closed: Bool, associative: Bool) {
		return (testClosure(), testAssociative())
	}
}

protocol MonoidProtocol : SemigroupProtocol, hasNeutralElement {}
extension MonoidProtocol {
	func test() -> (closed: Bool, associative: Bool, neutralElement: Bool) {
		return (testClosure(), testAssociative(), testNeutralElement())
	}
}

protocol GroupProtocol : MonoidProtocol, Invertible {}
extension GroupProtocol {
	func test() -> (closed: Bool, associative: Bool, neutralElement: Bool, invertible: Bool) {
		return (testClosure(), testAssociative(), testNeutralElement(), testInverse())
	}
}

protocol AbelianGroupProtocol : GroupProtocol, Commutative {}
extension AbelianGroupProtocol {
	func test() -> (closed: Bool, associative: Bool, neutralElement: Bool, invertible: Bool, commutative: Bool) {
		return (testClosure(), testAssociative(), testNeutralElement(), testInverse(), testCommutative())
	}
}

protocol SemilatticeProtocol  : SemigroupProtocol, Commutative, Idempotent {}
extension SemilatticeProtocol {
	func test() -> (closed: Bool, associative: Bool, commutative: Bool, idempotent: Bool) {
		return (testClosure(), testAssociative(), testCommutative(), testIdempotent())
	}
}

protocol LatinSquareRule {}
// Latin Square Rule
// Each element of the set occurs exactly once in each row and exactly once in each column of the quasigroup's multiplication table

protocol QuasiGroupProtocol : MagmaProtocol, LatinSquareRule {}
extension QuasiGroupProtocol {}

protocol LoopProtocol : QuasiGroupProtocol, hasNeutralElement {}







