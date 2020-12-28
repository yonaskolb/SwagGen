import JSONUtilities

public struct Metadata {
    public let type: DataType?
    public let title: String?
    public let description: String?
    public let defaultValue: Any?
    public let enumValues: [Any]?
    public let enumNames: [String]?
    public let nullable: Bool
    public let example: Any?
    public var json: JSONDictionary

    public init() {
        type = nil
        title = nil
        description = nil
        defaultValue = nil
        enumValues = nil
        enumNames = nil
        nullable = false
        example = nil
        json = [:]
    }
}

extension Metadata: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        type = DataType(jsonDictionary: jsonDictionary)
        title = jsonDictionary.json(atKeyPath: "title")
        description = jsonDictionary.json(atKeyPath: "description")
        defaultValue = jsonDictionary["default"]
        enumValues = jsonDictionary["enum"] as? [Any]
        enumNames = jsonDictionary["x-enum-names"] as? [String]
        nullable = jsonDictionary.json(atKeyPath: "nullable") ?? jsonDictionary.json(atKeyPath: "x-nullable") ?? false
        example = jsonDictionary["example"]
        json = jsonDictionary
    }
}
