import Foundation
import JSONUtilities

public enum SecuritySchemaType {
    case basic
    case apiKey(APIKeySchema)
    case oauth2(OAuth2Schema)

    enum SimpleType: String {
        case basic
        case apiKey
        case oauth2
    }
}

public struct SecuritySchema {

    public let json: [String: Any]
    public let name: String
    public let description: String?
    public let type: SecuritySchemaType
}

extension SecuritySchema: NamedMappable {

    public init(name: String, jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        self.name = name
        description = jsonDictionary.json(atKeyPath: "description")

        let securityType: SecuritySchemaType.SimpleType = try jsonDictionary.json(atKeyPath: "type")
        switch securityType {
        case .basic:
            type = .basic
        case .apiKey:
            type = .apiKey(try APIKeySchema(jsonDictionary: jsonDictionary ))
        case .oauth2:
            type = .oauth2(try OAuth2Schema(jsonDictionary: jsonDictionary ))
        }
    }
}
