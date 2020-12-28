import JSONUtilities

public struct NumberSchema {
    public let format: NumberFormat?
    public let maximum: Double?
    public let exclusiveMaximum: Double?
    public let minimum: Double?
    public let exclusiveMinimum: Double?
    public let multipleOf: Double?

    public init(format: NumberFormat? = nil,
                minimum: Double? = nil,
                exclusiveMinimum: Double? = nil,
                maximum: Double? = nil,
                exclusiveMaximum: Double? = nil,
                multipleOf: Double? = nil) {
        self.format = format
        self.minimum = minimum
        self.exclusiveMinimum = exclusiveMinimum
        self.maximum = maximum
        self.exclusiveMaximum = exclusiveMaximum
        self.multipleOf = multipleOf
    }
}

public enum NumberFormat: String {
    case float
    case double
    case decimal
}

extension NumberSchema {

    public init(jsonDictionary: JSONDictionary) {
        format = jsonDictionary.json(atKeyPath: "format")
        maximum = jsonDictionary.json(atKeyPath: "maximum")
        exclusiveMaximum = jsonDictionary.json(atKeyPath: "exclusiveMaximum")
        minimum = jsonDictionary.json(atKeyPath: "minimum")
        exclusiveMinimum = jsonDictionary.json(atKeyPath: "exclusiveMinimum")
        multipleOf = jsonDictionary.json(atKeyPath: "multipleOf")
    }
}
