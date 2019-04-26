//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension Operation {

    /** Posts a form */
    public enum UpdateWithForm {

        public static let service = APIService<Response>(id: "updateWithForm", tag: "", method: "POST", path: "/post-form", hasBody: true, securityRequirement: SecurityRequirement(type: "test_auth", scopes: ["read"]))

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** Updated name of the pet */
                public var name: String?

                /** Updated status of the pet */
                public var status: String?

                public init(name: String? = nil, status: String? = nil) {
                    self.name = name
                    self.status = status
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: UpdateWithForm.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(name: String? = nil, status: String? = nil) {
                let options = Options(name: name, status: status)
                self.init(options: options)
            }

            public override var formParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let name = options.name {
                  params["name"] = name
                }
                if let status = options.status {
                  params["status"] = status
                }
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Void

            /** Invalid input */
            case status405

            public var success: Void? {
                switch self {
                default: return nil
                }
            }

            public var response: Any {
                switch self {
                default: return ()
                }
            }

            public var statusCode: Int {
                switch self {
                case .status405: return 405
                }
            }

            public var successful: Bool {
                switch self {
                case .status405: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 405: self = .status405
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
