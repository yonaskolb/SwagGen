import JSONUtilities
import Foundation

public enum SwaggerError: Error, CustomStringConvertible {

    case invalidVersion(String)
    case invalidItemType(JSONDictionary)
    case invalidSchemaType(JSONDictionary)
    case invalidArraySchema([String: Any])
    case loadError(URL)

    public var description: String {
        switch self {

        case .invalidVersion(let version):
            return "Invalid version \(version)"
        case .invalidItemType(let dictionary):
            return "Invalid item type:\n\(dictionary)"
        case .invalidSchemaType(let dictionary):
            return "Invalid schema type:\n\(dictionary)"
        case .invalidArraySchema(let array):
            return "Invalid array schema:\n\(array)"
        case .loadError(let url):
            return "Couldn't load url \(url)"
        }
    }
}
