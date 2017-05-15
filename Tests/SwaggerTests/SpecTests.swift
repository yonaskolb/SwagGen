
@testable import SwagGenKit
@testable import Swagger
import PathKit
import Spectre

public func specTests() {

    describe("petstore spec") {
        let path = Path(#file) + "../specs/petstore.yml"

        $0.it("can load") {
            _ = try SwaggerSpec(path: Path(path.string))
        }

        var spec: SwaggerSpec!
        do {
            spec = try SwaggerSpec(path: Path(path.string))
        }
        catch _ {
            return
        }

        $0.it("has operations") {
            try expect(spec.operations.count) == 3
        }

        $0.it("has paths") {
            try expect(spec.paths.count) == 2
        }

        $0.describe("/pets path") {

            let path = spec.paths["/pets"]

            $0.it("has correct path") {
                try expect(path?.path) == "/pets"
            }

            $0.it("has operations") {
                try expect(path?.operations.count) == 2
            }

            $0.it("has a get operation") {
                try expect(path?.operations.filter{$0.method == .get}.count) == 1
            }

            $0.it("has a listPets operation") {
                try expect(path?.operations.filter{$0.operationId == "listPets"}.count) == 1
            }

            $0.describe("listPets operation") {

                let operation = path?.operations.filter{$0.operationId == "listPets"}.first
                $0.it("has get operation id") {
                    try expect(operation?.operationId) == "listPets"
                }
                $0.it("has a path") {
                    try expect(operation?.path) == "/pets"
                }
                $0.it("has tags") {
                    try expect(operation?.tags) == ["pets"]
                }
                $0.it("has parameters") {
                    try expect(operation?.parameters.count) == 1
                }
                $0.it("has responses") {
                    try expect(operation?.responses.count) == 2
                }
            }
        }

        $0.it("has metadata") {
            try expect(spec.info.title) == "Swagger Petstore"
        }

        $0.it("has security definitions") {
            try expect(spec.securityDefinitions.count) == 2
        }

        $0.it("has definitions") {
            try expect(spec.definitions.count) == 2
        }

        $0.it("has Pet definition") {
            let petDefinition = spec.definitions["Pet"]
            try expect(petDefinition?.name) == "Pet"
        }

        $0.it("has tags") {
            try expect(spec.tags.count) == 1
        }
        
        $0.it("has paths") {
            try expect(spec.paths.count) == 2
        }
    }
}
