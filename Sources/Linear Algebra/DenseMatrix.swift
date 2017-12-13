//
//  DenseMatrix.swift
//  LinearAlgebra
//
//  Created by Paul Kraft on 04.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

public struct DenseMatrix<Number>: LinearAlgebraic {
    public typealias Row = [Number]
    public typealias TwoDimensionalArray = [[Number]]
    public typealias Size = (rows: Int, columns: Int)
    
    public private(set) var elements: TwoDimensionalArray
    public var matrix: TwoDimensionalArray { return elements }
    
    public init(elements: TwoDimensionalArray) {
        self.elements = elements
        assert(isRect)
    }
}

extension DenseMatrix: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Row...) {
        self.init(elements: elements)
    }
    
    public init(_ elements: TwoDimensionalArray) {
        self.init(elements: elements)
    }
}

extension DenseMatrix {
    public var isRect: Bool {
        guard let columnCount = elements.first?.count else {
            return false
        }
        return !elements.contains { $0.count != columnCount }
    }
    
    public var size: Size {
        return (elements.count, elements.first?.count ?? 0)
    }
    
    public var isSquare: Bool {
        return elements.count == elements.first?.count ?? 0
    }
    
    public var oneLineDescription: String {
        let (c, d) = size
        var desc = "| "
        for i in 0..<c {
            for j in 0..<d { desc += "\(elements[i][j]) " }
            desc += "| "
        }
        desc = String(desc.dropLast())
        return desc
    }
    
    public subscript(index: Int) -> Row {
        get { return elements[index] }
        set {
            elements[index] = newValue
        }
    }
    
    public subscript(row: Int, column: Int) -> Number {
        get {
            return elements[row][column]
        }
        set {
            elements[row][column] = newValue
        }
    }
}

extension DenseMatrix: CustomStringConvertible {
    public var description: String {
        let c = elements.count
        let d = elements.first?.count ?? 0
        var desc = ""
        for i in 0..<c {
            desc += "| "
            for j in 0..<d { desc += "\(elements[i][j]) " }
            desc += "|\n"
        }
        return desc
    }
}

extension DenseMatrix where Number: BasicArithmetic {
	public static func identity(_ count: Int) -> DenseMatrix {
		var mat = [[Number]](repeating: [Number](repeating: 0, count: count), count: count)
		for i in 0..<count { mat[i][i] = 1 }
		return DenseMatrix(mat)
	}
	
	public var rank: Int {
        let rowEchelonForm = self.rowEchelonForm
        for row in rowEchelonForm.elements.indices.reversed() {
            guard rowEchelonForm.emptyRow(at: row) else { return row + 1 }
        }
        return 0
	}
	
	public var rowEchelonForm: DenseMatrix {
		
        let (rows, columns) = self.size
        var elements = self.elements
        
		func removeLeadingNumber(row: inout Row, withRow: Row, startAt start: Int) {
			let coeff = row[start] / withRow[start]
            guard coeff != 0 else { return }
			for i in start ..< columns { row[i] -= coeff*withRow[i] }
		}
		
		func divide(row: inout Row, by: Number, startAt start: Int) {
			// assert(by != 0)
			for i in start ..< columns { row[i] /= by }
		}
		
		var column	= 0
		var row		= 0
        let minimum = min(rows, columns)
		
		while column < minimum {

            if elements[row][column] == 0 {
				for i in (row+1) ..< rows where elements[i][column] != 0 {
                    elements.swapAt(row, i)
                    break
				}
			}
			
            if elements[row][column] == 0 { column += 1; continue }
			divide(row: &elements[row], by: elements[row][column], startAt: row)
			for i in (row+1) ..< rows {
				removeLeadingNumber(row: &elements[i], withRow: elements[row], startAt: column)
			}
			column += 1
			row += 1
		}
		return DenseMatrix(elements)
	}
    
    private func emptyRow(at index: Int) -> Bool {
        return !elements[index].contains { $0 != 0 }
    }
	
	public var reducedRowEchelonForm: DenseMatrix {
		var rowEchelonForm = self.rowEchelonForm.elements
        let indices = rowEchelonForm[0].indices
		
		for i in rowEchelonForm.indices.reversed() {
            guard rowEchelonForm[i].contains(where: { $0 != 0 }), rowEchelonForm[i][i] != 0 else { continue }
            for j in 0 ..< i {
                let factor = rowEchelonForm[j][i] / rowEchelonForm[i][i]
                for k in indices { rowEchelonForm[j][k] -= rowEchelonForm[i][k]*factor }
            }
		}
		
		return DenseMatrix(rowEchelonForm)
	}
	
