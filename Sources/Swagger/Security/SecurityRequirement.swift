import Foundation
import JSONUtilities

public struct SecurityRequirement: JSONObjectConvertible {
    public let name: String
    public let scopes: [String]

    public init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.keys.first!
        scopes = try jsonDictionary.json(atKeyPath: .key(name))
    }
}
