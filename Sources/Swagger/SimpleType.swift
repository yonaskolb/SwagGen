import JSONUtilities

public enum SimpleType {
    case boolean
    case string(StringItem)
    case number(NumberItem)
    case integer(IntegerItem)
}

extension SimpleType {

    public init?(jsonDictionary: JSONDictionary) {
        if let typeString: String = jsonDictionary.json(atKeyPath: "type"),
            let dataType = DataType(rawValue: typeString) {
            switch dataType {
            case .string:
                self = .string(StringItem(jsonDictionary: jsonDictionary))
            case .number:
                self = .number(NumberItem(jsonDictionary: jsonDictionary))
            case .integer:
                self = .integer(IntegerItem(jsonDictionary: jsonDictionary))
            case .boolean:
                self = .boolean
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
