import Foundation
import JSONUtilities

public struct APIKeySchema {
    public let name: String
    public let keyLocation: Location

    public enum Location: String {
        case query
        case header
        case cookie
    }
}

extension APIKeySchema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        name = try jsonDictionary.json(atKeyPath: "name")
        keyLocation = try jsonDictionary.json(atKeyPath: "in")
    }
}
