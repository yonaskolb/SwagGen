//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension Pets {

    /** Create a pet */
    public enum CreatePets {

        public static let service = APIService<Response>(id: "createPets", tag: "pets", method: "POST", path: "/pets", hasBody: false, securityRequirement: SecurityRequirement(type: "petstore_auth", scopes: ["write:pets", "read:pets"]))

        public final class Request: APIRequest<Response> {

            public init() {
                super.init(service: CreatePets.service)
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Void

            /** Null response */
            case status201

            /** unexpected error */
            case defaultResponse(statusCode: Int, ErrorType)

            public var success: Void? {
                switch self {
                case .status201: return ()
                default: return nil
                }
            }

            public var failure: ErrorType? {
                switch self {
                case .defaultResponse(_, let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<Void, ErrorType> {
                if let successValue = success {
                    return .success(successValue)
                } else if let failureValue = failure {
                    return .failure(failureValue)
                } else {
                    fatalError("Response does not have success or failure response")
                }
            }

            public var response: Any {
                switch self {
                case .defaultResponse(_, let response): return response
                default: return ()
                }
            }

            public var statusCode: Int {
                switch self {
                case .status201: return 201
                case .defaultResponse(let statusCode, _): return statusCode
                }
            }

            public var successful: Bool {
                switch self {
                case .status201: return true
                case .defaultResponse: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 201: self = .status201
                default: self = try .defaultResponse(statusCode: statusCode, decoder.decode(ErrorType.self, from: data))
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
