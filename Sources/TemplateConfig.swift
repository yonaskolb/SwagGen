//
//  Template.swift
//  SwagGen
//
//  Created by Yonas Kolb on 21/12/16.
//
//

import Foundation
import PathKit
import Yams
import JSONUtilities

struct TemplateConfig {

    let templateFiles: [TemplateFile]
    let copiedFiles: [Path]
    let basePath: Path
    let formatter: String?
    let options: [String: Any]

    init(path: Path, options: [String: String]) throws {
        let templatePath: Path
        if path.isDirectory {
            basePath = path
            templatePath = path + "template.yml"
        }
        else {
            basePath = path.parent()
            templatePath = path
        }
        let data = try templatePath.read()
        let string = String(data: data, encoding: .utf8)!
        let yaml = try Yams.load(yaml: string)
        let json = yaml as! JSONDictionary
        templateFiles = json.json(atKeyPath: "templateFiles") ?? []
        copiedFiles = (json.json(atKeyPath: "copiedFiles") as [String]? ?? []).map{Path($0)}
        formatter = json.json(atKeyPath: "formatter")

        let templateOptions = json["options"] as? JSONDictionary ?? [:]
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
