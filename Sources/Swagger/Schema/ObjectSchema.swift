import JSONUtilities

public struct ObjectSchema {
    public let requiredProperties: [Property]
    public let optionalProperties: [Property]
    public let properties: [Property]
    public let minProperties: Int?
    public let maxProperties: Int?
    public let additionalProperties: Schema?
    public let abstract: Bool
    public let discriminator: Discriminator?
}

public struct Property {
    public let name: String
    public let required: Bool
    public let schema: Schema
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
        if let bool: Bool = jsonDictionary.json(atKeyPath: "additionalProperties") {
            if bool {
                additionalProperties = Schema(metadata: Metadata(), type: .any)
            } else {
                additionalProperties = nil
            }
        } else {
            additionalProperties = jsonDictionary.json(atKeyPath: "additionalProperties")
        }
        abstract = (jsonDictionary.json(atKeyPath: "x-abstract")) ?? false
        discriminator = jsonDictionary.json(atKeyPath: "discriminator")
    }
}
