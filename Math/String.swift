//
//  String.swift
//  Math
//
//  Created by Paul Kraft on 29.04.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Cocoa

// implementation of the * operator on String and UInt to concatonate a String to itself multiple times
//
// @param   left    : UInt - how many times (-1) the string should be concatonated to itself ( 0 means "" )
// @param   right   : String - the string to concatonate
// @result          : String

func * (left: UInt, right: String) -> String {
    var res = right
    res *= left
    return res
}

// implementation of the * operator on String and UInt to concatonate a String to itself multiple times
//
// @param   right   : UInt - how many times (-1) the string should be concatonated to itself ( 0 means "" )
// @param   left    : String - the string to concatonate
// @result          : String

func * (left: String, right: UInt) -> String {
    var res = left
    res *= right
    return res
}

/*
 implementation of the *= operator on String and UInt to concatonate a String to itself multiple times and directly assigning it to the String
 
 - parameter right : UInt - how many times (-1) the string should be concatonated to itself
 
 - parameter left : String - the string to concatonate to itself, will be assigned to this variable (inout ;-) )
 
 - return String - the concatonated string
 
 */

func *= ( left: inout String, right: UInt) -> String {
    if right == 0 {
        left = ""
        return left
    }
    let orig = left
    if right < 5 {
        for _ in 1..<right {
            left += orig
        }
        return left
    }
    let half = right / 2
    let m = left * half
    left = m + m
    if (right & 1 == 1) {
        left += orig
    }
    return left
}

extension String {
    func to1337() -> String {
        var str = ""
        for var c in self.characters {
            switch c {
                case "a", "A":              c = "4"
                case "e", "E":              c = "3"
                case "i", "I", "j", "J":    c = "1"
                case "s", "S":              c = "5"
                case "G":                   c = "6"
                case "t", "T":              c = "7"
                case "b", "B":              c = "8"
                case "o", "O":              c = "0"
                case "g":                   c = "9"
                default:                    break
            }
            str += String(c)
        }
        return str
    }
    
    subscript(index: String.CharacterView.Index) -> Character {
        get { return self.characters[index] }
        set {
            var chars = self.characters
            chars.remove(at: index)
            chars.insert(newValue, at: index)
            self = String(chars)

        }
    }
    subscript(range: Range<String.CharacterView.Index>) -> String {
        @warn_unused_result get { return String(self.characters[range]) }
        set { self.characters.replaceSubrange(range, with: newValue.characters) }
    }
    
    func getIndex(_ v: Int) -> Index {
        var i = self.startIndex
        for _ in 0..<v {
            i = index(after: i)
        }
        return i
    }
    
    func getIndexRange(_ r: CountableRange<Int>) -> Range<Index> {
        let start = getIndex(r.lowerBound)
        var end = start
        let endRange = min(r.count - 1, self.characters.count - r.lowerBound - 1)
        guard endRange >= 0 else { return start..<start }
        for _ in 0...endRange { end = index(after: end) }
        return start..<end
    }
    
    
    subscript(index: Int) -> Character {
        @warn_unused_result get { return self[getIndex(index)]            }
                            set {        self[getIndex(index)] = newValue }
    }
    
    subscript(range: CountableRange<Int>) -> String {
        @warn_unused_result get { return self[getIndexRange(range)]            }
                            set {        self[getIndexRange(range)] = newValue }
    }

}

func +<T>(left: String, right: T) -> String {
    return "\(left)\(right)"
}

func +<T>(left: T, right: String) -> String {
    return "\(left)\(right)"
}











