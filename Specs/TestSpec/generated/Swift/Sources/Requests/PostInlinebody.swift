//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension Operation {

    /** operation with an inline body */
    public enum PostInlinebody {

        public static let service = APIService<Response>(id: "postInlinebody", tag: "", method: "POST", path: "/inlinebody", hasBody: true, securityRequirement: SecurityRequirement(type: "test_auth", scopes: ["write"]))

        public final class Request: APIRequest<Response> {

            /** operation with an inline body */
            public class Body: APIModel {

                public var id: Int?

                public var name: String?

                public init(id: Int? = nil, name: String? = nil) {
                    self.id = id
                    self.name = name
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    id = try container.decodeIfPresent("id")
                    name = try container.decodeIfPresent("name")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(id, forKey: "id")
                    try container.encodeIfPresent(name, forKey: "name")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? Body else { return false }
                  guard self.id == object.id else { return false }
                  guard self.name == object.name else { return false }
                  return true
                }

                public static func == (lhs: Body, rhs: Body) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public var body: Body

            public init(body: Body) {
                self.body = body
                super.init(service: PostInlinebody.service) {
                    let jsonEncoder = JSONEncoder()
                    return try jsonEncoder.encode(body)
                }
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Void

            /** Empty response */
            case status201

            public var success: Void? {
                switch self {
                case .status201: return ()
                }
            }

            public var response: Any {
                switch self {
                default: return ()
                }
            }

            public var statusCode: Int {
                switch self {
                case .status201: return 201
                }
            }

            public var successful: Bool {
                switch self {
                case .status201: return true
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 201: self = .status201
                default: throw APIClientError.unexpectedStatusCode(statusCode: statusCode, data: data)
                }
            }

            public var description: String {
                return "\(statusCode) \(successful ? "success" : "failure")"
            }

            public var debugDescription: String {
                var string = description
                let responseString = "\(response)"
                if responseString != "()" {
                    string += "\n\(responseString)"
                }
                return string
            }
        }
    }
}
