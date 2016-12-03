//
//  Codegen.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import PathKit
import JSONUtilities
import Mustache

struct TemplateConfig {

    struct File: JSONObjectConvertible {
        let template:String
        let path:String
        let context:String?

        init(template:String, path:String, context:String? ) {
            self.template = template
            self.path = path
            self.context = context
        }

        init(jsonDictionary:JSONDictionary) throws {
            template = try jsonDictionary.json(atKeyPath: "template")
            path = try jsonDictionary.json(atKeyPath: "path")
            context = jsonDictionary.json(atKeyPath: "context")
        }
    }

    let files:[File]
    let path:Path
    let formatter:String

    init(path:Path) throws {
        self.path = path
        let templatePath = path + "template.json"
        let data:Data = try templatePath.read()
        let json = try JSONDictionary.from(jsonData: data)
        files = try json.json(atKeyPath: "files")
        formatter = try json.json(atKeyPath: "formatter")
    }

}

enum CodegenError:Error {
    case ContextNotFound(name:String, context:[String:Any?])
}

class Codegen {

    var destination:Path
    var templateConfig:TemplateConfig
    let context:JSONDictionary

    init(context:JSONDictionary, destination:Path, templateConfig:TemplateConfig) {
        self.context = context
        self.destination = destination
        self.templateConfig = templateConfig
    }

    func generate() throws {

        for file in templateConfig.files {
            let path = templateConfig.path + file.template
            let template = try Template(path: path.description)

            if let fileContext = file.context {
                if let context:JSONDictionary = context.json(atKeyPath: fileContext) {
                    try writeFile(template: template, context: context, path: file.path)
                }
                else if let contexts:[JSONDictionary] = context.json(atKeyPath: fileContext) {
                    for context in contexts {
                        try writeFile(template: template, context: context, path: file.path)
                    }
                }
            }
            else {
                try writeFile(template: template, context: context, path: file.path)
            }
        }
    }


    func writeFile(template:Template, context:JSONDictionary, path:String) throws {

        template.registerDefaultFilters()

        let pathTemplate = try Template(string: path)
        pathTemplate.registerDefaultFilters()
        let contextPath = try pathTemplate.render(context)

        let outputPath:Path = destination + contextPath
        let rendered = try template.render(context)
        try outputPath.parent().mkpath()
        try outputPath.write(rendered)
        print("Write file \(outputPath)")
    }
}

extension Template {
    func registerDefaultFilters() {
        register(Filter({ (value:String?) -> Any? in
            return value?.lowerCamelCased()
        }), forKey: "lowerCamelCase")

        register(Filter({ (value:String?) -> Any? in
            return value?.upperCamelCased()
        }), forKey: "upperCamelCase")
        register(StandardLibrary.each, forKey: "each")
    }
}

