//
//  ModuleLikeProtocols.swift
//  Math
//
//  Created by Paul Kraft on 20.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

/*
protocol SubVectorSpaceType {
    associatedtype Element
    var set : [[Element]] { get }
    var scalars : [Element] { get }
    var con : ([Element]) -> Bool { get }
    var add : ([Element], [Element]) -> [Element] { get }
    var mul : (Element, [Element]) -> [Element] { get }
}
extension SubVectorSpaceType where Element : NumericType {
    func test() -> Bool {
        return (testNullVector(), testAdditionClosure(), testScalarMultiplicationClosure()) == (true, true, true)
    }
    func testNullVector() -> Bool {
        return con([Element](repeating: Element(0), count: set.count))
    }
    func testAdditionClosure() -> Bool {
        for u in set { for v in set { if !con(add(u,v)) { return false } } }
        return true
    }
    func testScalarMultiplicationClosure() -> Bool {
        for s in scalars { for v in set { if !con(mul(s, v)) { return false } } }
        return true
    }
}
*/



