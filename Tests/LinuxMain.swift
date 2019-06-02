import XCTest

import SwagGenKitTests
import SwaggerTests

var tests = [XCTestCaseEntry]()
tests += SwagGenKitTests.__allTests()
tests += SwaggerTests.__allTests()

XCTMain(tests)
