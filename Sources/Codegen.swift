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

        for file in templateConfig.templateFiles {
            let template = try environment.loadTemplate(name: file.path)

            if let fileContext = file.context {
                if let context: JSONDictionary = context.json(atKeyPath: fileContext) {
                    var mergedContext = context
                    if mergedContext["options"] == nil {
                        mergedContext["options"] = templateConfig.options
                    }
                    try writeTemplateFile(file, template: template, context: mergedContext)
                } else if let contexts: [JSONDictionary] = context.json(atKeyPath: fileContext) {
                    for context in contexts {
                        var mergedContext = context
                        if mergedContext["options"] == nil {
                            mergedContext["options"] = templateConfig.options
                        }
                        try writeTemplateFile(file, template: template, context: mergedContext)
                    }
                }
            } else {
                try writeTemplateFile(file, template: template, context: context)
            }
        }

        for file in templateConfig.copiedFiles {
            let destinationPath = destination + file
            let sourcePath = templateConfig.path + file
            if destinationPath.exists {
                try? destinationPath.delete()
            }
            try sourcePath.copy(destinationPath)
            print("Copied \(destinationPath)")
        }
    }

    func writeTemplateFile(_ templateFile: TemplateFile, template: Template, context: JSONDictionary) throws {
        var filePath = templateFile.path
        if let destination = templateFile.destination {
            let path = try environment.renderTemplate(string: destination, context: context)
            if path == "" {
                print("Skipping file \(templateFile.path)")
                return
            }
            filePath = path
        }
        let outputPath = destination + filePath
        let rendered = try template.render(context)
        try outputPath.parent().mkpath()
        try outputPath.write(rendered)
        print("Created \(outputPath)")
    }
}
