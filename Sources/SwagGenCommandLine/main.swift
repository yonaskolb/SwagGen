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
import SwagGen

func generate(templatePath: String, destinationPath: Path, specPath: String, clean: Bool, options: String) {

    guard specPath != "" && URL(string: specPath) != nil else {
        writeError("Must provide a valid spec")
        exit(EXIT_FAILURE)
    }
    guard templatePath != "" && URL(string: templatePath) != nil else {
        writeError("Must provide a template")
        exit(EXIT_FAILURE)
    }

    let optionsArray = options.components(separatedBy: ",").map{$0.trimmingCharacters(in: .whitespaces)}

    var optionsDictionary: [String: String] = [:]
    for option in optionsArray {
        let parts = option.components(separatedBy: ":").map{$0.trimmingCharacters(in: .whitespaces)}
        if parts.count >= 2 {
            let key = parts.first!
            let value = Array(parts.dropFirst()).joined(separator: ":")
            optionsDictionary[key] = value
        }
    }

    let spec:SwaggerSpec
    do {
        spec = try SwaggerSpec(path: specPath)
    }
    catch let error {
        writeError("Error loading Swagger Spec: \(error)")
        exit(EXIT_FAILURE)
    }
    let specCounts  = getCountString(counts: [
        "operation": spec.operations.count,
        "definition": spec.definitions.count,
        "tag": spec.tags.count,
        "parameter": spec.parameters.count,
        ])
    writeMessage("Loaded spec: \(spec.info?.title != nil ? "\"\(spec.info!.title!)\" - " : "")\(specCounts)")

    let templateConfig: TemplateConfig
    do {
        templateConfig = try TemplateConfig(path: Path(templatePath), options: optionsDictionary)
    } catch let error {
        writeError("Error loading template: \(error)")
        exit(EXIT_FAILURE)
    }

    let templateCounts  = getCountString(counts: [
        "template file": templateConfig.templateFiles.count,
        "copied file": templateConfig.copiedFiles.count,
        "option": templateConfig.options.keys.count,
        ])
    writeMessage("Loaded template: \(templateCounts)")
    if !templateConfig.options.isEmpty {
        writeMessage("Options:\n\t\(templateConfig.options.map{"\($0): \($1)"}.joined(separator: "\n").replacingOccurrences(of: "\n", with: "\n\t"))")
    }
    let codeFormatter: CodeFormatter
    if let formatter = templateConfig.formatter {

        switch formatter {
        case "swift":
            codeFormatter = SwiftFormatter(spec: spec)
        default:
            codeFormatter = CodeFormatter(spec: spec)
            writeMessage("Unrecognized formatter \(formatter). Using default")
            return
        }
    }
    else {
        codeFormatter = CodeFormatter(spec: spec)
    }

    let context = codeFormatter.getContext()

    let codegen = Codegen(context: context, destination: destinationPath, templateConfig: templateConfig)

    writeMessage("Destination: \(destinationPath.absolute())")

    if clean {
        try? destinationPath.delete()
        writeMessage("Cleaned destination")
    }
    do {
        try codegen.generate()
    } catch let error {
        writeError("Error generating code: \(error)")
        exit(EXIT_FAILURE)
    }
}

func getCountString(counts: [String:Int]) -> String {
    return counts.map{"\($0.value) \($0.value == 1 ? $0.key : "\($0.key)s")"}.joined(separator: ", ")
}

func optionsValidator(string: String) -> String {
    if !string.isEmpty && !string.contains(":") {
        writeError("Options arguement '\(string)' must be comma delimited and the name and value must be seperated by a colon")
        exit(EXIT_FAILURE)
    }
    return string
}

extension Path: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        if let path = parser.shift() {
            self.init(path)
        } else {
            throw ArgumentError.missingValue(argument: nil)
        }
    }
}

command(
    Option("template", "", flag: "t", description: "The path to the template json file"),
    Option("destination", Path.current + "generated", flag: "d", description: "The directory where the generated files will be created"),
    Option("spec", "", flag: "s", description: "The path or url to a swagger spec json file"),
    Flag("clean", description: "Whether the destination directory will be cleared before generating", default: false),
    Option("options", "", flag: "o", description: "A list of options that will be passed to the template. These options must be comma delimited and the name and value must be seperated by a colon. e.g.  option:value, option2: value2", validator: optionsValidator),
    generate)
    .run()
