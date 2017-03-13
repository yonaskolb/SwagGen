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
    VariadicOption("option", [] as [String], description: "An option that will be merged with template options. Can be repeated multiple times"),
    generate)
    .run()
