//
//  Generate.swift
//  SwagGen
//
//  Created by Yonas Kolb on 18/2/17.
//
//

import Foundation
import Swagger
import SwagGenKit
import PathKit

func generate(templatePath: String, destinationPath: Path, specPath: String, clean: Bool, options: [String]) {

    guard specPath != "" && URL(string: specPath) != nil else {
        writeError("Must provide a valid spec")
        exit(EXIT_FAILURE)
    }
    guard templatePath != "" && URL(string: templatePath) != nil else {
        writeError("Must provide a template")
        exit(EXIT_FAILURE)
    }

    var optionsDictionary: [String: String] = [:]
    for option in options {
        let parts = option.components(separatedBy: ":").map{$0.trimmingCharacters(in: .whitespaces)}
        if parts.count >= 2 {
            let key = parts.first!
            let value = Array(parts.dropFirst()).joined(separator: ":")
            optionsDictionary[key] = value
        }
    }

    let spec:SwaggerSpec
    do {
        if URL(string: specPath)?.scheme != nil {
            writeMessage("Loading spec from \(specPath)")
        }
        spec = try SwaggerSpec(path: Path(specPath).normalize())
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
    writeMessage("Loaded spec: \"\(spec.info.title)\" - \(specCounts)")

    let templateConfig: TemplateConfig
    do {
        templateConfig = try TemplateConfig(path: Path(templatePath).normalize(), options: optionsDictionary)
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
        writeMessage("Options:\n  \(templateConfig.options.prettyPrinted.replacingOccurrences(of: "\n", with: "\n  "))")
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

    let generator = Generator(context: context, destination: destinationPath.normalize(), templateConfig: templateConfig)

    writeMessage("Destination: \(destinationPath.absolute())")

    if clean {
        do {
         try destinationPath.normalize().delete()
            writeMessage("Cleaned destination")
        }
        catch let error {
            writeError("Failed to clean destination")
        }
    }
    do {
        try generator.generate()
    } catch let error {
        writeError("Error generating code: \(error)")
        exit(EXIT_FAILURE)
    }
}

func getCountString(counts: [String:Int]) -> String {
    return counts.map{"\($0.value) \($0.value == 1 ? $0.key : "\($0.key)s")"}.joined(separator: ", ")
}
