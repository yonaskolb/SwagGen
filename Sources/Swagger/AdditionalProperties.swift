import JSONUtilities

public enum AdditionalProperties {
    case bool(Bool)
    case schema(Schema)

    public init(jsonDictionary: JSONDictionary, key: String) {
        if let bool: Bool = jsonDictionary.json(atKeyPath: .key(key)) {
            self = .bool(bool)
        } else if let schema: Schema = jsonDictionary.json(atKeyPath: .key(key)) {
            self = .schema(schema)
        } else {
            self = .bool(false)
        }
    }
}
