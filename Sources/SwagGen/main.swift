import Foundation
import PathKit
import Commander
import SwagGenKit

func optionsValidator(string: String) -> String {
    if !string.isEmpty && !string.contains(":") {
        writeError("Options arguement '\(string)' must be comma delimited and the name and value must be seperated by a colon")
        exit(EXIT_FAILURE)
    }
    return string
}

extension Path: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        guard let path = parser.shift() else {
            throw ArgumentError.missingValue(argument: nil)
        }
        self.init(path)
    }
}

extension Generator.Clean: ArgumentConvertible {

    public init(parser: ArgumentParser) throws {
        guard let clean = parser.shift() else {
            throw ArgumentError.missingValue(argument: nil)
        }
        switch clean {
        case "true", "yes", "all": self = .all
        case "false", "no", "none": self = .none
        case "leave-dot-files", "leaveDotFiles", "leave.files": self = .leaveDotFiles
        default: throw ArgumentError.invalidType(value: clean, type: "Generator.Clean", argument: "clean")
        }
    }

    public var description: String {
        return rawValue
    }
}

command(
    Option("template", "", flag: "t", description: "The path to the template json file"),
    Option("destination", Path.current + "generated", flag: "d", description: "The directory where the generated files will be created"),
    Option("spec", "", flag: "s", description: "The path or url to a swagger spec json file"),
    Option("clean", .none, flag: "c", description: "How the destination directory will be cleaned of non generated files:\nnone: no files will be removed\nleave.files: all other files will be removed except if starting with . in the destination directory\nall: all other files will be removed"),
    VariadicOption("option", [] as [String], description: "An option that will be merged with template options. Can be repeated multiple times"),
    generate)
    .run()
