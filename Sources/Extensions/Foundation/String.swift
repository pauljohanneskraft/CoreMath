//
//  String.swift
//  Math
//
//  Created by Paul Kraft on 09.12.17.
//  Copyright © 2017 pauljohanneskraft. All rights reserved.
//

import Foundation

extension String {
    public var isUppercase: Bool {
        return uppercased() == self
    }
    
    public func splitCamelCase() -> String {
        let indexRanges = indices.split(whereSeparator: { self[$0].isUppercase })
        let strings = indexRanges.map { range -> Substring in
            guard range.startIndex > self.startIndex else {
                return self[..<range.endIndex]
            }
            return self[index(before: range.startIndex)..<range.endIndex]
        }
        return strings.joined(separator: " ")
    }
}
