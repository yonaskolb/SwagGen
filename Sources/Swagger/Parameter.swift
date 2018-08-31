import JSONUtilities

public struct Parameter {

    public let name: String
    public let location: ParameterLocation
    public let description: String?
    public let required: Bool
    public let example: Any?

    public let type: ParameterType

    public var metadata: Metadata {
        switch type {
        case let .body(schema): return schema.metadata
        case let .other(item): return item.metadata
        }
    }
}

public enum ParameterLocation: String {
    case query
    case header
    case path
    case formData
    case body
}

public enum ParameterType {
    case body(schema: Schema)
    case other(item: Item)
}

extension Parameter: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        name = try jsonDictionary.json(atKeyPath: "name")
        location = try jsonDictionary.json(atKeyPath: "in")
        description = jsonDictionary.json(atKeyPath: "description")
        required = (jsonDictionary.json(atKeyPath: "required")) ?? false
        example = jsonDictionary["example"] ?? jsonDictionary["x-example"]

        switch location {
        case .body:
            type = .body(schema: try jsonDictionary.json(atKeyPath: "schema"))
        case .query, .header, .path, .formData:
            type = .other(item: try Item(jsonDictionary: jsonDictionary))
        }
    }
}
