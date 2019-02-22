import Foundation
import JSONUtilities

public struct OAuth2Schema {

    public let flows: [FlowType: Flow]

    public struct Flow {
        public let authorizationURL: URL?
        public let tokenURL: URL?
        public let refreshUrl: URL?
        public let scopes: [String: String]
    }

    public enum FlowType: String {
        case implicit
        case password
        case clientCredentials
        case authorizationCode

        static let allCases: [FlowType] = [
            .implicit,
            .password,
            .clientCredentials,
            .authorizationCode,
        ]
    }
}

extension OAuth2Schema: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        var flows: [FlowType: Flow] = [:]
        for type in FlowType.allCases {
            if let flow: Flow = jsonDictionary.json(atKeyPath: .key(type.rawValue)) {
                flows[type] = flow
            }
        }
        self.flows = flows
    }
}

extension OAuth2Schema.Flow: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        authorizationURL = jsonDictionary.json(atKeyPath: "authorizationUrl")
        tokenURL = jsonDictionary.json(atKeyPath: "tokenUrl")
        refreshUrl = jsonDictionary.json(atKeyPath: "tokenUrl")
        scopes = try jsonDictionary.json(atKeyPath: "scopes")
    }
}
