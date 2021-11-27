import Foundation
import PathKit
import Rainbow
import SwagGenKit
import Swagger
import SwiftCLI
import Yams

class GenerateCommand: Command {

    let name = "generate"
    let shortDescription = "Generates code for a Swagger spec"

    let spec = SwiftCLI.Param<String>()

    let clean = Key<Generator.Clean>("--clean", "-c", description: """
        How the destination directory will be cleaned of non generated files:
         - none: no files will be removed
         - leave.files: all other files will be removed except if starting with . in the destination directory
         - all: all other files will be removed
        """)

    let destination = Key<String>("--destination", "-d", description: "The directory where the generated files will be created. Defaults to \"generated\"")

    let template = Key<String>("--template", "-t", description: "path to the template config yaml file. If no template is passed a default template for the language will be used")

    let language = Key<String>("--language", "-l", description: "The language of the template that will be generated. This defaults to swift")

    let optionsKey = VariadicKey<String>("--option", "-o", description: """
        An option that will be merged with template options, and overwrite any options of the same name.
        Can be repeated multiple times and must be in the format --option "name:value".
        The key can have multiple parts separated by dots to set nested properties:
        for example, --option "typeAliases.ID:String" would change the type alias of ID to String.
        """)

    @Flag("--verbose", "-v", description: "Show verbose output")
    var verbose: Bool
    
    @Flag("--silent", "-s", description: "Silence standard output")
    var silent: Bool

    func execute() throws {
        let clean = self.clean.value ?? .none
        let destinationPath = destination.value.flatMap { Path($0) } ?? (Path.current + "generated")
        let language = self.language.value ?? "swift"

        let specURL: URL
        if URL(string: spec.value)?.scheme == nil {
            let path = Path(spec.value).normalize()
            guard path.exists else {
                exitWithError("Could not find spec at \(path)")
            }
            specURL = URL(fileURLWithPath: path.string)
        } else if let url = URL(string: spec.value) {
            specURL = url
        } else {
            exitWithError("Must pass valid spec. It can be a path or a url")
        }

        /// Assign a value by key list to a multiply nested dictionary that might not exist yet.
        func deepAssign(dict: inout [String: Any], keys: [String], value: Any) {
            guard let key = keys.first else { return }
            if keys.count == 1 {
                dict[key] = value
            } else {
                var subdict: [String: Any] = dict[key].flatMap { $0 as? [String: Any] } ?? [:]
                deepAssign(dict: &subdict, keys: Array(keys.dropFirst()), value: value)
                dict[key] = subdict
            }
        }

        var options: [String: Any] = [:]
        for option in self.optionsKey.value {
            guard option.contains(":") else {
                exitWithError("Options argument '\(option)' must have its name and value separated with a colon")
            }
            let parts = option.components(separatedBy: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count >= 2 {
                let keys = parts.first!.split(separator: ".").map { String($0) }
                let value = Array(parts.dropFirst()).joined(separator: ":")
                deepAssign(dict: &options, keys: Array(keys), value: value)
            }
        }

        let templatePath: PathKit.Path
        if let template = template.value {
            templatePath = Path(template)
        } else {
            let bundlePath = Path(Bundle.main.bundlePath)
            let relativePath = Path("Templates/\(language)/template.yml")
            var possibleSettingsPaths: [PathKit.Path] = [
                relativePath,
                bundlePath + relativePath,
                bundlePath + "../share/swaggen/\(relativePath)",
                Path(#file).parent().parent().parent() + relativePath,
            ]

            if let symlink = try? (bundlePath + "swaggen").symlinkDestination() {
                possibleSettingsPaths = [
                    symlink.parent() + relativePath,
                ] + possibleSettingsPaths
            }

            guard let path = possibleSettingsPaths.first(where: { $0.exists }) else {
                exitWithError("Couldn't find template for language \(language)")
            }
            templatePath = path
        }

        generate(specURL: specURL, templatePath: templatePath, destinationPath: destinationPath, clean: clean, options: options)
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string.red
        exit(EXIT_FAILURE)
    }

    func standardOut(_ string: String) {
        if !silent {
            stdout <<< string
        }
    }

    func generate(specURL: URL, templatePath: PathKit.Path, destinationPath: PathKit.Path, clean: Generator.Clean, options: [String: Any]) {

        let spec: SwaggerSpec
        do {
            if specURL.scheme != nil {
                standardOut("Loading spec from \(specURL.absoluteString)")
            }

            spec = try SwaggerSpec(url: specURL)
        } catch {
            exitWithError("Error loading Swagger Spec: \(error)")
        }

        let specCounts = getCountString(
            counts: [
                ("operation", spec.paths.reduce(0) { $0 + $1.operations.count }),
                ("definition", spec.components.schemas.count),
                // ("tag", spec.tags.count),
                ("parameter", spec.components.parameters.count),
                ("security definition", spec.components.securitySchemes.count),
            ], pluralise: true
        )
        standardOut("Loaded spec: \"\(spec.info.title)\" - \(specCounts)")

        //    let invalidReferences = Array(Set(spec.invalidReferences)).sorted()
        //    for reference in invalidReferences {
        //        writeError("Couldn't find reference: \(reference)")
        //    }

        let templateConfig: TemplateConfig
        do {
            templateConfig = try TemplateConfig(path: templatePath.normalize(), options: options)
        } catch {
            exitWithError("Error loading template: \(error)")
        }

        let templateCounts = getCountString(
            counts: [
                ("template file", templateConfig.templateFiles.count),
                ("copied file", templateConfig.copiedFiles.count),
                ("option", templateConfig.options.keys.count),
            ], pluralise: true
        )
        standardOut("Loaded template: \(templateCounts)")

        if verbose {
            if !templateConfig.options.isEmpty {
                standardOut("Options:\n  \(templateConfig.options.prettyPrinted.replacingOccurrences(of: "\n", with: "\n  "))")
            }
        }
        let codeFormatter: CodeFormatter
        if let formatter = templateConfig.formatter {

            switch formatter {
            case "swift":
                codeFormatter = SwiftFormatter(spec: spec, templateConfig: templateConfig)
            default:
                codeFormatter = CodeFormatter(spec: spec, templateConfig: templateConfig)
                standardOut("Unrecognized formatter \(formatter). Using default")
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

        standardOut("Destination: \(destinationPath.absolute())")

        do {
            let generationResult = try generator.generate(clean: clean) { change in

                guard verbose else {
                    return
                }

                switch change {
                case let .generated(file):
                    switch file.state {
                    case .unchanged:
                        break
                    // standardOut("Unchanged \(file.path)".lightBlack)
                    case .modified:
                        standardOut("Modified \(file.path)".yellow)
                    case .created:
                        standardOut("Created \(file.path)".green)
                    }
                case let .removed(path):
                    let relativePath = path.absolute().string.replacingOccurrences(of: destinationPath.normalize().absolute().string + "/", with: "")
                    standardOut("Removed \(relativePath)".red)
                }
            }
            standardOut("Generation complete: \(generationResult)")
        } catch {
            exitWithError("Error generating code: \(error)")
        }
    }
}

extension Generator.Clean: ConvertibleFromString {

    public static func convert(from: String) -> Generator.Clean? {
        switch from {
        case "true", "yes", "all": return .all
        case "false", "no", "none": return Generator.Clean.none
        case "leave-dot-files", "leaveDotFiles", "leave.files": return .leaveDotFiles
        default: return nil
        }
    }
}
