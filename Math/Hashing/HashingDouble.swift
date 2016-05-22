//
//  HashingDouble.swift
//  Math
//
//  Created by Paul Kraft on 22.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

protocol HashTableDoubleType : HashTableType {
    var h1 : (Element) -> Int { get }
    var h2 : (Element) -> Int { get }
}

extension HashTableDoubleType {
}


