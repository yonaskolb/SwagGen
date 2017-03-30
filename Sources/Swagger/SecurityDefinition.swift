//
//  Security.swift
//  SwagGen
//
//  Created by Yonas Kolb on 30/3/17.
//
//

import Foundation
import JSONUtilities

public struct SecurityDefinition: JSONObjectConvertible {

    public var type: SecurityType
    public var description: String?
    public var jsonDictionary: JSONDictionary

    public enum SecurityType {
        case basic
        case apiKey(APIKey)
        case oauth2(OAuth2)
    }

    public init(jsonDictionary: JSONDictionary) throws {

        self.jsonDictionary = jsonDictionary
        enum SecurityTypeString: String {
            case basic
            case apiKey
            case oauth2
        }

        let securityType: SecurityTypeString = try jsonDictionary.json(atKeyPath: "type")
        description = jsonDictionary.json(atKeyPath: "description")

        switch securityType {
        case .basic:
            type = .basic
        case .apiKey:
            type = .apiKey(try APIKey(jsonDictionary: jsonDictionary))
        case .oauth2:
            type = .oauth2(try OAuth2(jsonDictionary: jsonDictionary))
        }
    }

    func deepDescription(prefix: String) -> String {
        return "\(prefix)\(type)"
    }
}

public struct OAuth2: JSONObjectConvertible {
    public let type: FlowType
    public let authorizationURL: URL?
    public let tokenURL: URL?
    public let scopes: [String : String]

    public enum FlowType: String {
        case implicit
        case password
        case application
        case accessCode
    }

    public init(jsonDictionary: JSONDictionary) throws {
        type = try jsonDictionary.json(atKeyPath: "flow")
        authorizationURL = jsonDictionary.json(atKeyPath: "authorizationUrl")
        tokenURL = jsonDictionary.json(atKeyPath: "tokenUrl")
        scopes = try jsonDictionary.json(atKeyPath: "scopes")
    }
}

public struct APIKey: JSONObjectConvertible {
    public let headerName: String
    public let location: Location

    public enum Location: String {
        case query
        case header
    }

    public init(jsonDictionary: JSONDictionary) throws {
        headerName = try jsonDictionary.json(atKeyPath: "name")
        location = try jsonDictionary.json(atKeyPath: "in")
    }
}
