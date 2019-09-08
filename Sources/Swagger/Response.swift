import JSONUtilities

public struct OperationResponse {
    public let statusCode: Int?
    public let response: PossibleReference<Response>
}

public struct Response {

    public let description: String
    public let content: Content?
    public let headers: [String: PossibleReference<Header>]
}

public struct Header {

    public let description: String?
    public let required: Bool
    public let example: Any?
    public let schema: ParameterSchema
}

extension Header: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        description = jsonDictionary.json(atKeyPath: "description")
        required = (jsonDictionary.json(atKeyPath: "required")) ?? false
        example = jsonDictionary["example"]

        let schema: Schema = try jsonDictionary.json(atKeyPath: "schema")
        let serializationStyle: SerializationStyle = jsonDictionary.json(atKeyPath: "style") ?? ParameterLocation.header.defaultSerializationStyle
        let explode: Bool = jsonDictionary.json(atKeyPath: "explode") ?? serializationStyle == .form ? true : false
        self.schema = ParameterSchema(schema: schema, serializationStyle: serializationStyle, explode: explode)
    }
}

extension Response: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        description = jsonDictionary.json(atKeyPath: "description") ?? ""
        content = jsonDictionary.json(atKeyPath: "content")
        headers = jsonDictionary.json(atKeyPath: "headers") ?? [:]
    }
}
