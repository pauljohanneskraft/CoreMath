//
//  Matrix.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 04.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

public struct Matrix < N > : ExpressibleByArrayLiteral, CustomStringConvertible {
    public typealias Element = [N]
    
    fileprivate(set) var elements : [[N]]
    
    public init(_ elements: [[N]]) {
        self.elements = elements
        assert(isRect)
    }
    
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
    
    public var isSquare : Bool {
        return elements.count == elements[0].count
    }
    
    public var size : (rows: Int, columns: Int) {
        return (elements.count, elements[0].count)
    }
    
    private var isRect : Bool {
        /* debugging, in O(rows) */
        let columnCount = elements[0].count
        for e in elements {
            guard e.count == columnCount else { return false }
        }
        return true
    }
    
    internal var oneLineDescription : String {
        let (c,d) = size
        var desc = "| "
        for i in 0..<c {
            for j in 0..<d {
                desc += "\(elements[i][j]) "
            }
            desc += "| "
        }
        desc.characters = desc.characters.dropLast()
        return desc
    }
    
    public var description : String {
        let c = elements.count
        let d = elements[0].count
        var desc = ""
        for i in 0..<c {
            desc += "| "
            for j in 0..<d {
                desc += "\(elements[i][j]) "
            }
            desc += "|\n"
        }
        return desc
    }
    
    public subscript(index: Int) -> [N] {
        get { return elements[index] }
        set { elements[index] = newValue }
    }
}

extension Matrix where N : BasicArithmetic {
    
    public static func identity(_ count: Int) -> Matrix<N> {
        var mat = [[N]](repeating: [N](repeating: 0, count: count), count: count)
        for i in 0..<count { mat[i][i] = 1 }
        return Matrix<N> (mat)
    }
    
    public var rank : Int {
        
        func onlyZeros(_ row: Element) -> Bool {
            for e in row { if e != 0 { return false } }
            return true
        }
        
        let rowEchelonForm = self.rowEchelonForm
        var i = rowEchelonForm.size.rows
        while i > 0 {
            if onlyZeros(rowEchelonForm[i - 1]) { i -= 1 }
            else { return i }
        }
        return 0
    }
    
    public var rowEchelonForm : Matrix<N> {
        
        func removeLeadingNumber(row: inout Element, withLine: Element, startAt: Int) {
            let coeff = row[startAt] / withLine[startAt]
            // print(row, withLine, coeff)
            if coeff != 0 {
                for i in startAt ..< row.count {
                    row[i] -= coeff*withLine[i]
                }
            }
            // print("->", row)
        }
        
        func divide(row: inout Element, by: N, startAt: Int) {
            assert(by != 0)
            // print("divides", row, "by", by)
            for i in startAt ..< row.count {
                row[i] /= by
            }
            // print("result", row)
        }
        
        let size = self.size
        var elements = self.elements
        
        for row in 0 ..< min(size.columns, size.rows) {
            // looking for element which is not 0 at index "row"
            if elements[row][row] == 0 {
                for i in (row+1) ..< size.rows {
                    if elements[i][row] != 0 {
                        swap(&elements[row], &elements[i])
                        // print("swapped")
                        break
                    }
                }
            }
            // print("did choose changing row")
            
            if elements[row][row] == 0 { continue }
            divide(row: &elements[row], by: elements[row][row], startAt: row)
            for i in (row+1) ..< size.rows {
                removeLeadingNumber(row: &elements[i], withLine: elements[row], startAt: row)
            }
        }
        return Matrix(elements) // TODO!!
    }
    
    public var strictRowEchelonForm : Matrix<N> {
        
        func subtract(line: [N], from: inout [N], multipliedBy: N = 1) {
            assert(line.count == from.count)
            for i in line.indices { from[i] -= line[i]*multipliedBy }
        }
        
        func onlyZeros(_ row: Element) -> Bool {
            for e in row { if e != 0 { return false } }
            return true
        }
        
        var rowEchelonForm = self.rowEchelonForm
        let rows = rowEchelonForm.size.rows
        var i = rows - 1
        
        while i >= 0 {
            if !onlyZeros(rowEchelonForm[i]) {
                for j in 0 ..< i {
                    // print("\nbefore:\n", rowEchelonForm, "\n")
                    if rowEchelonForm[i][i] != 0 {
                        let factor = rowEchelonForm.elements[j][i] / rowEchelonForm.elements[i][i]
                        // print(i, j, factor)
                        subtract(line: rowEchelonForm.elements[i],
                                 from: &rowEchelonForm.elements[j],
                         multipliedBy: factor)
                    }
                    // print("\nafter:\n", rowEchelonForm, "\n")
                }
            }
            i -= 1
        }
        
        return rowEchelonForm // TODO!!
    }
    
    public var inverse : Matrix<N> {
        assert(isSquare)
        let rows = size.rows
        var two = self
        var id = Matrix<N>.identity(rows)
        for i in two.elements.indices {
            two.elements[i].append(contentsOf: id.elements[i])
        }
        // print(two)
        two = two.strictRowEchelonForm
        // print(two)
        let drows = rows << 1
        for i in two.elements.indices {
            id.elements[i] = two.elements[i][rows..<drows] + []
        }
        return id
    }
    
