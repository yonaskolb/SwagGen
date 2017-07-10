import Foundation
import JSONUtilities

public struct License {

    public let name: String
    public let url: URL?
}

extension License: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        name = try jsonDictionary.json(atKeyPath: "name")
        url = jsonDictionary.json(atKeyPath: "url")
    }
}
