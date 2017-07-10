import Foundation
import JSONUtilities

public struct Contact {

    public let name: String?
    public let url: URL?
    public let email: String?
}

extension Contact: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.json(atKeyPath: "name")
        url = jsonDictionary.json(atKeyPath: "url")
        email = jsonDictionary.json(atKeyPath: "email")
    }
}
