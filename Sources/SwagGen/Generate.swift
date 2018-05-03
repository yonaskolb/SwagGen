import Foundation
import PathKit
import SwagGenKit
import Swagger
import Yams

func generate(specPath: String, language: String, templatePath: String, destinationPath: PathKit.Path, clean: Generator.Clean, options: [String]) {
    var templatePath = Path(templatePath)
    guard specPath != "" && URL(string: specPath) != nil else {
        writeError("Must provide a valid spec")
        exit(EXIT_FAILURE)
    }
    guard language != "" else {
        writeError("Must provide a language")
        exit(EXIT_FAILURE)
    }

    if templatePath.string == "" {
        let bundlePath = Path(Bundle.main.bundlePath)
        let relativePath = Path("Templates/\(language)/template.yml")
        var possibleSettingsPaths: [PathKit.Path] = [
            relativePath,
            bundlePath + relativePath,
            bundlePath + "../share/swaggen/\(relativePath)",
            Path(#file).parent().parent().parent() + relativePath,
        ]

        if let symlink = try? bundlePath.symlinkDestination() {
            possibleSettingsPaths = [
                symlink + relativePath,
            ] + possibleSettingsPaths
        }

        guard let path = possibleSettingsPaths.first(where: { $0.exists }) else {
            writeError("Couldn't find template for language \(language)")
            exit(EXIT_FAILURE)
        }
        templatePath = path
    }
    guard templatePath != "" && URL(string: templatePath.string) != nil else {
        writeError("Must provide a template")
        exit(EXIT_FAILURE)
    }

    var optionsDictionary: [String: String] = [:]
    for option in options {
        let parts = option.components(separatedBy: ":").map { $0.trimmingCharacters(in: .whitespaces) }
        if parts.count >= 2 {
            let key = parts.first!
            let value = Array(parts.dropFirst()).joined(separator: ":")
            optionsDictionary[key] = value
        }
    }

    let spec: SwaggerSpec
    do {
        if URL(string: specPath)?.scheme != nil {
            writeMessage("Loading spec from \(specPath)")
        }

        spec = try SwaggerSpec(path: Path(specPath).normalize())
    } catch let error {
        writeError("Error loading Swagger Spec: \(error)")
        exit(EXIT_FAILURE)
    }

    let specCounts = getCountString(counts: [
        ("operation", spec.paths.reduce(0) { $0 + $1.operations.count }),
        ("definition", spec.definitions.count),
        // ("tag", spec.tags.count),
        ("parameter", spec.parameters.count),
        ("security definition", spec.securityDefinitions.count),
    ], pluralise: true)
    writeMessage("Loaded spec: \"\(spec.info.title)\" - \(specCounts)")

    //    let invalidReferences = Array(Set(spec.invalidReferences)).sorted()
    //    for reference in invalidReferences {
    //        writeError("Couldn't find reference: \(reference)")
    //    }

    let templateConfig: TemplateConfig
    do {
        templateConfig = try TemplateConfig(path: templatePath.normalize(), options: optionsDictionary)
    } catch let error {
        writeError("Error loading template: \(error)")
        exit(EXIT_FAILURE)
    }

    let templateCounts = getCountString(counts: [
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
            codeFormatter = SwiftFormatter(spec: spec, templateConfig: templateConfig)
        default:
            codeFormatter = CodeFormatter(spec: spec, templateConfig: templateConfig)
            writeMessage("Unrecognized formatter \(formatter). Using default")
            return
        }
    } else {
        codeFormatter = CodeFormatter(spec: spec, templateConfig: templateConfig)
    }

    let context = codeFormatter.getContext()

    //    for schema in codeFormatter.schemaTypeErrors {
    //        writeError("Couldn't calculate type for: \(schema)\(schema.metadata.description.flatMap{" \"\($0)\""} ?? "")")
    //    }
    //    for value in codeFormatter.valueTypeErrors {
    //        writeError("Couldn't calculate type for: \(value.name)\(value.description.flatMap{" \"\($0)\""} ?? "")")
    //    }

    let generator = Generator(context: context, destination: destinationPath.normalize(), templateConfig: templateConfig)

    writeMessage("Destination: \(destinationPath.absolute())")

    do {
        let generationResult = try generator.generate(clean: clean) { change in
            switch change {
            case let .generated(file):
                switch file.state {
                case .unchanged:
                    break
                // writeMessage("Unchanged \(file.path)".lightBlack)
                case .modified:
                    writeMessage("Modified \(file.path)".yellow)
                case .created:
                    writeMessage("Created \(file.path)".green)
                }
            case let .removed(path):
                let relativePath = path.absolute().string.replacingOccurrences(of: destinationPath.normalize().absolute().string + "/", with: "")
                writeMessage("Removed \(relativePath)".red)
            }
        }
        writeMessage("Generation complete: \(generationResult)")
    } catch let error {
        writeError("Error generating code: \(error)")
        exit(EXIT_FAILURE)
    }
}
