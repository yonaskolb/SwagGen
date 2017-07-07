@testable import SwagGenKit
@testable import SwaggerParser
import PathKit
import Spectre
import Foundation

public func specTests() {

    let specsPath = Path(#file) + "../../../Specs"
    let specs = (try? specsPath.children().filter { $0.isDirectory && !$0.lastComponent.hasPrefix(".") } ) ?? []

    describe("SwagGen") {
        for specFolder in specs {

            let specName = specFolder.lastComponent

            $0.it("can generate \(specName)") {

                let possibleExtensions = ["yml", "yaml", "json"]
                guard let specPath = possibleExtensions.map({ specFolder + "spec.\($0)" }).filter({ $0.exists }).first else {
                    throw TestSpecError.missingSpec
                }

                let spec = try Swagger(path: specPath)

                let templateType = "Swift"
                let templatePath = Path(#file) + "../../../Templates/\(templateType)"
                let templateConfig = try TemplateConfig(path: templatePath, options: ["name": specName])

                let codeFormatter = SwiftFormatter(spec: spec)
                let context = codeFormatter.getContext()

                try expect(codeFormatter.schemaTypeErrors.count) == 0
                //try expect(codeFormatter.valueTypeErrors.count) == 0

                let destinationPath = specFolder + "generated/\(templateType)"
                try destinationPath.mkpath()
                let generator = Generator(context: context, destination: destinationPath.normalize(), templateConfig: templateConfig)
                let result = try generator.generate(clean: .all, fileChanged: {_ in})
                try expect(result.generatedByState(.created).count) ==  0
                try expect(result.generatedByState(.modified).count) ==  0
                try expect(result.removed.count) ==  0
            }
        }
    }
}

enum TestSpecError: Error {
    case missingSpec
}
