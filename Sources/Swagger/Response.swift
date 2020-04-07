import JSONUtilities

public struct OperationResponse {
    public let statusCode: Int?
    public let response: PossibleReference<Response>
}

public struct Response {

    public let description: String
    public let schema: PossibleReference<Schema>?
    public let headers: [String: Item]
}

extension Response: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        description = try jsonDictionary.json(atKeyPath: "description")
        schema = jsonDictionary.json(atKeyPath: "schema")
        headers = jsonDictionary.json(atKeyPath: "headers") ?? [:]
    }
}
