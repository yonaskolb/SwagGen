import Foundation
import JSONUtilities

public struct APIKeySchema {
    public let headerName: String
    public let keyLocation: Location

    public enum Location: String {
        case query
        case header
    }
}

extension APIKeySchema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        headerName = try jsonDictionary.json(atKeyPath: "name")
        keyLocation = try jsonDictionary.json(atKeyPath: "in")
    }
}
