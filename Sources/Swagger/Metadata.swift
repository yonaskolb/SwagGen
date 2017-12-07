import JSONUtilities

public struct Metadata {
    public let type: DataType?
    public let title: String?
    public let description: String?
    public let defaultValue: Any?
    public let enumeratedValues: [Any]?
    public let nullable: Bool
    public let example: Any?
    public var json: JSONDictionary
}

extension Metadata: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        type = DataType(jsonDictionary: jsonDictionary)
        title = jsonDictionary.json(atKeyPath: "title")
        description = jsonDictionary.json(atKeyPath: "description")
        defaultValue = jsonDictionary.json(atKeyPath: "default")
        enumeratedValues = jsonDictionary["enum"] as? [Any]
        nullable = (jsonDictionary.json(atKeyPath: "x-nullable")) ?? false
        example = jsonDictionary.json(atKeyPath: "example")
        json = jsonDictionary
    }
}
