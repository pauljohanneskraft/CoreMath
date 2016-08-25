# Math [![Build Status](https://travis-ci.org/pauljohanneskraft/Math.svg?branch=master)](https://travis-ci.org/pauljohanneskraft/Math)

## [Constants](https://github.com/pauljohanneskraft/Math/tree/master/Math/Constants.swift)

Easily access constants using the Constants-enum, e.g. 
```swift 
Constants.pi, Constants.e, Constants.tau
```

## Algebra

Math will also be offering simple structs to check if a certain operator on a set is a group, semigroup, etc with the possibility to return the strictest possible algebra type.

## Numbers

### Protocols

Numbers and other math constructs are separated into three categories:

- [BasicArithmetic](https://github.com/pauljohanneskraft/Math/tree/master/Math/BasicArithmetic.swift): operators +, -, *, /, +=, -=, *=, /=
- [Numeric](https://github.com/pauljohanneskraft/Math/tree/master/Math/Numeric.swift): being BasicArithmetic, having an integer, double, sqrt value, raising to a power is possible
- [AdvancedNumeric](https://github.com/pauljohanneskraft/Math/tree/master/Math/AdvancedNumeric.swift): being Numeric and remainder-calculation is possible

### [Complex Numbers](https://github.com/pauljohanneskraft/Math/tree/master/Math/Complex.swift)

Complex represents complex numbers and conforms to BasicArithmetic, but offers all the advantages of Numeric, if the generic type is Numeric. It is designed using a generic type for the real and imaginary part of the number. Operators such as +, -, *, /, +=, -=, *=, /= are also implemented.

```swift
let a : Complex<Int> = -4
print(a.sqrt)
// Prints "2i"
```

### [Rational Numbers](https://github.com/pauljohanneskraft/Math/tree/master/Math/RationalNumber.swift)

RationalNumber uses two Int-values to represent a rational number (a fraction of two integers). RationalNumber implements AdvancedNumeric. For a cleaner look the typealias Q has also been coded.

```swift
let a = Q(1,2)
print(a)
// Prints "1/2"
```

### [Enhanced Numbers](https://github.com/pauljohanneskraft/Math/tree/master/Math/EnhancedNumber.swift)

Enhanced is a wrapper struct for e.g. Int to add Double-like behavior, when dividing by 0 etc. It offers additional cases like infinity or nan.

```swift
let a : Enhanced<Int> = 5
print(a / 0)
// Prints "∞"
```

## [TeX](https://github.com/pauljohanneskraft/Math/tree/master/Math/LaTeXConvertible.swift)

To implement the protocol LaTeXConvertible, a type needs to have one property:

```swift
public protocol LaTeXConvertible {
    var latex : String { get }
}
```

## [Functions](https://github.com/pauljohanneskraft/Math/tree/master/Math/Function.swift)

Function is a protocol that tries to combine all functions that are imaginable in math, e.g. ```x^5 + x^3```, ```sin(x)```, ```cos(x)```, etc.
They can all be reduced, e.g. a Term with only one factor returns the factor and therefore keeps the function as simple as possible. It is planned that for all Functions a derivate and an integral is available.

### [Term](https://github.com/pauljohanneskraft/Math/tree/master/Math/Term.swift)

A Term is a product of functions, which is implemented in the Term-struct.

### [Equation](https://github.com/pauljohanneskraft/Math/tree/master/Math/Equation.swift)

The Equation-struct represents a sum of terms or more simply other functions, e.g. ```sin(x)*5 + x^5``` with ```sin(x), 5, x^5``` being Functions not tied into Term/Equation, ```sin(x)*5``` being a Term with ```Term(sin(x), 5)``` and in total being an Equation ```Equation(Term(sin(x), 5), x^5)```.

### [Fraction](https://github.com/pauljohanneskraft/Math/tree/master/Math/Fraction.swift)

Fraction represents a division of functions, e.g. ```sin(x)/tan(x)```.

### [Custom Functions](https://github.com/pauljohanneskraft/Math/tree/master/Math/CustomFunction.swift)

Currently the [Trigonometric Functions](https://github.com/pauljohanneskraft/Math/tree/master/Math/TrigonometricFunctions.swift) sine and cosine are supported.

### [Constant Functions](https://github.com/pauljohanneskraft/Math/tree/master/Math/ConstantFunction.swift)

Constant Functions (e.g. f(x) = 5) are also supported an can (in a [Term](https://github.com/pauljohanneskraft/Math/tree/master/Math/Term.swift)) also be used as a coefficient, e.g.:

```swift
let a = (x^2) * 3
print(a.debugDescription)
// Prints "Term(3, x^2)"
```

### [Exponential Functions](https://github.com/pauljohanneskraft/Math/tree/master/Math/ExponentialFunction.swift) 

Exponential Factors in the form of b^x with b being a Double-value are also currently supported and can be created as follows:

```swift
let a = 5^x
```

## LinearAlgebra

### [Matrix](https://github.com/pauljohanneskraft/Math/tree/master/Math/Matrix.swift)

The struct Matrix implements the most common matrix behavior, including ``` rank, rowEchelonForm, strictRowEchelon, inverse, determinant, eigenvalues, +, -, *, ==  ```.



