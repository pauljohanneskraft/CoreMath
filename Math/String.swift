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


func *= (inout left: String, right: UInt) -> String {
    let orig = left
    if right == 0 {
        left = ""
        return left
    }
    for _ in 1..<right {
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
}














