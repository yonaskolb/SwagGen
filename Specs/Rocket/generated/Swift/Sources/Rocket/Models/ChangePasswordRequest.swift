//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

public class ChangePasswordRequest: JSONDecodable, JSONEncodable, PrettyPrintable {

    /** The new password for the account. */
    public var password: String

    public init(password: String) {
        self.password = password
    }

    public required init(jsonDictionary: JSONDictionary) throws {
        password = try jsonDictionary.json(atKeyPath: "password")
    }

    public func encode() -> JSONDictionary {
        var dictionary: JSONDictionary = [:]
        dictionary["password"] = password
        return dictionary
    }

    /// pretty prints all properties including nested models
    public var prettyPrinted: String {
        return "\(type(of: self)):\n\(encode().recursivePrint(indentIndex: 1))"
    }
}
