import JSONUtilities

public struct Schema {
    public let metadata: Metadata
    public let type: SchemaType

    public init(metadata: Metadata, type: SchemaType) {
        self.metadata = metadata
        self.type = type
    }
}

public enum SchemaType {
    indirect case reference(Reference<Schema>)
    indirect case object(ObjectSchema)
    indirect case array(ArraySchema)
    indirect case group(GroupSchema)
    case boolean
    case string(StringSchema)
    case number(NumberSchema)
    case integer(IntegerSchema)
    case any

    public var object: ObjectSchema? {
        switch self {
        case let .object(schema): return schema
        default: return nil
        }
    }

    public var reference: Reference<Schema>? {
        switch self {
        case let .reference(reference): return reference
        default: return nil
        }
    }

    public var isPrimitive: Bool {
        switch self {
        case .boolean, .string, .number, .integer: return true
        case .reference, .object, .array, .group, .any: return false
        }
    }
}

extension Schema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        metadata = try Metadata(jsonDictionary: jsonDictionary)
        type = try SchemaType(jsonDictionary: jsonDictionary)
    }
}

extension SchemaType: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        if let dataType = DataType(jsonDictionary: jsonDictionary) {
            switch dataType {
            case .array:
                self = .array(try ArraySchema(jsonDictionary: jsonDictionary))
            case .object:
                self = .object(try ObjectSchema(jsonDictionary: jsonDictionary))
            case .string:
                self = .string(StringSchema(jsonDictionary: jsonDictionary))
            case .number:
                self = .number(NumberSchema(jsonDictionary: jsonDictionary))
            case .integer:
                self = .integer(IntegerSchema(jsonDictionary: jsonDictionary))
            case .boolean:
                self = .boolean
            }
        } else if jsonDictionary["$ref"] != nil {
            self = .reference(try Reference(jsonDictionary: jsonDictionary))
        } else if jsonDictionary["allOf"] != nil {
            let group = try GroupSchema(jsonDictionary: jsonDictionary, type: .all)
            self = .group(group)
        } else if jsonDictionary["anyOf"] != nil {
            let group = try GroupSchema(jsonDictionary: jsonDictionary, type: .any)
            self = .group(group)
        } else if jsonDictionary["oneOf"] != nil {
            let group = try GroupSchema(jsonDictionary: jsonDictionary, type: .one)
            self = .group(group)
        } else {
            self = .any
        }
    }
}
