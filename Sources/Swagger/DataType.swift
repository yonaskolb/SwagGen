import Foundation
import JSONUtilities

public enum DataType: String {
    case array
    case object
    case string
    case number
    case integer
    case boolean
    case file
    case allOf
    case reference
    case any
}

extension DataType: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) {
        if let typeString: String = jsonDictionary.json(atKeyPath: "type"),
            let dataType = DataType(rawValue: typeString) {
            self = dataType
        } else if jsonDictionary["$ref"] != nil {
            self = .reference
        } else if jsonDictionary["items"] != nil {
            // Implicit array
            self = .array
        } else if jsonDictionary["properties"] != nil {
            // Implicit object
            self = .object
        } else if jsonDictionary["allOf"] != nil {
            self = .allOf
        } else {
            self = .any
        }
    }
}
