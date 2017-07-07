//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension PetstoreTest.Pet {

    /** Multiple status values can be provided with comma separated strings */
    public enum FindPetsByStatus {

      public static let service = APIService<Response>(id: "findPetsByStatus", tag: "pet", method: "GET", path: "/pet/findByStatus", hasBody: false, authorization: Authorization(type: "petstore_auth", scope: "write:pets"))

      /** Status values that need to be considered for filter */
      public enum Status: String {
          case available = "available"
          case pending = "pending"
          case sold = "sold"

          public static let cases: [Status] = [
            .available,
            .pending,
            .sold,
          ]
      }

      public class Request: APIRequest<Response> {

          public struct Options {

              /** Status values that need to be considered for filter */
              public var status: [Status]

              public init(status: [Status]) {
                  self.status = status
              }
          }

          public var options: Options

          public init(options: Options) {
              self.options = options
              super.init(service: FindPetsByStatus.service)
          }

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init(status: [Status]) {
              let options = Options(status: status)
              self.init(options: options)
          }

          public override var parameters: [String: Any] {
              var params: JSONDictionary = [:]
              params["status"] = options.status.encode().map { String(describing: $0) }.joined(separator: ",")
              return params
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = [Pet]

            /** successful operation */
            case success200([Pet])

            /** Invalid status value */
            case failure400

            public var success: [Pet]? {
                switch self {
                case .success200(let response): return response
                default: return nil
                }
            }

            public var response: Any {
                switch self {
                case .success200(let response): return response
                default: return ()
                }
            }

            public var statusCode: Int {
              switch self {
              case .success200: return 200
              case .failure400: return 400
              }
            }

            public var successful: Bool {
              switch self {
              case .success200: return true
              case .failure400: return false
              }
            }

            public init(statusCode: Int, data: Data) throws {
                switch statusCode {
                case 200: self = try .success200(JSONDecoder.decode(data: data))
                case 400: self = .failure400
                default: throw APIError.unexpectedStatusCode(statusCode: statusCode, data: data)
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
