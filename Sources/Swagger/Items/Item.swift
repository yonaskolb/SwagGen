import JSONUtilities

public struct Item {
    public let metadata: Metadata
    public let type: ItemType
}

public indirect enum ItemType {
    case boolean
    case string(StringItem)
    case number(NumberItem)
    case integer(IntegerItem)
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
        let dataType = DataType(jsonDictionary: jsonDictionary )
        switch dataType {
        case .string:
            self = .string(try StringItem(jsonDictionary: jsonDictionary ))
        case .number:
            self = .number(try NumberItem(jsonDictionary: jsonDictionary ))
        case .integer:
            self = .integer(try IntegerItem(jsonDictionary: jsonDictionary ))
        case .array:
            self = .array(try ArrayItem(jsonDictionary: jsonDictionary ))
        case .boolean:
            self = .boolean
        case .object, .allOf, .reference, .file, .any:
            throw SwaggerError.incorrectArrayDataType(dataType)
        }
    }
}
