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

    let templateFiles: [TemplateFile]
    let copiedFiles: [Path]
    let path: Path
    let formatter: String
    let options: [String: Any]

    init(path: Path, options: [String: String]) throws {
        self.path = path
        let templatePath = path + "template.json"
        let data = try templatePath.read()
        let json = try JSONDictionary.from(jsonData: data)
        templateFiles = try json.json(atKeyPath: "templateFiles")
        copiedFiles = (json.json(atKeyPath: "copiedFiles") as [String]? ?? []).map{Path($0)}
        formatter = try json.json(atKeyPath: "formatter")
        let templateOptions: [String: String] = json.json(atKeyPath: "options") ?? [:]
        self.options = templateOptions + options
    }
}

struct TemplateFile: JSONObjectConvertible {

    let path: String
    let destination: String?
    let context: String?

    init(path: String, destination: String?, context: String?) {
        self.path = path
        self.destination = destination
        self.context = context
    }

    init(jsonDictionary: JSONDictionary) throws {
        path = try jsonDictionary.json(atKeyPath: "path")
        destination = jsonDictionary.json(atKeyPath: "destination")
        context = jsonDictionary.json(atKeyPath: "context")
    }
}
