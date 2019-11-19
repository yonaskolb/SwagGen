import Foundation
import JSONUtilities
import PathKit
import Yams

public struct TemplateConfig {

    public let templateFiles: [TemplateFile]
    public let copiedFiles: [Path]
    public let basePath: Path
    public let formatter: String?
    public let options: [String: Any]

    public init(path: Path, options: [String: Any]) throws {
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
        self.options = templateOptions.merging(options) { templateOption, option in
            guard let templateOptionDict = templateOption as? [String: Any],
                let optionDict = option as? [String: Any] else {
                    return option
            }
            return templateOptionDict.merging(optionDict) { templateOptionValue, optionValue in
                optionValue
            }
        }
    }

    public func getStringOption(_ option: String) -> String? {
        return options[option] as? String
    }

    public func getBooleanOption(_ option: String) -> Bool? {
        if let bool = options[option] as? Bool {
            return bool
        } else if let string = options[option] as? String {
            let lowercaseString = string.lowercased()
            return lowercaseString == "true" || lowercaseString == "yes"
        } else {
            return nil
        }
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
