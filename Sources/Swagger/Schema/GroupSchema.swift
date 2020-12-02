import JSONUtilities

public struct GroupSchema {
    public let schemas: [Schema]
    public let discriminator: Discriminator?
    public let type: GroupType

    public enum GroupType {
        case all
        case one
        case any

        var propertyName: String {
            switch self {
            case .all: return "allOf"
            case .one: return "oneOf"
            case .any: return "anyOf"
            }
        }
    }

    public init(schemas: [Schema], discriminator: Discriminator? = nil, type: GroupType) {
        self.schemas = schemas
        self.discriminator = discriminator
        self.type = type
    }
}

extension GroupSchema {

    public init(jsonDictionary: JSONDictionary, type: GroupType) throws {
        self.type = type
        schemas = try jsonDictionary.json(atKeyPath: .key(type.propertyName))
        discriminator = jsonDictionary.json(atKeyPath: "discriminator")
    }
}
