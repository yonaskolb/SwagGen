//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension TFL.StopPoint {

    public enum StopPointGetServiceTypes {

      public static let service = APIService<Response>(id: "StopPoint_GetServiceTypes", tag: "StopPoint", method: "GET", path: "/StopPoint/ServiceTypes", hasBody: false)

      public class Request: APIRequest<Response> {

          public struct Options {

              /** The Naptan id of the stop */
              public var id: String

              /** The lines which contain the given Naptan id (all lines relevant to the given stoppoint if empty) */
              public var lineIds: [String]?

              /** The modes which the lines are relevant to (all if empty) */
              public var modes: [String]?

              public init(id: String, lineIds: [String]? = nil, modes: [String]? = nil) {
                  self.id = id
                  self.lineIds = lineIds
                  self.modes = modes
              }
          }

          public var options: Options

          public init(options: Options) {
              self.options = options
              super.init(service: StopPointGetServiceTypes.service)
          }

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init(id: String, lineIds: [String]? = nil, modes: [String]? = nil) {
              let options = Options(id: id, lineIds: lineIds, modes: modes)
              self.init(options: options)
          }

          public override var parameters: [String: Any] {
              var params: JSONDictionary = [:]
              params["id"] = options.id
              if let lineIds = options.lineIds?.joined(separator: ",") {
                params["lineIds"] = lineIds
              }
              if let modes = options.modes?.joined(separator: ",") {
                params["modes"] = modes
              }
              return params
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = [LineServiceType]

            /** OK */
            case success200([LineServiceType])

            public var success: [LineServiceType]? {
                switch self {
                case .success200(let response): return response
                default: return nil
                }
            }

            public var response: Any {
                switch self {
                case .success200(let response): return response
                }
            }

            public var statusCode: Int {
              switch self {
              case .success200: return 200
              }
            }

            public var successful: Bool {
              switch self {
              case .success200: return true
              }
            }

            public init(statusCode: Int, data: Data) throws {
                switch statusCode {
                case 200: self = try .success200(JSONDecoder.decode(data: data))
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
