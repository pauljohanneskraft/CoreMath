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

// implementation of the * operator on String and UInt to concatonate a String to itself multiple times
// and directly assigning it to the String
//
// @param           right   : UInt - how many times (-1) the string should be concatonated to itself ( 0 means "" )
// @param   inout   left    : String - the string to concatonate to itself, will be assigned to this variable (inout ;-) )
// @result                  : String - the concatonated string


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
        get { return String(self.characters[range]) }
        set {
            var chars = self.characters
            chars.replaceSubrange(range, with: newValue.characters)
            self = String(chars)
        }
    }
    
    func getIndex(_ v: Int) -> Index {
        var i = self.startIndex
        for _ in 0..<v {
            i = index(after: i)
        }
        return i
    }
    
    func getIndexRange(_ r: Range<Int>) -> Range<Index> {
        let start = getIndex(r.lowerBound)
        var end = start
        for _ in 0..<r.count-1 { end = index(after: end) }
        return start..<end
    }
    
    
    subscript(index: Int) -> Character {
        get {
            let index = getIndex(index)
            return self.characters[index]
        }
        set {
            let index = getIndex(index)
            var chars = self.characters
            chars.remove(at: index)
            chars.insert(newValue, at: index)
            self = String(chars)
            
        }
    }
    
    subscript(range: Range<Int>) -> String {
        get {
            let range = getIndexRange(range)
            return String(self.characters[range])
        }
        set {
            let range = getIndexRange(range)
            var chars = self.characters
            chars.replaceSubrange(range, with: newValue.characters)
            self = String(chars)
        }
    }

}

func +<T>(left: String, right: T) -> String {
    return "\(left)\(right)"
}

func +<T>(left: T, right: String) -> String {
    return "\(left)\(right)"
}











