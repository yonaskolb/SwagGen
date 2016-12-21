//
//  main.swift
//  SwiftySwagger
//
//  Created by Yonas Kolb on 17/09/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import PathKit
import Commander

func generate(templatePath: Path, destinationPath: Path, specPath: String, clean: Bool, options: String) {

    do {

        guard specPath != "" && URL(string: specPath) != nil else {
            print("Must provide a valid spec")
            return
        }

        let optionsArray = options.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}

        var optionsDictionary: [String: String] = [:]
        for option in optionsArray {
            let parts = option.components(separatedBy: ":").map{$0.trimmingCharacters(in: .whitespaces)}
            if parts.count == 2 {
                let key = parts[0]
                let value = parts[1]
                optionsDictionary[key] = value
            }
        }

        let spec = try SwaggerSpec(path: specPath)
        print("Loaded spec: \"\(spec.info.title ?? "")\" - \(spec.operations.count) operations, \(spec.definitions.count) definitions, \(spec.tags.count) tags, \(spec.parameters.count) parameters")

        let templateConfig = try TemplateConfig(path: templatePath, options: optionsDictionary)
        print("Loaded template: \(templateConfig.templateFiles.count) templates files, \(templateConfig.copiedFiles.count) copied files")

        let codeFormatter: CodeFormatter
        switch templateConfig.formatter {
        case "Swift":
            codeFormatter = SwiftFormatter(spec: spec)
        default:
            codeFormatter = CodeFormatter(spec: spec)
            return
        }
        let context = codeFormatter.getContext()

        let codegen = Codegen(context: context, destination: destinationPath, templateConfig: templateConfig)
        if clean {
            try? destinationPath.delete()
        }
        try codegen.generate()
    } catch let error {
        print("Error:\n\(error)")
    }
}

func isReadable(path: Path) -> Path {
    if !path.isReadable {
        print("'\(path)' does not exist or is not readable.")
        exit(1)
    }
    return path
}

func optionsValidator(string: String) -> String {
    if !string.isEmpty && !string.contains(":") {
        print("Options arguement '\(string)' must be comma delimited and the name and value must be seperated by a colon")
        exit(1)
    }
    return string
}

command(
    Option("template", Path(""), flag: "f", description: "The path to the template json file", validator: isReadable),
    Option("destination", Path.current, flag: "d", description: "The directory where the generated files will be created"),
    Option("spec", "", flag: "s", description: "The path or url to a swagger spec json file"),
    Flag("clean", description: "Whether the destination directory will be cleared before generating", default: false),
    Option("options", "", flag: "o", description: "A list of options that will be passed to the template. These options must be comma delimited and the name and value must be seperated by a colon. e.g.  option:value, option2: value2", validator: optionsValidator),
    generate)
    .run()
