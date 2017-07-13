import JSONUtilities

public struct Item {
    public let metadata: Metadata
    public let type: ItemType
}

public indirect enum ItemType {
    case simpleType(SimpleType)
    case array(ArrayItem)
}

extension Item: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        metadata = try Metadata(jsonDictionary: jsonDictionary )
        type = try ItemType(jsonDictionary: jsonDictionary )
    }
}

extension ItemType: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        if let simpleType = SimpleType(jsonDictionary: jsonDictionary) {
            self = .simpleType(simpleType)
        } else if let dataType = DataType(jsonDictionary: jsonDictionary), dataType == .array {
            self = .array(try ArrayItem(jsonDictionary: jsonDictionary ))
        } else {
            throw SwaggerError.incorrectItemType(jsonDictionary)
        }
    }
}
