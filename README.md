# Math

A try to extend Swift with more advanced (mostly mathematical) operations and functions.

## Features

### General

operators
  <-> : swapping two elements of the same type (short for: (a,b) = (b,a) )

### NumericType

NumericType is a protocol used to unite all numeric types.
By extending the specific numeric types with this protocol, mathematical functions can be created once for a type implementing this protocol and later be used with any one of them.

implementing types
  Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64.
  
operators needed to implement the protocol
  +, +=, -, -=, *, *=, /, /=, %, %=, !=, ==, <, >, <=, >=
  
functions
  init(_v: T) : T being any of the known types implementing the NumericType-protocol
  
additional definitions
  postfix operators:  ++, --
  prefix  operators:  ++, --, -
  functions:          abs(..)

[See file](Math/Numbers.swift)

### Matrix

Originally the repository was used for matrix calculations, so there are many matrix calculations available.

prefix operators
  ++ : incrementing every single item
  
postfix operators
  ++ : incrementing every single item

infix operators
  * : multiply matrices
  * : multiply a matrix with a scalar (both directions possible, matrix * scalar or scalar * matrix)
  + : add matrices
  - : subtract matrices
  ^ : calculating the matrix to the given power (being of type UInt)
  ^+: add up all the powers of the given matrix up to the given power (of type UInt)
  % : set every value in the matrix to the value mod p, p being the given number (of the same type as the elements in the matrix)

functions
  toLatex(..) : generates LaTeX code representing the given matrix
  test(..)    : calculates, if linear system is solved with the given matrix and vectors
  

[See file](Math/Matrix.swift)

### Arrays

operators
  / : divide all elements by the given number
  
functions
  swap(..)  : swapping two array elements
  toLatex() : generating array or vector representation of the given array
  
[See file](Math/Array.swift)

### Strings

Less mathematical, but still useful: string manipulation functions/operators.

operators
  * : multiply strings, e.g. "hello" * 2 => "hellohello".

functions
  to1337()  : replacing some letters with numbers

[See file](Math/String.swift)
