//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension Rocket.Account {

    /** Get a registered device. */
    public enum GetDevice {

      public static let service = APIService<Response>(id: "getDevice", tag: "account", method: "GET", path: "/account/devices/{id}", hasBody: false, authorization: Authorization(type: "accountAuth", scope: "Catalog"))

      public class Request: APIRequest<Response> {

          public struct Options {

              /** The unique identifier for the registered device e.g. serial number. */
              public var id: String

              public init(id: String) {
                  self.id = id
              }
          }

          public var options: Options

          public init(options: Options) {
              self.options = options
              super.init(service: GetDevice.service)
          }

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init(id: String) {
              let options = Options(id: id)
              self.init(options: options)
          }

          public override var path: String {
              return super.path.replacingOccurrences(of: "{" + "id" + "}", with: "\(self.options.id)")
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Device

            /** OK */
            case success200(Device)

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

            public var success: Device? {
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
            public var responseResult: APIResponseResult<Device, ServiceError> {
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
