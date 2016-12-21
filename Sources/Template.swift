//
//  Template.swift
//  SwagGen
//
//  Created by Yonas Kolb on 21/12/16.
//
//

import Foundation
import JSONUtilities
import PathKit

struct TemplateConfig {

    let files: [TemplateFile]
    let path: Path
    let formatter: String
    let options: [String: Any]

    init(path: Path, options: [String: String]) throws {
        self.path = path
        let templatePath = path + "template.json"
        let data = try templatePath.read()
        let json = try JSONDictionary.from(jsonData: data)
        files = try json.json(atKeyPath: "files")
        formatter = try json.json(atKeyPath: "formatter")
        let templateOptions: [String: String] = json.json(atKeyPath: "options") ?? [:]
        self.options = templateOptions + options
    }
}

struct TemplateFile: JSONObjectConvertible {

    let template: String
    let path: String
    let context: String?

    init(template: String, path: String, context: String?) {
        self.template = template
        self.path = path
        self.context = context
    }

    init(jsonDictionary: JSONDictionary) throws {
        template = try jsonDictionary.json(atKeyPath: "template")
        path = try jsonDictionary.json(atKeyPath: "path")
        context = jsonDictionary.json(atKeyPath: "context")
    }
}
