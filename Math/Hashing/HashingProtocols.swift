//
//  HashingProtocols.swift
//  Math
//
//  Created by Paul Kraft on 22.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation


protocol HashTableType : ArrayLiteralConvertible {
    associatedtype Element : Hashable
    init()
    init(count: Int)
    var count : Int { get }
    var array : [Element] { get }
    func insert(element: Element) throws
    func insert(elements: Element...) throws
    func insert(elements: [Element]) throws
    func overwrite(element: Element) throws
    func executeForKey(element: Element, block: (Element) throws -> ()) throws
}