//
//  Codegen.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import PathKit
import Stencil
import JSONUtilities

class Codegen {

    var destination: Path
    var templateConfig: TemplateConfig
    let context: JSONDictionary
    let environment: Environment

    init(context: JSONDictionary, destination: Path, templateConfig: TemplateConfig) {
        var mergedContext = context
        mergedContext["options"] = templateConfig.options
        self.context = mergedContext
        self.destination = destination
        self.templateConfig = templateConfig

        let filterExtension = Extension()
        filterExtension.registerFilter("lowerCamelCase") { ($0 as? String)?.lowerCamelCased() ?? $0 }
        filterExtension.registerFilter("upperCamelCase") { ($0 as? String)?.upperCamelCased() ?? $0 }

        environment = Environment(loader: FileSystemLoader(paths: [templateConfig.path]), extensions: [filterExtension])
    }

    func generate() throws {

        for file in templateConfig.files {
            let template = try environment.loadTemplate(name: file.template)

            if let fileContext = file.context {
                if let context: JSONDictionary = context.json(atKeyPath: fileContext) {
                    var mergedContext = context
                    if mergedContext["options"] == nil {
                        mergedContext["options"] = templateConfig.options
                    }
                    try writeFile(template: template, context: mergedContext, path: file.path)
                } else if let contexts: [JSONDictionary] = context.json(atKeyPath: fileContext) {
                    for context in contexts {
                        var mergedContext = context
                        if mergedContext["options"] == nil {
                            mergedContext["options"] = templateConfig.options
                        }
                        try writeFile(template: template, context: mergedContext, path: file.path)
                    }
                }
            } else {
                try writeFile(template: template, context: context, path: file.path)
            }
        }
    }

    func writeFile(template: Template, context: JSONDictionary, path: String) throws {

        let filePath = try environment.renderTemplate(string: path, context: context)
        let rendered = try template.render(context)
        let outputPath = destination + filePath
        try outputPath.parent().mkpath()
        try outputPath.write(rendered)
        print("Added file \(outputPath)")
    }
}
