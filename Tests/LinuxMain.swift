#if os(Linux)

@testable import AppTests
import XCTest

XCTMain([
    // AppTests
    testCase(AppTests.allTests)
])

#endif
