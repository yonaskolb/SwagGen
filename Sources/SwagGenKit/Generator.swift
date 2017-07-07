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

    public enum Clean: String {
        case none
        case leaveDotFiles
        case all
    }

    public struct Result: CustomStringConvertible {
        public var generated: [GeneratedFile]
        public var removed: [Path]

        public func generatedByState(_ state: GeneratedFile.State) -> [GeneratedFile] {
            return generated.filter { $0.state == state }
        }

        public var description: String {
            let counts: [(String, Int)] = [
                ("created", generatedByState(.created).count),
                ("modified", generatedByState(.modified).count),
                ("unchanged", generatedByState(.unchanged).count),
                ("removed", removed.count),
            ]
            return getCountString(counts: counts, pluralise: false)
        }
    }

    public enum FileChange {
        case generated(GeneratedFile)
        case removed(Path)
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
                } else {
                    state = .modified
                }
            } else {
                state = .created
            }
            self.init(path: path, content: content, state: state)
        }
    }

    public func generate(clean: Clean, fileChanged: (FileChange) -> Void) throws -> Result {
        var generatedFiles: [GeneratedFile] = []
        try destination.mkpath()

        for file in templateConfig.templateFiles {
            let template = try environment.loadTemplate(name: file.path)

            func generateTemplateFile(_ templateFile: TemplateFile, template: Template, context: JSONDictionary) throws {
                var filePath = templateFile.path
                if let destination = templateFile.destination {
                    let path = try environment.renderTemplate(string: destination, context: context)
                    if path == "" {
                        return
                    }
                    filePath = path
                }

                let content = try template.render(context)
                let generatedFile = GeneratedFile(path: Path(filePath), content: content, destination: destination)
                generatedFiles.append(generatedFile)
            }

            if let fileContext = file.context {
                if let context: JSONDictionary = context.json(atKeyPath: .key(fileContext)) {
                    var mergedContext = context
                    if mergedContext["options"] == nil {
                        mergedContext["options"] = templateConfig.options
                    }
                    try generateTemplateFile(file, template: template, context: mergedContext)
                } else if let contexts: [JSONDictionary] = context.json(atKeyPath: .key(fileContext)) {
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
            let children = sourcePath.isFile ? [sourcePath] : try sourcePath.recursiveChildren().filter { $0.isFile }
            for child in children {
                let content: String = try child.read()
                let path = Path(child.normalize().string.replacingOccurrences(of: templateConfig.basePath.normalize().string + "/", with: ""))
                let copiedFile = GeneratedFile(path: path, content: content, destination: destination)
                generatedFiles.append(copiedFile)
            }
        }

        //        //remove duplicate filenames
        //        let originalGeneratedFiles = generatedFiles
        //        generatedFiles = []
        //        for file in originalGeneratedFiles {
        //
        //            let filename = file.path.lastComponentWithoutExtension
        //            if generatedFiles.contains(where: { $0.path.lastComponentWithoutExtension == filename }) {
        //                let newFilename = filename + "2"
        //                let newPath = file.path.parent() + "\(newFilename)\(file.path.extension.flatMap { ".\($0)" } ?? "")"
        //                generatedFiles.append(GeneratedFile(path: newPath, content: file.content, destination: ))
        //            } else {
        //                generatedFiles.append(file)
        //            }
        //        }

        generatedFiles = generatedFiles.sorted { $0.state == $1.state ? $0.path < $1.path : $0.state.rawValue > $1.state.rawValue }

        // clean
        var cleanFiles: [Path] = []
        switch clean {
        case .all:
            cleanFiles = try destination.recursiveChildren().filter { $0.isFile }
        case .leaveDotFiles:
            let nonDotFiles = try destination.children().filter { !$0.lastComponentWithoutExtension.hasPrefix(".") }
            cleanFiles = nonDotFiles.filter { $0.isFile }
            cleanFiles += try nonDotFiles.reduce([]) { $0 + (try $1.recursiveChildren().filter { $0.isFile }) }
        case .none: break
        }

        let cleanFilesSet = Set(cleanFiles)
        let generatedFilesSet = Set(generatedFiles.map { destination + $0.path })
        let removedFiles = Array(cleanFilesSet.subtracting(generatedFilesSet)).sorted()

        for file in generatedFiles {
            let outputPath = (destination + file.path).normalize()
            try outputPath.parent().mkpath()
            switch file.state {
            case .unchanged: break
            case .modified:
                try outputPath.write(file.content)
            case .created:
                try outputPath.write(file.content)
            }

            fileChanged(.generated(file))
        }

        for removedFile in removedFiles {
            try? removedFile.delete()
            fileChanged(.removed(removedFile))
        }

        return Result(generated: generatedFiles, removed: removedFiles)
    }
}