	public var inverse: DenseMatrix {
		assert(isSquare)
		let rows = size.rows
		let id = DenseMatrix.identity(rows)
		let two = DenseMatrix((0..<rows).map { self.elements[$0] + id.elements[$0] }).reducedRowEchelonForm
		return DenseMatrix(two.elements.map { Array($0[rows...]) })
	}
	
	public var determinant: Number {
		assert(isSquare)
		let count = elements.count
		
		guard count > 3 else {
            switch count {
            case 0: return 0
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
            default: fatalError("count is not allowed. (\(count))")
            }
		}
		var res: Number = 0
		let indices = 0..<(count - 1)
		for i in 0..<count {
			var matrix = elements
			matrix.remove(at: 0)
			for j in indices { matrix[j].remove(at: i) }
			let det = DenseMatrix(matrix).determinant * elements[0][i]
			if i & 1 == 0 { res += det } else { res -= det }
		}
		return res
	}
}

extension DenseMatrix where Number: Numeric {
    public var eigenvalues: [Number]? {
        assert(isSquare)
        let rowCount = size.rows
        let range = (0..<rowCount)
        let mat = range.map { i -> [Polynomial<Number>] in
            let row = range.map { j -> Polynomial<Number> in
                Polynomial<Number>(i == j ? [self.elements[i][j], -1] : [self.elements[i][j]])
            }
            return row
        }
        return DenseMatrix<Polynomial<Number>>(mat).determinant.zeros
    }
}

extension DenseMatrix: All {}

extension DenseMatrix where Number: BasicArithmetic {
    public static func += (left: inout DenseMatrix, right: DenseMatrix) {
        assert(left.size == right.size)
        for i in 0..<left.elements.count {
            for j in 0..<left.elements[0].count { left.elements[i][j] += right.elements[i][j] }
        }
    }
    
    public static func -= <LA: LinearAlgebraic>(lhs: inout DenseMatrix, rhs: LA) where LA.Number == Number {
        assert(lhs.size == rhs.size)
        let (rows, columnCount) = lhs.size
        let columns = 0..<columnCount
        for i in 0 ..< rows {
            for j in columns { lhs.elements[i][j] -= rhs[i, j] }
        }
    }
    
    public static func *= (lhs: inout DenseMatrix, rhs: Number) {
        let size = lhs.size
        for i in 0 ..< size.rows {
            for j in 0 ..< size.columns { lhs.elements[i][j] *= rhs }
        }
    }
    
    public static func *= <LA: LinearAlgebraic>(left: inout DenseMatrix, right: LA) where LA.Number == Number {
        assert(left.size.columns == right.size.rows)
        var matrix = [[Number]]()
        let ls = left.size
        let lrows = ls.rows
        let lcols = ls.columns
        let rcols = right.size.columns
        
        for i in 0 ..< lrows {
            var array = [Number]()
            for j in 0 ..< rcols {
                var value: Number = 0
                for k in 0 ..< lcols { value += (left[i, k] * right[k, j]) }
                array.append(value)
            }
            matrix.append(array)
        }
        left = DenseMatrix(matrix)
    }
    
    public static func * (lhs: DenseMatrix, rhs: Number) -> DenseMatrix {
        return lhs.copy { $0 *= rhs }
    }
    
    public static func * (lhs: Number, rhs: DenseMatrix) -> DenseMatrix {
        return rhs.copy { $0 *= lhs }
    }
    
    public static func * <LA: LinearAlgebraic>(lhs: DenseMatrix, rhs: LA) -> DenseMatrix where LA.Number == Number {
        return lhs.copy { $0 *= rhs }
    }
    
    public static func + (lhs: DenseMatrix, rhs: DenseMatrix) -> DenseMatrix {
        return lhs.copy { $0 += rhs }
    }
    
    public static func - <LA: LinearAlgebraic>(lhs: DenseMatrix, rhs: LA) -> DenseMatrix where LA.Number == Number {
        return lhs.copy { $0 -= rhs }
    }
}

extension DenseMatrix where Number: Equatable {
    public static func == (lhs: DenseMatrix, rhs: DenseMatrix) -> Bool {
        guard lhs.size == rhs.size else { return false }
        return lhs.elements == rhs.elements
    }
}

private func == <T: Equatable>(lhs: [[T]], rhs: [[T]]) -> Bool {
    guard lhs.count == rhs.count else { return false }
    return !lhs.indices.contains(where: { lhs[$0] != rhs[$0] })
}

extension DenseMatrix {
    var transposed: TransposedDenseMatrix<Number> {
        return TransposedDenseMatrix(original: self)
    }
}
