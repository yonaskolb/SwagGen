import JSONUtilities

public struct IntegerSchema {
    public let format: IntegerFormat?
    public let minimum: Int?
    public let maximum: Int?
    public let exclusiveMinimum: Int?
    public let exclusiveMaximum: Int?
    public let multipleOf: Int?

    public init(format: IntegerFormat? = nil,
                minimum: Int? = nil,
                maximum: Int? = nil,
                exclusiveMinimum: Int? = nil,
                exclusiveMaximum: Int? = nil,
                multipleOf: Int? = nil) {
        self.format = format
        self.minimum = minimum
        self.maximum = maximum
        self.exclusiveMinimum = exclusiveMinimum
        self.exclusiveMaximum = exclusiveMaximum
        self.multipleOf = multipleOf
    }
}

public enum IntegerFormat: String {
    case int32
    case int64
}

extension IntegerSchema {

    public init(jsonDictionary: JSONDictionary) {
        format = jsonDictionary.json(atKeyPath: "format")

        minimum = jsonDictionary.json(atKeyPath: "minimum")
        maximum = jsonDictionary.json(atKeyPath: "maximum")
        exclusiveMinimum = jsonDictionary.json(atKeyPath: "exclusiveMinimum")
        exclusiveMaximum = jsonDictionary.json(atKeyPath: "exclusiveMaximum")
        multipleOf = jsonDictionary.json(atKeyPath: "multipleOf")
    }
}
