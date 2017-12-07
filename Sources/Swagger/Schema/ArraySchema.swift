import JSONUtilities

public struct ArraySchema {
    public let items: ArraySchemaItems
    public let minItems: Int?
    public let maxItems: Int?
    public let additionalItems: AdditionalProperties
    public let uniqueItems: Bool

    public enum ArraySchemaItems {
        case single(Schema)
        case multiple([Schema])
    }
}

extension ArraySchema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        let itemsKey = "items"
        if let single: Schema = jsonDictionary.json(atKeyPath: .key(itemsKey)) {
            items = .single(single)
        } else if let multiple: [Schema] = jsonDictionary.json(atKeyPath: .key(itemsKey)) {
            items = .multiple(multiple)
        } else {
            throw SwaggerError.incorrectArraySchema(jsonDictionary)
        }

        minItems = jsonDictionary.json(atKeyPath: "minItems")
        maxItems = jsonDictionary.json(atKeyPath: "maxItems")
        additionalItems = AdditionalProperties(jsonDictionary: jsonDictionary, key: "additionalItems")
        uniqueItems = jsonDictionary.json(atKeyPath: "uniqueItems") ?? false
    }
}
