import JSONUtilities

public struct Info {

    public let title: String
    public let description: String?
    public let termsOfService: String?
    public let contact: Contact?
    public let license: License?
    public let version: String
}

extension Info: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        title = try jsonDictionary.json(atKeyPath: "title")
        description = jsonDictionary.json(atKeyPath: "description")
        termsOfService = jsonDictionary.json(atKeyPath: "termsOfService")
        if let versionValue = jsonDictionary["version"] {
            version = String(describing: versionValue)
        } else {
            throw SwaggerError.incorrectVersion("")
        }
        contact = jsonDictionary.json(atKeyPath: "contact")
        license = jsonDictionary.json(atKeyPath: "license")
    }
}
