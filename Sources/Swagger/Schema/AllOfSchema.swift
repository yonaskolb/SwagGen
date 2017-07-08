import JSONUtilities

public struct AllOfSchema {
    public let subschemas: [Schema]
    public let abstract: Bool
}

extension AllOfSchema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        subschemas = try jsonDictionary.json(atKeyPath: "allOf")
        abstract = (jsonDictionary.json(atKeyPath: "x-abstract")) ?? false
    }
}
