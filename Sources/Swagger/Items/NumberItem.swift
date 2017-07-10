import JSONUtilities

public struct NumberItem {
    public let format: NumberFormat?
    public let maximum: Double?
    public let exclusiveMaximum: Double?
    public let minimum: Double?
    public let exclusiveMinimum: Double?
    public let multipleOf: Double?
}

extension NumberItem: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        format = jsonDictionary.json(atKeyPath: "format")
        maximum = jsonDictionary.json(atKeyPath: "maximum")
        exclusiveMaximum = jsonDictionary.json(atKeyPath: "exclusiveMaximum")
        minimum = jsonDictionary.json(atKeyPath: "minimum")
        exclusiveMinimum = jsonDictionary.json(atKeyPath: "exclusiveMinimum")
        multipleOf = jsonDictionary.json(atKeyPath: "multipleOf")
    }
}
