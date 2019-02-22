import JSONUtilities

public struct Parameter {

    public let name: String
    public let location: ParameterLocation
    public let description: String?
    public let required: Bool
    public let example: Any?
    public let type: ParameterType
    public let json: [String: Any]

}

public struct ParameterSchema {
    public let schema: Schema
    public let serializationStyle: SerializationStyle
    public let explode: Bool
}

public enum ParameterLocation: String {
    case query
    case header
    case path
    case cookie
}

public enum ParameterType {
    case content(Content)
    case schema(ParameterSchema)
}

extension Parameter: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        name = try jsonDictionary.json(atKeyPath: "name")
        let location: ParameterLocation = try jsonDictionary.json(atKeyPath: "in")
        self.location = location
        description = jsonDictionary.json(atKeyPath: "description")
        required = (jsonDictionary.json(atKeyPath: "required")) ?? false
        example = jsonDictionary["example"]

        if jsonDictionary["content"] != nil {
            let content: Content = try jsonDictionary.json(atKeyPath: "content")
            type = .content(content)
        } else {
            let schema: Schema = try jsonDictionary.json(atKeyPath: "schema")
            let serializationStyle: SerializationStyle = jsonDictionary.json(atKeyPath: "style") ?? location.defaultSerializationStyle
            let explode: Bool = jsonDictionary.json(atKeyPath: "explode") ?? (serializationStyle == .form ? true : false)
            let parameterSchema = ParameterSchema(schema: schema, serializationStyle: serializationStyle, explode: explode)
            type = .schema(parameterSchema)
        }
    }
}
