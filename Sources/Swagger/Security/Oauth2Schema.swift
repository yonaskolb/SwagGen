import Foundation
import JSONUtilities

public struct OAuth2Schema {
    public let type: FlowType
    public let authorizationURL: URL?
    public let tokenURL: URL?
    public let scopes: [String: String]

    public enum FlowType: String {
        case implicit
        case password
        case application
        case accessCode
    }
}

extension OAuth2Schema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        type = try jsonDictionary.json(atKeyPath: "flow")
        authorizationURL = jsonDictionary.json(atKeyPath: "authorizationUrl")
        tokenURL = jsonDictionary.json(atKeyPath: "tokenUrl")
        scopes = try jsonDictionary.json(atKeyPath: "scopes")
    }
}
