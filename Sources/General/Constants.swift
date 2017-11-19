//
//  Constants.swift
//  Math
//
//  Created by Paul Kraft on 14.05.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public enum Constants {
	
	/**
	The ratio of a circle's circumference to its diameter
	
	3.14159_26535
	*/
	public static let pi				= 3.14159_26535_89793_23846
	
	/**
	The ratio of a circle's circumference to its radius
	
	6.28318_53071 [ = 2 * pi ]
	*/
	public static let tau				= 2 * pi
	
	public enum Math {
		
		/**
		Euler's number
		
		2.71828_18284
		*/
		public static let e				= 2.71828_18284_59045_23536
		
		/// imaginary unit i
		public static let i				= C.i
		
		/**
		golden ratio

		1.61803_39887 [ = (1 + sqrt(5))/2 ]
		*/
		public static let goldenRatio	= (1 + sqrt(5))/2
		
		/**
		Euler-Mascheroni-Constant
		
		0.57721_56649
		*/
		public static let gamma			= 0.57721_56649_01532_86060_65120_90082_40243_10421_59335_93992
	}
	
	public enum Physics {
		
		/**
		magnetic constant

		1.25663_70614 e−6 N·A−2 [ = 4 · pi · 1e-7 ]
		*/
		public static let y_0			= (4*pi)*(1e-7)
		
		/**
		electrical constant 
		
		8.85418_78176 e−12 F·m−1 [ = 1 / ( y_0 · c · c ) ]
		*/
		public static let e_0			= 1/(y_0 * c * c)
		
		/**
		Planck's constant

		6.62607_004 e−34 J·s
		*/
		public static let h				= 6.626_070_040e-34
		
		/**
		Planck's reduced constant 
		
		1.05457_18001 e−34 J·s [ = h / 2*pi ]
		*/
		public static let h_			= h / (2 * pi)
		
		/**
		elementary charge
		
		1.60217_6620 e-19 C
		*/
		public static let e				= 1.602_176_620e-19
		
		/**
		Gravitational constant 
		
		6.67128_19039 e-11 N·m2·kg–2
		*/
		public static let G				= 6.671_281_903_963_040_991_511_534_289e-11
		
		/**
		Earth's acceleration at Marienplatz, Munich 
		
		9.80721_5 m·s-1

		source: http://gibs.bkg.bund.de/geoid/gscomp.php?p=s
		*/
		public static let g				= 9.807_215
		
		/**
		speed of light

		299_792_458.0 m·s-1
		*/
		public static let c				= 299_792_458.0
	}
	
}
