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
import Rainbow

public class Generator {

    var destination: Path
    var templateConfig: TemplateConfig
    let context: JSONDictionary
    let environment: Environment

    public init(context: JSONDictionary, destination: Path, templateConfig: TemplateConfig) {
        var mergedContext = context
        mergedContext["options"] = templateConfig.options
        self.context = mergedContext
        self.destination = destination
        self.templateConfig = templateConfig

        let filterExtension = Extension()
        filterExtension.registerFilter("lowerCamelCase") { ($0 as? String)?.lowerCamelCased() ?? $0 }
        filterExtension.registerFilter("upperCamelCase") { ($0 as? String)?.upperCamelCased() ?? $0 }

        environment = Environment(loader: FileSystemLoader(paths: [templateConfig.basePath]), extensions: [filterExtension])
    }

    public struct GeneratedFile {
        public let path: Path
        public let content: String
        public let state: State

        public enum State: String {
            case unchanged
            case modified
            case created
        }

        public init(path: Path, content: String, state: State) {
            self.path = path
            self.content = content
            self.state = state
        }

        public init(path: Path, content: String, destination: Path) {
            let outputPath = (destination + path).normalize()
            let state: State
            if outputPath.exists, let existingContent: String = try? outputPath.read() {
                if existingContent == content {
                    state = .unchanged
                }
                else {
                    state = .modified
                }
            }
            else {
                state = .created
            }
            self.init(path: path, content: content, state: state)
        }
    }

    public func generate(clean: Bool) throws -> [GeneratedFile] {
        var generatedFiles: [GeneratedFile] = []

        for file in templateConfig.templateFiles {
            let template = try environment.loadTemplate(name: file.path)

            func generateTemplateFile(_ templateFile: TemplateFile, template: Template, context: JSONDictionary) throws {
                var filePath = templateFile.path
                if let destination = templateFile.destination {
                    let path = try environment.renderTemplate(string: destination, context: context)
                    if path == "" {
                        writeMessage("Skipped file \(templateFile.path)".red)
                        return
                    }
                    filePath = path
                }

                let content = try template.render(context)
                let generatedFile = GeneratedFile(path: Path(filePath), content: content, destination: destination)
                generatedFiles.append(generatedFile)
            }

            if let fileContext = file.context {
                if let context: JSONDictionary = context.json(atKeyPath: fileContext) {
                    var mergedContext = context
                    if mergedContext["options"] == nil {
                        mergedContext["options"] = templateConfig.options
                    }
                    try generateTemplateFile(file, template: template, context: mergedContext)
                } else if let contexts: [JSONDictionary] = context.json(atKeyPath: fileContext) {
                    for context in contexts {
                        var mergedContext = context
                        if mergedContext["options"] == nil {
                            mergedContext["options"] = templateConfig.options
                        }
                        try generateTemplateFile(file, template: template, context: mergedContext)
                    }
                }
            } else {
                try generateTemplateFile(file, template: template, context: context)
            }
        }

        for file in templateConfig.copiedFiles {
            let sourcePath = templateConfig.basePath + file
            let children = try sourcePath.recursiveChildren().filter{ $0.isFile }
            for child in children {
                let content: String = try child.read()
                let copiedFile = GeneratedFile(path: child, content: content, destination: destination)
                generatedFiles.append(copiedFile)
            }
        }

        let unchangedFiles = generatedFiles.filter{ $0.state == .unchanged }
        let modifiedFiles = generatedFiles.filter{ $0.state == .modified }
        let createdFiles = generatedFiles.filter{ $0.state == .created }
        var removedFiles: [Path] = []

        try generatedFiles.sorted{$0.state == $1.state ? $0.path < $1.path : $0.state.rawValue > $1.state.rawValue}.forEach(writeFile)

        if clean {
            let existingPaths = try Set(destination.recursiveChildren().filter{ $0.isFile })
            let generatedPaths = Set(generatedFiles.map{ destination + $0.path})
            removedFiles = Array(existingPaths.subtracting(generatedPaths)).sorted()
            for removedFile in removedFiles {
                let relativePath = removedFile.absolute().string.replacingOccurrences(of: destination.normalize().absolute().string + "/", with: "")
                try? removedFile.delete()
                writeMessage("Removed \(relativePath)".red)
            }
        }

        let counts: [(String, Int)] = [
            ("created", createdFiles.count),
            ("modified", modifiedFiles.count),
            ("unchanged", unchangedFiles.count),
            ("removed", removedFiles.count),
            ]
        writeMessage("Generation complete: \(getCountString(counts: counts, pluralise: false))")

        return generatedFiles
    }

    func writeFile(file: GeneratedFile) throws {
        let outputPath = (destination + file.path).normalize()
        try outputPath.parent().mkpath()
        switch file.state {
        case .unchanged:
            writeMessage("Unchanged \(file.path)".lightBlack)
        case .modified:
            try outputPath.write(file.content)
            writeMessage("Modified \(file.path)".yellow)

        case .created:
            try outputPath.write(file.content)
            writeMessage("Created \(file.path)".green)
        }
    }
}
