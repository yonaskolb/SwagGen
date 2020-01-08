import Foundation
import JSONUtilities
import PathKit
import Stencil
import StencilSwiftKit

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

        let stencilSwiftKitExtension = Extension()
        stencilSwiftKitExtension.registerStencilSwiftExtensions()

        environment = Environment(
            loader: FileSystemLoader(paths: [templateConfig.basePath]),
            extensions: [filterExtension, stencilSwiftKitExtension],
            templateClass: SwagGenStencilTemplate.self
        )
    }

    public enum Clean: String {
        case none
        case leaveDotFiles
        case all
    }

    public struct Result: CustomStringConvertible {
        public var generatedFiles: [GeneratedFile]

        public var removedFiles: [Path]

        public func generatedByState(_ state: GeneratedFile.State) -> [GeneratedFile] {
            return generatedFiles.filter { $0.state == state }
        }

        public var hasChanged: Bool {
            return generatedFiles.contains { $0.state != .unchanged } || !removedFiles.isEmpty
        }

        public var createdFiles: [GeneratedFile] {
            return generatedByState(.created)
        }

        public var modifiedFiles: [GeneratedFile] {
            return generatedByState(.modified)
        }

        public var unchangedFiles: [GeneratedFile] {
            return generatedByState(.unchanged)
        }

        public var description: String {
            let counts: [(String, Int)] = [
                ("created", createdFiles.count),
                ("modified", modifiedFiles.count),
                ("unchanged", unchangedFiles.count),
                ("removed", removedFiles.count),
            ]
            return getCountString(counts: counts, pluralise: false)
        }

        public func changedFilesDescription(includeModifiedContent: Bool) -> String {
            var changes: [String] = []
            if !createdFiles.isEmpty {
                let string = "Created:\n  " + createdFiles.map { $0.path.description }.joined(separator: "\n  ")
                changes.append(string)
            }
            if !modifiedFiles.isEmpty {
                let string = "Modified:\n  " + modifiedFiles.map { file in
                    var string = file.path.description
                    if let previousContent = file.previousContent, includeModifiedContent, let diff = String.getFirstDifferentLine(previousContent, file.content) {
                        string += "\n  Diff at line \(diff.line):\n  \"\(diff.string1)\"\n  \"\(diff.string2)\"\n"
                    }
                    return string
                }.joined(separator: "\n  ")
                changes.append(string)
            }
            if !removedFiles.isEmpty {
                let string = "Removed:\n  " + removedFiles.map { $0.description }.joined(separator: "\n  ")
                changes.append(string)
            }
            return changes.joined(separator: "\n\n")
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
        public let previousContent: String?

        public enum State: String {
            case unchanged
            case modified
            case created
        }

        public init(path: Path, content: String, state: State, previousContent: String?) {
            self.path = path
            self.content = content
            self.state = state
            self.previousContent = previousContent
        }

        public init(path: Path, content: String, destination: Path) {
            let outputPath = (destination + path).normalize()
            let state: State
            var previousContent: String?
            if outputPath.exists, let existingContent: String = try? outputPath.read() {
                if existingContent == content {
                    state = .unchanged
                } else {
                    state = .modified
                }
                previousContent = existingContent
            } else {
                state = .created
            }
            self.init(path: path, content: content, state: state, previousContent: previousContent)
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
        let removedFiles = cleanFilesSet.subtracting(generatedFilesSet).sorted()

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

        return Result(generatedFiles: generatedFiles, removedFiles: removedFiles)
    }
}
