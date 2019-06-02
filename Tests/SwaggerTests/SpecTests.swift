
import PathKit
import Spectre
import XCTest
@testable import Swagger

class SpecTests: XCTestCase {

    func testSpecs() {

        describe("petstore spec") {
            let path = Path(#file) + "../../../Specs/petstore/spec.yml"

            $0.it("can load") {
                _ = try SwaggerSpec(path: Path(path.string))
            }

            var spec: SwaggerSpec!
            do {
                spec = try SwaggerSpec(path: Path(path.string))
            } catch _ {
                return
            }

            $0.it("has operations") {
                try expect(spec.operations.count) == 4
            }

            $0.it("has paths") {
                try expect(spec.paths.count) == 2
            }

            $0.describe("servers") {
                $0.it("has servers") {
                    try expect(spec.servers.count) == 2
                }

                $0.it("has server variables") {
                    try expect(spec.servers[0].variables.count) == 2
                }
            }

            $0.describe("/pets path") {

                let path = spec.paths.first { $0.path == "/pets" }

                $0.it("has correct path") {
                    try expect(path?.path) == "/pets"
                }

                $0.it("has operations") {
                    try expect(path?.operations.count) == 2
                }

                $0.it("has a get operation") {
                    try expect(path?.operations.filter { $0.method == .get }.count) == 1
                }

                $0.it("has a listPets operation") {
                    try expect(path?.operations.filter { $0.identifier == "listPets" }.count) == 1
                }

                $0.describe("listPets operation") {

                    let operation = path?.operations.filter { $0.identifier == "listPets" }.first
                    $0.it("has get operation id") {
                        try expect(operation?.identifier) == "listPets"
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
                    $0.it("has 2 responses") {
                        try expect(operation?.responses.count) == 2
                    }
                    $0.it("has a default responses") {
                        try expect(operation?.defaultResponse?.value.description) == "unexpected error"
                    }
                }
            }

            $0.describe("/pets/{petId} path") {

                let path = spec.paths.first { $0.path == "/pets/{petId}" }

                $0.it("has correct path") {
                    try expect(path?.path) == "/pets/{petId}"
                }

                $0.it("has 2 operations") {
                    try expect(path?.operations.count) == 2
                }

                $0.it("has a showPetById operation") {
                    try expect(path?.operations.filter { $0.identifier == "showPetById" }.count) == 1
                }

                $0.describe("showPetById operation") {

                    let operation = path?.operations.filter { $0.identifier == "showPetById" }.first
                    $0.it("has get operation id") {
                        try expect(operation?.identifier) == "showPetById"
                    }
                    $0.it("has a path") {
                        try expect(operation?.path) == "/pets/{petId}"
                    }
                    $0.it("has tags") {
                        try expect(operation?.tags) == ["pets"]
                    }
                    $0.it("has 1 parameter") {
                        try expect(operation?.parameters.count) == 1
                    }
                    $0.it("has 2 responses") {
                        try expect(operation?.responses.count) == 2
                    }
                    $0.it("has a default responses") {
                        try expect(operation?.defaultResponse?.value.description) == "unexpected error"
                    }
                    $0.it("is a get operation") {
                        try expect(operation?.method) == .get
                    }
                }

                $0.it("has a updatePetWithForm operation") {
                    try expect(path?.operations.filter { $0.identifier == "updatePetWithForm" }.count) == 1
                }

                $0.describe("updatePetWithForm operation") {

                    let operation = path?.operations.filter { $0.identifier == "updatePetWithForm" }.first
                    $0.it("has operation id") {
                        try expect(operation?.identifier) == "updatePetWithForm"
                    }
                    $0.it("has a path") {
                        try expect(operation?.path) == "/pets/{petId}"
                    }
                    $0.it("has tags") {
                        try expect(operation?.tags) == ["pets"]
                    }
                    $0.it("has a path parameter") {
                        try expect(operation?.parameters.count) == 1
                        try expect(operation?.pathParameters.count) == 1
                    }
                    $0.it("has 1 path parameter") {
                        try expect(operation?.parameters.filter { $0.value.location == .path }.count) == 1
                    }
                    $0.it("has 2 form parameters") {
                        let formSchema = operation?.requestBody?.value.content.formSchema
                        try expect(formSchema?.type.object?.properties.count) == 2
                    }
                    $0.it("has 1 response") {
                        try expect(operation?.responses.count) == 1
                    }
                    $0.it("is a post operation") {
                        try expect(operation?.method) == .post
                    }
                }
            }

            $0.it("has metadata") {
                try expect(spec.info.title) == "Swagger Petstore"
            }

            $0.it("has security schemes") {
                try expect(spec.components.securitySchemes.count) == 2
            }

            $0.it("has schema") {
                try expect(spec.components.schemas.count) == 3
            }

            $0.it("has Pet definition") {
                let petDefinition = spec.components.schemas.named("Pet")
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
}
