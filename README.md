# Math

A try to extend Swift with more advanced (mostly mathematical) operations and functions.

## Features

### General

| infix |                                    |  
| ----- |:----------------------------------:| 
| <->   | swap two elements of the same type |

### NumericType

NumericType is a protocol used to unite all numeric types.
By extending the specific numeric types with this protocol, mathematical functions can be created once for a type implementing this protocol and later be used with any one of them.

| implementing types                                                                 |
| ---------------------------------------------------------------------------------- |
| Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64 |

| operators needed to implement the protocol              |
| ------------------------------------------------------- |
| +, +=, -, -=, *, *=, /, /=, %, %=, !=, ==, <, >, <=, >= |

| functions   |                                                                  | 
| ----------- |:----------------------------------------------------------------:| 
| init(..)    | casting made easy, implemented for every known implementing type |

| additional definitions |           | 
| ---------------------- |:---------:| 
| postfix operators      | ++, --    |
| prefix  operators      | ++, --, - |
| functions              | abs(..)   |

[See file](Math/Numbers.swift)

### Matrix

Originally the repository was used for matrix calculations, so there are many matrix calculations available.

| prefix |                                | 
| ------ |:------------------------------:| 
| ++     | incrementing every single item |

| postfix |                                | 
| ------- |:------------------------------:| 
| ++      | incrementing every single item |

| infix |                                   | use                           | result            | 
| ----- |:---------------------------------:| ----------------------------- | ----------------- |
| *     | multiply matrices                 | [[1,2],[3,4]] * [[5,6],[7,8]] | [[n1,n2],[n3,n4]] |
| *     | multiply a matrix with a scalar   | [[1,2],[3,4]] * 2             | [[2,4],[6,8]]     |
| +     | add matrices                      | [[1,2],[3,4]] + [[5,6],[7,8]] | [[6,8],[10,12]]   |
| -     | subtract matrices                 | [[1,2],[3,4]] - [[5,6],[7,8]] | [[-4,-4],[-4,-4]] |
| ^     | matrix to the given power         | [[1,2],[3,4]] ^ 2             | [[n1,n2],[n3,n4]] |
| ^+    | adds up all the powers of the matrix up to the given power | ... | ... |
| %     | set every value in the matrix to the value mod op2 | ... | ... |

| functions   |                                                                          | 
| ----------- |:------------------------------------------------------------------------:| 
| toLaTeX(..) | generates LaTeX code representing the given matrix                       |
| test(..)    | calculates, if linear system is solved with the given matrix and vectors |

[See file](Math/Matrix.swift)

### Arrays

| infix |                                   | use                           | result            | 
| ----- |:---------------------------------:| ----------------------------- | ----------------- |
| /     | divide all elements by op2        | [2,4,6,8] / 2                 | [1,2,3,4]         |

| functions   |                                                              | 
| ----------- |:------------------------------------------------------------:| 
| toLaTeX(..) | generating array or vector representation of the given array |
| swap(..)    | swapping two array elements                                  |
  
[See file](Math/Array.swift)

### Strings

Less mathematical, but still useful: string manipulation functions/operators.

| infix |                  | use         | result       | 
| ----- |:----------------:| ----------- | ------------ |
| *     | multiply strings | "hello" * 2 | "hellohello" |

| functions   |                                     | 
| ----------- |:-----------------------------------:| 
| to1337()    | replacing some letters with numbers |

[See file](Math/String.swift)
