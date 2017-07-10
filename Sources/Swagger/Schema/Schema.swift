import JSONUtilities

public struct Schema {
    public let json: [String: Any]
    public let metadata: Metadata
    public let type: SchemaType
}

public enum SchemaType {
    indirect case reference(Reference<Schema>)
    indirect case object(ObjectSchema)
    indirect case array(ArraySchema)
    indirect case allOf(AllOfSchema)
    case string(StringFormat?)
    case number(NumberFormat?)
    case integer(IntegerFormat?)
    case boolean
    case file
    case any
}

extension Schema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        metadata = try Metadata(jsonDictionary: jsonDictionary )
        type = try SchemaType(jsonDictionary: jsonDictionary )
    }
}

extension SchemaType: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        let dataType = DataType(jsonDictionary: jsonDictionary )
        switch dataType {
        case .reference:
            self = .reference(try Reference(jsonDictionary: jsonDictionary ))
        case .object:
            self = .object(try ObjectSchema(jsonDictionary: jsonDictionary ))
        case .array:
            self = .array(try ArraySchema(jsonDictionary: jsonDictionary ))
        case .allOf:
            self = .allOf(try AllOfSchema(jsonDictionary: jsonDictionary ))
        case .string:
            self = .string(jsonDictionary.json(atKeyPath: "format"))
        case .number:
            self = .number(jsonDictionary.json(atKeyPath: "format"))
        case .integer:
            self = .integer(jsonDictionary.json(atKeyPath: "format"))
        case .boolean:
            self = .boolean
        case .file:
            self = .file
        case .any:
            self = .any
        }
    }
}
