import JSONUtilities

public struct ObjectSchema {
    public let requiredProperties: [Property]
    public let optionalProperties: [Property]
    public let properties: [Property]
    public let minProperties: Int?
    public let maxProperties: Int?
    public let additionalProperties: AdditionalProperties
    public let discriminator: String?
    public let abstract: Bool
}

extension ObjectSchema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        let requiredPropertyNames: [String] = (jsonDictionary.json(atKeyPath: "required")) ?? []
        let propertiesByName: [String: Schema] = (jsonDictionary.json(atKeyPath: "properties")) ?? [:]

        requiredProperties = requiredPropertyNames.compactMap { name in
            if let schema = propertiesByName[name] {
                return Property(name: name, required: true, schema: schema)
            }
            return nil
        }

        optionalProperties = propertiesByName.compactMap { name, schema in
            if !requiredPropertyNames.contains(name) {
                return Property(name: name, required: false, schema: schema)
            }
            return nil
        }.sorted { $0.name < $1.name }

        properties = requiredProperties + optionalProperties

        minProperties = jsonDictionary.json(atKeyPath: "minProperties")
        maxProperties = jsonDictionary.json(atKeyPath: "maxProperties")
        additionalProperties = AdditionalProperties(jsonDictionary: jsonDictionary, key: "additionalProperties")
        discriminator = jsonDictionary.json(atKeyPath: "discriminator")
        abstract = (jsonDictionary.json(atKeyPath: "x-abstract")) ?? false
    }
}
