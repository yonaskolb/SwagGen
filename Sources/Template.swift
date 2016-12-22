//
//  Template.swift
//  SwagGen
//
//  Created by Yonas Kolb on 21/12/16.
//
//

import Foundation
import PathKit
import Yaml
import JSONUtilities

struct TemplateConfig {

    let templateFiles: [TemplateFile]
    let copiedFiles: [Path]
    let path: Path
    let formatter: String?
    let options: [String: Any]

    init(path: Path, options: [String: String]) throws {
        self.path = path
        let templatePath = path + "template.yml"
        let data = try templatePath.read()
        let string = String(data: data, encoding: .utf8)!
        let yaml = try Yaml.load(string)
        templateFiles = yaml["templateFiles"].array?.map(TemplateFile.init) ?? []
        copiedFiles = yaml["copiedFiles"].array?.flatMap{$0.string.flatMap{Path($0)}} ?? []
        formatter = yaml["formatter"].string

        let templateOptions = yaml["options"].jsonDictionary ?? [:]
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

    init(yaml: Yaml) {
        path = yaml["path"].string ?? ""
        destination = yaml["destination"].string
        context = yaml["context"].string
    }
}
