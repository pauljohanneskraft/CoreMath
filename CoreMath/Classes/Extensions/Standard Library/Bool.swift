//
//  Bool.swift
//  Math
//
//  Created by Paul Kraft on 21.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

extension Bool {
    public static func random() -> Bool {
        return CoreMath.random() % 2 == 0
    }
}
