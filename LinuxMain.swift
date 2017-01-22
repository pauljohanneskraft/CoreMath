
import XCTest

@testable import MathTests

XCTMain([
    testCase(AdvancedNumericTests.allTests),
    testCase(BasicArithmeticTests.allTests),
    testCase(MatrixTests.allTests),
    testCase(ComplexTests.allTests),
    testCase(ModuleTests.allTests),
    testCase(ConstantFunctionTests.allTests),
    testCase(NumericTests.allTests),
    testCase(LinuxCompatibilityTests.allTests),
    testCase(ConstantsTest.allTests),
    testCase(PolynomialFunctionTests.allTests),
    testCase(CustomFunctionTests.allTests),
    testCase(PolynomialTests.allTests),
    testCase(RationalNumberTests.allTests),
    testCase(EnhancedNumberTests.allTests),
    testCase(RingTests.allTests),
    testCase(EquationTests.allTests),
    testCase(TeXTests.allTests),
    testCase(FractionTests.allTests),
    testCase(TermTests.allTests),
    testCase(GroupTests.allTests),
    testCase(TrigonometricFunctionTests.allTests),
    testCase(GrowthTests.allTests),
    testCase(_PolynomialTests.allTests)
])

