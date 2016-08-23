# Math [![Build Status](https://travis-ci.org/pauljohanneskraft/Math.svg?branch=master)](https://travis-ci.org/pauljohanneskraft/Math)

## [Constants](Math/Constants.swift)

Easily access constants using the Constants-enum, e.g. 
```swift 
Constants.pi, Constants.e, Constants.tau
```

## Algebra

Math will also be offering simple structs to check if a certain operator on a set is a group, semigroup, etc with the possibility to return the strictest possible algebra type.

## Numbers

### Protocols

Numbers and other math constructs are separated into three categories:

- [BasicArithmetic](Math/BasicArithmetic.swift): operators +, -, *, /, +=, -=, *=, /=
- [Numeric](Math/Numeric.swift): being BasicArithmetic, having an integer, double, sqrt value, raising to a power is possible
- [AdvancedNumeric](Math/AdvancedNumeric.swift): being Numeric and remainder-calculation is possible

### [Complex](Math/Complex.swift)

Complex represents complex numbers and conforms to BasicArithmetic, but offers all the advantages of Numeric, if the generic type is Numeric. It is designed using a generic type for the real and imaginary part of the number. Operators such as +, -, *, /, +=, -=, *=, /= are also implemented.

```swift
let a : Complex<Int> = -4
print(a.sqrt)
// Prints "2i"
```

### [RationalNumber](Math/RationalNumber.swift)

RationalNumber uses two Int-values to represent a rational number (a fraction of two integers). RationalNumber implements AdvancedNumeric. For a cleaner look the typealias Q has also been coded.

```swift
let a = Q(1,2)
print(a)
// Prints "1/2"
```

### [Enhanced](Math/EnhancedNumber.swift)

Enhanced is a wrapper struct for e.g. Int to add Double-like behavior, when dividing by 0 etc. It offers additional cases like infinity or nan.

```swift
let a : Enhanced<Int> = 5
print(a / 0)
// Prints "∞"
```

## [TeX](Math/LaTeXConvertible.swift)

To implement the protocol LaTeXConvertible, a type needs to have one property:

```swift
public protocol LaTeXConvertible {
    var latex : String { get }
}
```

## LinearAlgebra

### [Matrix](Math/Matrix.swift)

The struct Matrix implements the most common matrix behavior, including ``` rank, rowEchelonForm, strictRowEchelon, inverse, determinant, eigenvalues, +, -, *, ==  ```.



