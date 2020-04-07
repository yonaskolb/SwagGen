
import PathKit
import Spectre
import XCTest
@testable import Swagger

class ParsingTests: XCTestCase {

    public func testParsing() {

        describe("swagger spec") {
            $0.it("throws error on missing version") {
                let specString = "{}"
                try expect(try SwaggerSpec(string: specString)).toThrow()
            }

            $0.it("throws error on incorrect version") {
                let specString = "{\"swagger\": \"1.0\"}"
                try expect(try SwaggerSpec(string: specString)).toThrow()
            }

            $0.it("throws error on missing required property") {
                let specString = "{\"swagger\": \"2.0\"}"
                try expect(try SwaggerSpec(string: specString)).toThrow()
            }

            $0.it("throws error on incorrect property type") {
                let specString = "{\"swagger\": \"2.0\", \"info\": {\"title\": 2}}"
                try expect(try SwaggerSpec(string: specString)).toThrow()
            }
        }
    }
}
