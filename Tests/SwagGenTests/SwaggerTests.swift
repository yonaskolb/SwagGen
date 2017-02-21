import XCTest
@testable import SwagGenKit
@testable import Swagger
import PathKit

class SwaggerTests: XCTestCase {

    func testSwaggerParsingMinimum() {
        catchError(message: "Couldn't load spec") {
            let spec = try SwaggerSpec(path: "Tests/SwagGenTests/Fixtures/swagger_specs/minimum.yml")
            XCTAssertEqual(spec.operations.count, 1, "spec must have single operation")
            XCTAssertEqual(spec.operations.first?.path, "/user", "spec must have a /user path")
        }
    }

    func testSwaggerParsingPetStore() {
        catchError(message: "Couldn't load spec") {
            let spec = try SwaggerSpec(path: "Tests/SwagGenTests/Fixtures/swagger_specs/petstore.yml")
            XCTAssertEqual(spec.info?.title, "Swagger Petstore", "spec must have title")
            XCTAssertEqual(spec.operations.count, 3, "spec must have 3 operations")
            XCTAssertEqual(spec.security.count, 2, "spec must have 2 security definitions")
            XCTAssertEqual(spec.definitions.count, 2, "spec must have 3 definitions")
            XCTAssertEqual(spec.tags.count, 1, "spec must have 1 tag")
            XCTAssertEqual(spec.paths.count, 2, "spec must have 2 endpoints")

            let petDefinition = spec.definitions["Pet"]
            XCTAssertEqual(petDefinition?.name, "Pet", "spec must have a Pet definition")
            XCTAssertEqual(petDefinition?.properties[1].name, "name", "spec must have a name property")
        }
    }

    func catchError(message: String = "Error:", closure: () throws -> Void) {
        do {
            try closure()
        } catch let error {
            XCTFail("\(message)\n\(error)")
        }
    }
}

extension SwaggerTests {
    static var allTests: [(String, (SwaggerTests) -> () throws -> Void)] {
        return [
            ("testSwaggerParsingMinimum", testSwaggerParsingMinimum),
            ("testSwaggerParsingPetStore", testSwaggerParsingPetStore),
        ]
    }
}
