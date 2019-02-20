import JSONUtilities

public struct GroupSchema {
    public let schemas: [Schema]
    public let abstract: Bool
    public let descriminator: Descriminator?
    public let type: GroupType

    public enum GroupType {
        case all
        case one
        case any
    }
}

extension GroupSchema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        if jsonDictionary["allOf"] != nil {
            type = .all
            schemas = try jsonDictionary.json(atKeyPath: "allOf")
        } else if jsonDictionary["oneOf"] != nil {
            type = .one
            schemas = try jsonDictionary.json(atKeyPath: "oneOf")
        } else if jsonDictionary["anyOf"] != nil {
            type = .any
            schemas = try jsonDictionary.json(atKeyPath: "anyOf")
        } else {
            throw SwaggerError.parseError("Couldn't parse group schema")
        }
        abstract = (jsonDictionary.json(atKeyPath: "x-abstract")) ?? false
        descriminator = jsonDictionary.json(atKeyPath: "descriminator")
    }
}

public struct Descriminator {

    public var propertyName: String
    public let mapping: [String: String]
}

extension Descriminator: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        propertyName = try jsonDictionary.json(atKeyPath: "propertyName")
        mapping = jsonDictionary.json(atKeyPath: "mapping") ?? [:]
    }
}
