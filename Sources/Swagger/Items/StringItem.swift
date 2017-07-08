import JSONUtilities

public struct StringItem {
    public let format: StringFormat?
    public let maxLength: Int?
    public let minLength: Int?
}

extension StringItem: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        format = jsonDictionary.json(atKeyPath: "format")
        maxLength = jsonDictionary.json(atKeyPath: "maxLength")
        minLength = (jsonDictionary.json(atKeyPath: "minLength")) ?? 0
    }
}
