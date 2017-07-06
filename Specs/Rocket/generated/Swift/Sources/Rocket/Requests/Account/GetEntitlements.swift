//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension Rocket.Account {

    /** Get all entitlements under the account.

This list is returned under the call to get account information so a call here is
only required when wishing to refresh a local copy of entitlements.
 */
    public enum GetEntitlements {

      public static let service = APIService<Response>(id: "getEntitlements", tag: "account", method: "GET", path: "/account/entitlements", hasBody: false, authorization: Authorization(type: "accountAuth", scope: "Catalog"))

      public class Request: APIRequest<Response> {

          public init() {
              super.init(service: GetEntitlements.service)
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = [Entitlement]

            /** OK */
            case success200([Entitlement])

            /** Bad request. */
            case failure400(ServiceError)

            /** Invalid access token. */
            case failure401(ServiceError)

            /** Forbidden. */
            case failure403(ServiceError)

            /** Not found. */
            case failure404(ServiceError)

            /** Internal server error. */
            case failure500(ServiceError)

            /** Service error. */
            case failureDefault(statusCode: Int, ServiceError)

            public var success: [Entitlement]? {
                switch self {
                case .success200(let response): return response
                default: return nil
                }
            }

            public var failure: ServiceError? {
                switch self {
                case .failure400(let response): return response
                case .failure401(let response): return response
                case .failure403(let response): return response
                case .failure404(let response): return response
                case .failure500(let response): return response
                case .failureDefault(_, let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<[Entitlement], ServiceError> {
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
                case .success200(let response): return response
                case .failure400(let response): return response
                case .failure401(let response): return response
                case .failure403(let response): return response
                case .failure404(let response): return response
                case .failure500(let response): return response
                case .failureDefault(_, let response): return response
                }
            }

            public var statusCode: Int {
              switch self {
              case .success200: return 200
              case .failure400: return 400
              case .failure401: return 401
              case .failure403: return 403
              case .failure404: return 404
              case .failure500: return 500
              case .failureDefault(let statusCode, _): return statusCode
              }
            }

            public var successful: Bool {
              switch self {
              case .success200: return true
              case .failure400: return false
              case .failure401: return false
              case .failure403: return false
              case .failure404: return false
              case .failure500: return false
              case .failureDefault: return false
              }
            }

            public init(statusCode: Int, data: Data) throws {
                switch statusCode {
                case 200: self = try .success200(JSONDecoder.decode(data: data))
                case 400: self = try .failure400(JSONDecoder.decode(data: data))
                case 401: self = try .failure401(JSONDecoder.decode(data: data))
                case 403: self = try .failure403(JSONDecoder.decode(data: data))
                case 404: self = try .failure404(JSONDecoder.decode(data: data))
                case 500: self = try .failure500(JSONDecoder.decode(data: data))
                default: self = try .failureDefault(statusCode: statusCode, JSONDecoder.decode(data: data))
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
