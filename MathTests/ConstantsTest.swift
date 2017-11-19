//
//  ConstantsTest.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import XCTest
import Math

class ConstantsTest: XCTestCase {
    
    static var allTests: [(String, (ConstantsTest) -> () throws -> Void )] {
        return [
            ("testEverything", testEverything)
        ]
    }
	
	func testEverything() {
		print("pi:         ", Constants.pi)
		XCTAssert(Constants.pi == Double.pi)
		print("-----------------------------------------------------")
		print("tau:        ", Constants.tau)
		XCTAssert(Constants.tau == Double.pi * 2)
		print("-----------------------------------------------------")
		print("e:          ", Constants.Math.e)
		print("-----------------------------------------------------")
		print("gamma:      ", Constants.Math.gamma)
		print("-----------------------------------------------------")
		print("i:          ", Constants.Math.i)
		print("-----------------------------------------------------")
		print("goldenRatio:", Constants.Math.goldenRatio)
		print("-----------------------------------------------------")
		print("c:          ", Constants.Physics.c)
		print("-----------------------------------------------------")
		print("e:          ", Constants.Physics.e)
		print("-----------------------------------------------------")
		print("G:          ", Constants.Physics.G)
		print("-----------------------------------------------------")
		print("h:          ", Constants.Physics.h)
		print("-----------------------------------------------------")
		print("e_0:        ", Constants.Physics.e_0)
		print("-----------------------------------------------------")
		print("h_:         ", Constants.Physics.h_)
		print("-----------------------------------------------------")
		print("y_0:        ", Constants.Physics.y_0)
		print("-----------------------------------------------------")
		print("g:          ", Constants.Physics.g)
		// 
	}
    
    func testPiUsingCoprimes() {
        
        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a
            var b = b
            while a != b {
                if a > b { a -= b } else { b -= a }
            }
            return a
        }
        
        var coprimes = 0
        var cofactor = 0
        
        var count    = 0
        
        var pi       = 3.14
        
        let inner = 0..<1000
        let outer = 0..<20
        
        let sqrt6 = sqrt(6.0)
        
        for _ in outer {
            
            for _ in inner {
                let a = Int(arc4random())
                let b = Int(arc4random())
                
                if gcd(a, b) > 1 { cofactor += 1 } else { coprimes += 1 }
            }
            count += inner.endIndex
            pi = sqrt6/sqrt(Double(coprimes)/Double(count))
            print("After", count, "iterations, pi is", pi)
            guard pi != Constants.pi else { print("FOUND IT! \(pi)"); return }
        }
        
    }
}
