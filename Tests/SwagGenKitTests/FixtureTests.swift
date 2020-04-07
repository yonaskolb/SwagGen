import Foundation
import PathKit
import Spectre
import XCTest
@testable import SwagGenKit
@testable import Swagger

class FixturesTests: XCTestCase {

    func testFixtures() {

        let specsPath = Path(#file) + "../../../Specs"
        let specs = (try? specsPath.children().filter { $0.isDirectory && !$0.lastComponent.hasPrefix(".") }) ?? []

        describe("SwagGen") {
            for specFolder in specs {

                let specName = specFolder.lastComponent

                $0.it("generate \(specName)") {

                    let possibleExtensions = ["yml", "yaml", "json"]
                    guard let specPath = possibleExtensions.map({ specFolder + "spec.\($0)" }).filter({ $0.exists }).first else {
                        throw failure("couldn't find spec")
                    }

                    let spec = try SwaggerSpec(path: specPath)

                    let templateType = "Swift"
                    let templatePath = Path(#file) + "../../../Templates/\(templateType)"
                    let templateConfig = try TemplateConfig(path: templatePath, options: ["name": specName])

                    let codeFormatter = SwiftFormatter(spec: spec, templateConfig: templateConfig)
                    let context = codeFormatter.getContext()

                    let destinationPath = specFolder + "generated/\(templateType)"
                    try destinationPath.mkpath()
                    let generator = Generator(context: context, destination: destinationPath.normalize(), templateConfig: templateConfig)
                    let result = try generator.generate(clean: .all, fileChanged: { _ in })
                    if result.hasChanged {
                        throw failure("Generated spec has changed: \(result.description)\n\n\(result.changedFilesDescription(includeModifiedContent: true))")
                    }
                }
            }
        }
    }
}
