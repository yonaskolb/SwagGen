import Foundation
import PathKit
import Yams
import JSONUtilities

public struct TemplateConfig {

    public let templateFiles: [TemplateFile]
    public let copiedFiles: [Path]
    public let basePath: Path
    public let formatter: String?
    public let options: [String: Any]

    public init(path: Path, options: [String: String]) throws {
        let templatePath: Path
        if path.isDirectory {
            basePath = path
            templatePath = path + "template.yml"
        } else {
            basePath = path.parent()
            templatePath = path
        }
        let data = try templatePath.read()
        let string = String(data: data, encoding: .utf8)!
        let yaml = try Yams.load(yaml: string)
        let json = yaml as! JSONDictionary
        templateFiles = json.json(atKeyPath: "templateFiles") ?? []
        copiedFiles = json.json(atKeyPath: "copiedFiles") ?? []
        formatter = json.json(atKeyPath: "formatter")

        let templateOptions = json["options"] as? JSONDictionary ?? [:]
        self.options = templateOptions + options
    }
}

public struct TemplateFile: JSONObjectConvertible {

    public let path: String
    public let destination: String?
    public let context: String?

    public init(path: String, destination: String?, context: String?) {
        self.path = path
        self.destination = destination
        self.context = context
    }

    public init(jsonDictionary: JSONDictionary) throws {
        path = try jsonDictionary.json(atKeyPath: "path")
        destination = jsonDictionary.json(atKeyPath: "destination")
        context = jsonDictionary.json(atKeyPath: "context")
    }
}
