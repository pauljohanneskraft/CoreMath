//
//  TrigonometricFunctions.swift
//  Math
//
//  Created by Paul Kraft on 29.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

import Foundation

public enum Trigonometric {
	public static let sin = sine
	public static let cos = cosine
}

private let sine: CustomFunction = CustomFunction("sin(x)",
                                                      function: { return sin($0)	},
                                                      integral: { return -cosine	},
                                                      derivative: { return cosine		})

private let cosine: CustomFunction = CustomFunction("cos(x)",
                                                      function: { return cos($0)	},
                                                      integral: { return sine		},
                                                      derivative: { return -sine		})
