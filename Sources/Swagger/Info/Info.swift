import JSONUtilities

public struct Info {

    public let title: String
    public let version: String
    public let description: String?
    public let termsOfService: String?
    public let contact: Contact?
    public let license: License?
}

extension Info: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        title = try jsonDictionary.json(atKeyPath: "title")
        version = try jsonDictionary.json(atKeyPath: "version")
        description = jsonDictionary.json(atKeyPath: "description")
        termsOfService = jsonDictionary.json(atKeyPath: "termsOfService")
        contact = jsonDictionary.json(atKeyPath: "contact")
        license = jsonDictionary.json(atKeyPath: "license")
    }
}
