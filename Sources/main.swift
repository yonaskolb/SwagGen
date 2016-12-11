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

func isReadable(path: Path) -> Path {
    if !path.isReadable {
        print("'\(path)' does not exist or is not readable.")
        exit(1)
    }
    return path
}

func isWritable(path: Path) -> Path {
    if !path.isWritable {
        print("'\(path)' is is not writable.")
        exit(1)
    }
    return path
}

func generate(templatePath:Path, destinationPath:Path, spec:String, clean: Bool) {

    do {

        guard templatePath.exists else {
            print("Must provide valid template path \"\(templatePath)\"")
            return
        }

        guard spec != "" && URL(string: spec) != nil else {
            print("Must provide a valid spec")
            return
        }

        print("Template: \(templatePath)")
        print("Destination: \(destinationPath)")
        print("Spec: \(spec)")
        let swaggerSpec = try SwaggerSpec(path: spec)

        let templateConfig = try TemplateConfig(path: templatePath)
        let codeFormatter:CodeFormatter
        switch templateConfig.formatter {
            case "Swift":
              codeFormatter = SwiftFormatter(swaggerSpec: swaggerSpec)
            default:
            codeFormatter = CodeFormatter(swaggerSpec: swaggerSpec)
            return
        }
        let context = codeFormatter.getContext()

        let codegen = Codegen(context: context, destination: destinationPath, templateConfig: templateConfig)
        if clean {
            try? destinationPath.delete()
        }
        try codegen.generate()
    }
    catch let error {
        print("Error:\n\(error)")
    }
}

command(
    Option("template", Path(""), flag: "f", description: "The path to the template json file", validator: isReadable),
    Option("destination", Path.current, flag: "d", description: "The directory where the generated files will be created", validator: isWritable),
    Option("spec", "", flag: "s", description: "The path or url to a swagger spec json file"),
    Flag("clean", description: "Whether the destination directory will be cleared before generating", default: false),
    generate)
    .run()






