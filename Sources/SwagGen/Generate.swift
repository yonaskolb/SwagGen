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

func generate(templatePath: String, destinationPath: Path, specPath: String, clean: Generator.Clean, options: [String]) {

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
        ("operation", spec.operations.count),
        ("definition", spec.definitions.count),
        ("tag", spec.tags.count),
        ("parameter", spec.parameters.count),
        ("security definitions", spec.securityDefinitions.count),
        ], pluralise: true)
    writeMessage("Loaded spec: \"\(spec.info.title)\" - \(specCounts)")

    let templateConfig: TemplateConfig
    do {
        templateConfig = try TemplateConfig(path: Path(templatePath).normalize(), options: optionsDictionary)
    } catch let error {
        writeError("Error loading template: \(error)")
        exit(EXIT_FAILURE)
    }

    let templateCounts  = getCountString(counts: [
        ("template file", templateConfig.templateFiles.count),
        ("copied file", templateConfig.copiedFiles.count),
        ("option", templateConfig.options.keys.count),
        ], pluralise: true)
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

    for schema in codeFormatter.schemaTypeErrors {
        writeError("Couldn't calculate type for: \(schema.name ?? "")\(schema.description.flatMap{" \"\($0)\""} ?? "")")
    }
    for value in codeFormatter.valueTypeErrors {
        writeError("Couldn't calculate type for: \(value.name)\(value.description.flatMap{" \"\($0)\""} ?? "")")
    }

    let generator = Generator(context: context, destination: destinationPath.normalize(), templateConfig: templateConfig)

    writeMessage("Destination: \(destinationPath.absolute())")

    do {
        let fileChanges = try generator.generate(clean: clean) { change in
            switch change {
            case .generated(let file):
                switch file.state {
                case .unchanged:
                    writeMessage("Unchanged \(file.path)".lightBlack)
                case .modified:
                    writeMessage("Modified \(file.path)".yellow)
                case .created:
                    writeMessage("Created \(file.path)".green)
                }
            case .removed(let path):
                let relativePath = path.absolute().string.replacingOccurrences(of: destinationPath.normalize().absolute().string + "/", with: "")
                writeMessage("Removed \(relativePath)".red)
            }
        }

        let generatedFiles: [Generator.GeneratedFile] = fileChanges.flatMap {
            if case .generated(let generatedFile) = $0 {
                return generatedFile
            }
            return nil
        }

        let removedFiles: [Path] = fileChanges.flatMap {
            if case .removed(let removedFile) = $0 {
                return removedFile
            }
            return nil
        }

        let counts: [(String, Int)] = [
            ("created", generatedFiles.filter{ $0.state == .created }.count),
            ("modified", generatedFiles.filter{ $0.state == .modified }.count),
            ("unchanged", generatedFiles.filter{ $0.state == .unchanged }.count),
            ("removed", removedFiles.count),
            ]
        writeMessage("Generation complete: \(getCountString(counts: counts, pluralise: false))")
    } catch let error {
        writeError("Error generating code: \(error)")
        exit(EXIT_FAILURE)
    }
}