    public var determinant : N {
        assert(isSquare)
        let count = elements.count
        
        switch count {
        case 0: return 1
        case 1: return elements[0][0]
        case 2: return elements[0][0] * elements[1][1] - elements[0][1] * elements[1][0]
        case 3:
            let a = elements[0][0]*elements[1][1]*elements[2][2]
            let b = elements[0][1]*elements[1][2]*elements[2][0]
            let c = elements[0][2]*elements[1][0]*elements[2][1]
            let d = elements[2][0]*elements[1][1]*elements[0][2]
            let e = elements[0][0]*elements[1][2]*elements[2][1]
            let f = elements[0][1]*elements[1][0]*elements[2][2]
            return a + b + c - d - e - f
        default:
            var res : N = 0
            for i in 0..<count {
                var matrix = elements
                matrix.remove(at: 0)
                for j in 0..<(count-1) {
                    matrix[j].remove(at: i)
                }
                let det = Matrix(matrix).determinant * elements[0][i]
                if i % 2 == 0   { res += det }
                else            { res -= det }
            }
            return res
        }
    }
}

extension Matrix where N : Numeric {
    public var eigenvalues : [N]? {
        assert(isSquare)
        let c = size.rows
        var mat = [[Polynomial<N>]]()
        for i in 0 ..< c {
            var arr = [Polynomial<N>]()
            for j in 0 ..< c {
                let elem : Polynomial<N>
                if i == j { elem = Polynomial<N>([self.elements[i][j], -1]) }
                else      { elem = Polynomial<N>([self.elements[i][j]    ]) }
                arr.append(elem)
            }
            mat.append(arr)
        }
        return Matrix< Polynomial<N> >(mat).determinant.zeros
    }
}

public func -= < N : BasicArithmetic > (lhs: inout Matrix<N>, rhs: Matrix<N>) {
    assert(lhs.size == rhs.size)
    let size = lhs.size
    for i in 0 ..< size.rows {
        for j in 0 ..< size.columns {
            lhs.elements[i][j] -= rhs.elements[i][j]
        }
    }
}

public func - < N : BasicArithmetic > (lhs: Matrix<N>, rhs: Matrix<N>) -> Matrix<N> {
    var lhs = lhs
    lhs -= rhs
    return lhs
}

public func *= < N : BasicArithmetic > (lhs: inout Matrix<N>, rhs: N) {
    let size = lhs.size
    for i in 0 ..< size.rows {
        for j in 0 ..< size.columns {
            lhs.elements[i][j] *= rhs
        }
    }
}

public func * < N : BasicArithmetic > (lhs: Matrix<N>, rhs: N) -> Matrix<N> {
    var lhs = lhs
    lhs *= rhs
    return lhs
}

public func * < N : BasicArithmetic > (lhs: N, rhs: Matrix<N>) -> Matrix<N> {
    var rhs = rhs
    rhs *= lhs
    return rhs
}


public func * < T : BasicArithmetic >(left: Matrix<T>, right: Matrix<T>) -> Matrix<T> {
    var left = left
    left *= right
    return left
}

public func *= < T: BasicArithmetic >( left: inout Matrix<T>, right: Matrix<T>) {
    assert(left.size.columns == right.size.rows)
    var matrix = [[T]]()
    let ls = left.size
    let lrows = ls.rows
    let lcols = ls.columns
    let rcols = right.size.columns
    
    for i in 0 ..< lrows {
        var array : [T] = []
        for j in 0 ..< rcols {
            var value : T = 0
            for k in 0 ..< lcols {
                /*
                print(i, j, k, left.oneLineDescription, right.oneLineDescription)
                print(left.elements[i])
                print(left.elements[i][k])
                print(right.elements[k])
                print(right.elements[k][j])
                */
                value += (left.elements[i][k]*right.elements[k][j])
            }
            array.append(value)
        }
        matrix.append(array)
    }
    // let l = left
    left = Matrix(matrix)
    // print(l.oneLineDescription, "*", right.oneLineDescription, "=", left.oneLineDescription)
}

public func += <T : BasicArithmetic>( left: inout Matrix<T>, right: Matrix<T>) {
    assert(left.size == right.size)
    for i in 0..<left.elements.count {
        for j in 0..<left.elements[0].count {
            left.elements[i][j] += right.elements[i][j]
        }
    }
}

public func + <T : BasicArithmetic>(left: Matrix<T>, right: Matrix<T>) -> Matrix<T> {
    var matrix = left
    matrix += right
    return matrix
}

public func == < T : Equatable >(lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    if lhs.size != rhs.size { return false }
    return lhs.elements == rhs.elements
}

public func == <T: Equatable>(left: [[T]], right: [[T]]) -> Bool {
    if left.count != right.count { return false }
    for row in 0..<left.count {
        if left[row] != right[row] { return false }
    }
    return true
}

