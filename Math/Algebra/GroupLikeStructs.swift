//
//  GroupLikeStructs.swift
//  Math
//
//  Created by Paul Kraft on 16.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation


struct Magma<Element where Element: Hashable, Element : Comparable> : MagmaType {
    init(set: Set<Element>, op: (Element,Element) -> Element) {
        self.set = set
        self.op = op
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { return $0 == $1 }
    let sign : Character? = nil
}

struct Group<Element where Element: Hashable, Element : Comparable> : GroupType {
    init(set: Set<Element>, op: (Element,Element) -> Element, neutralElement: Element, inv: Element -> Element) {
        self.set = set
        self.op = op
        self.neutralElement = neutralElement
        self.inv = inv
    }
    let set : Set<Element>
    let op : (Element, Element) -> Element
    let eq : (Element, Element) -> Bool = { return $0 == $1 }
    let neutralElement : Element
    let inv : Element -> Element
    let sign : Character? = "+"
}























