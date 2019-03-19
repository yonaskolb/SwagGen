import Foundation
import JSONUtilities

public enum SecuritySchemeType {
    case http(scheme: String, bearerFormat: String?)
    case apiKey(APIKeySchema)
    case oauth2(OAuth2Schema)
    case openIdConnect(URL)

    enum SimpleType: String {
        case http
        case apiKey
        case oauth2
        case openIdConnect
    }
}

public struct SecurityScheme {

    public let json: [String: Any]
    public let description: String?
    public let type: SecuritySchemeType
}

extension SecurityScheme: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        description = jsonDictionary.json(atKeyPath: "description")

        let securityType: SecuritySchemeType.SimpleType = try jsonDictionary.json(atKeyPath: "type")
        switch securityType {
        case .http:
            let scheme: String = try jsonDictionary.json(atKeyPath: "scheme")
            let bearerFormat: String? = jsonDictionary.json(atKeyPath: "bearerFormat")
            type = .http(scheme: scheme, bearerFormat: bearerFormat)
        case .apiKey:
            type = .apiKey(try APIKeySchema(jsonDictionary: jsonDictionary))
        case .oauth2:
            type = .oauth2(try OAuth2Schema(jsonDictionary: jsonDictionary))
        case .openIdConnect:
            type = .openIdConnect(try jsonDictionary.json(atKeyPath: "openIdConnectUrl"))
        }
    }
}
