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
    var matrix: TwoDimensionalArray { return elements }
    
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
    
    public subscript(index: Int) -> [Number]? {
        get { return elements[index] }
        set {
            guard let value = newValue else { return }
            elements[index] = value
        }
    }
    
    subscript(row: Int, column: Int) -> Number? {
        get {
            return elements[row][column]
        }
        set {
            guard let value = newValue else { return }
            elements[row][column] = value
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
		
		func removeLeadingNumber(row: inout Row, withRow: Row, startAt start: Int) {
			let coeff = row[start] / withRow[start]
            guard coeff != 0 else { return }
			for i in start ..< row.count { row[i] -= coeff*withRow[i] }
		}
		
		func divide(row: inout Row, by: Number, startAt start: Int) {
			assert(by != 0)
			for i in start ..< row.count { row[i] /= by }
		}
		
		let size = self.size
		var elements = self.elements
		var column	= 0
		var row		= 0
		
		while column < min(size.rows, size.columns) {
			// looking for element which is not 0 at index "row"
			if elements[row][column] == 0 {
				for i in (row+1) ..< size.rows where elements[i][column] != 0 {
                    elements.swapAt(row, i)
                    break
				}
			}
			// print("did choose changing row")
			
			if elements[row][column] == 0 { column += 1; continue }
			divide(row: &elements[row], by: elements[row][column], startAt: row)
			for i in (row+1) ..< size.rows {
				removeLeadingNumber(row: &elements[i], withRow: elements[row], startAt: column)
			}
			column += 1
			row += 1
		}
		return DenseMatrix(elements) // TODO!!
	}
    
    private func emptyRow(at index: Int) -> Bool {
        return !elements[index].contains { $0 != 0 }
    }
	
	public var reducedRowEchelonForm: DenseMatrix {
		func subtract(row: Row, from otherRow: inout Row, multipliedBy multiplier: Number = 1) {
			assert(row.count == otherRow.count)
			for i in row.indices { otherRow[i] -= row[i]*multiplier }
		}
		
		var rowEchelonForm = self.rowEchelonForm
		let rows = rowEchelonForm.size.rows
		var i = rows - 1
		
		while i >= 0 {
			if !rowEchelonForm.emptyRow(at: i) {
                for j in 0 ..< i where rowEchelonForm[i, i] != 0 {
                    let factor = rowEchelonForm.elements[j][i] / rowEchelonForm.elements[i][i]
                    subtract(row: rowEchelonForm.elements[i],
                             from: &rowEchelonForm.elements[j],
                             multipliedBy: factor)
                }
			}
			i -= 1
		}
		
		return rowEchelonForm // TODO!!
	}
	
	public var inverse: DenseMatrix {
		assert(isSquare)
		let rows = size.rows
		var two = self
		var id = DenseMatrix.identity(rows)
		for i in two.elements.indices { two.elements[i].append(contentsOf: id.elements[i]) }
		two = two.reducedRowEchelonForm
		let drows = rows << 1
		for i in two.elements.indices { id.elements[i] = two.elements[i][rows..<drows] + [] }
		return id
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
    
    public static func -= (lhs: inout DenseMatrix, rhs: DenseMatrix) {
        assert(lhs.size == rhs.size)
        let size = lhs.size
        for i in 0 ..< size.rows {
            for j in 0 ..< size.columns { lhs.elements[i][j] -= rhs.elements[i][j] }
        }
    }
    
    public static func *= (lhs: inout DenseMatrix, rhs: Number) {
        let size = lhs.size
        for i in 0 ..< size.rows {
            for j in 0 ..< size.columns { lhs.elements[i][j] *= rhs }
        }
    }
    
    public static func *= (left: inout DenseMatrix, right: DenseMatrix) {
        assert(left.size.columns == right.size.rows)
        var matrix = TwoDimensionalArray()
        let ls = left.size
        let lrows = ls.rows
        let lcols = ls.columns
        let rcols = right.size.columns
        
        for i in 0 ..< lrows {
            var array = Row()
            for j in 0 ..< rcols {
                var value: Number = 0
                for k in 0 ..< lcols { value += (left.elements[i][k]*right.elements[k][j]) }
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
    
    public static func * (lhs: DenseMatrix, rhs: DenseMatrix) -> DenseMatrix {
        return lhs.copy { $0 *= rhs }
    }
    
    public static func + (lhs: DenseMatrix, rhs: DenseMatrix) -> DenseMatrix {
        return lhs.copy { $0 += rhs }
    }
    
    public static func - (lhs: DenseMatrix, rhs: DenseMatrix) -> DenseMatrix {
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
    var transposed: DenseMatrix {
        let (rows, columns) = self.size
        let matrix = (0..<columns).map { column in
            (0..<rows).map { row in self[row, column]! }
        }
        return DenseMatrix(matrix)
    }
}
