//
//  PerformanceTests.swift
//  SwagGenKitTests
//
//  Created by Yonas Kolb on 2/9/18.
//

import Foundation
import Spectre
import XCTest
import PathKit
@testable import SwagGenKit
@testable import Swagger

class PerformanceTests: XCTestCase {

    let specFixture = Path(#file) + "../../../Specs/TestSpec/spec.yml"
    let templateFixture = Path(#file) + "../../../Templates/Swift"

    func testSpecLoading() throws {
        measure {
            _ = try! SwaggerSpec(path: specFixture)
        }
    }

    func testContextGeneration() throws {

        let spec = try SwaggerSpec(path: specFixture)
        let templateConfig = try TemplateConfig(path: templateFixture, options: ["name": "Petstore"])
        let codeFormatter = SwiftFormatter(spec: spec, templateConfig: templateConfig)

        measure {
            _ = codeFormatter.getContext()
        }
    }

    func testFileGeneration() throws {

        let spec = try SwaggerSpec(path: specFixture)
        let templateConfig = try TemplateConfig(path: templateFixture, options: ["name": "Petstore"])
        let codeFormatter = SwiftFormatter(spec: spec, templateConfig: templateConfig)
        let context = codeFormatter.getContext()
        let destinationPath = Path.temporary + "swaggen_perf"

        measure {
            try? destinationPath.delete()
            let generator = Generator(context: context, destination: destinationPath, templateConfig: templateConfig)
            _ = try! generator.generate(clean: .all, fileChanged: { _ in })
        }
    }
}
