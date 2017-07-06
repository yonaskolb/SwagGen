//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension Rocket.App {

    /** Get the global configuration for an application. Should be called during app statup.

This includes things like device and playback rules, classifications,
sitemap and subscriptions.

You have the option to select specific configuration objects using the 'include'
parameter, or if unspecified, getting all configuration.
 */
    public enum GetAppConfig {

      public static let service = APIService<Response>(id: "getAppConfig", tag: "app", method: "GET", path: "/config", hasBody: false)

      /** A comma delimited list of config objects to return.
      If none specified then all configuration is returned.
       */
      public enum Include: String {
          case classification = "classification"
          case playback = "playback"
          case sitemap = "sitemap"
          case navigation = "navigation"
          case subscription = "subscription"
          case general = "general"

          public static let cases: [Include] = [
            .classification,
            .playback,
            .sitemap,
            .navigation,
            .subscription,
            .general,
          ]
      }

      public class Request: APIRequest<Response> {

          public struct Options {

              /** A comma delimited list of config objects to return.
If none specified then all configuration is returned.
 */
              public var include: [Include]?

              /** The type of device the content is targeting. */
              public var device: String?

              /** The active subscription code. */
              public var sub: String?

              /** The list of segments to filter the response by. */
              public var segments: [String]?

              /** The set of opt in feature flags which cause breaking changes to responses.

While Rocket APIs look to avoid breaking changes under the active major version, the formats of responses
may need to evolve over this time.

These feature flags allow clients to select which response formats they expect and avoid breaking
clients as these formats evolve under the current major version.

### Flags

- `all` - Enable all flags. Useful for testing. _Don't use in production_.
- `idp` - Dynamic item detail pages with schedulable rows.
- `ldp` - Dynamic list detail pages with schedulable rows.

See the `feature-flags.md` for available flag details.
 */
              public var ff: [FeatureFlags]?

              public init(include: [Include]? = nil, device: String? = nil, sub: String? = nil, segments: [String]? = nil, ff: [FeatureFlags]? = nil) {
                  self.include = include
                  self.device = device
                  self.sub = sub
                  self.segments = segments
                  self.ff = ff
              }
          }

          public var options: Options

          public init(options: Options) {
              self.options = options
              super.init(service: GetAppConfig.service)
          }

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init(include: [Include]? = nil, device: String? = nil, sub: String? = nil, segments: [String]? = nil, ff: [FeatureFlags]? = nil) {
              let options = Options(include: include, device: device, sub: sub, segments: segments, ff: ff)
              self.init(options: options)
          }

          public override var parameters: [String: Any] {
              var params: JSONDictionary = [:]
              if let include = options.include?.encode().map({ "\($0)" }).joined(separator: ",") {
                params["include"] = include
              }
              if let device = options.device {
                params["device"] = device
              }
              if let sub = options.sub {
                params["sub"] = sub
              }
              if let segments = options.segments?.joined(separator: ",") {
                params["segments"] = segments
              }
              if let ff = options.ff?.encode().map({ "\($0)" }).joined(separator: ",") {
                params["ff"] = ff
              }
              return params
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = AppConfig

            /** The list of available pages */
            case success200(AppConfig)

            /** Bad request. */
            case failure400(ServiceError)

            /** Not found. */
            case failure404(ServiceError)

            /** Internal server error. */
            case failure500(ServiceError)

            /** Service error. */
            case failureDefault(statusCode: Int, ServiceError)

            public var success: AppConfig? {
                switch self {
                case .success200(let response): return response
                default: return nil
                }
            }

            public var failure: ServiceError? {
                switch self {
                case .failure400(let response): return response
                case .failure404(let response): return response
                case .failure500(let response): return response
                case .failureDefault(_, let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<AppConfig, ServiceError> {
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
                case .failure404(let response): return response
                case .failure500(let response): return response
                case .failureDefault(_, let response): return response
                }
            }

            public var statusCode: Int {
              switch self {
              case .success200: return 200
              case .failure400: return 400
              case .failure404: return 404
              case .failure500: return 500
              case .failureDefault(let statusCode, _): return statusCode
              }
            }

            public var successful: Bool {
              switch self {
              case .success200: return true
              case .failure400: return false
              case .failure404: return false
              case .failure500: return false
              case .failureDefault: return false
              }
            }

            public init(statusCode: Int, data: Data) throws {
                switch statusCode {
                case 200: self = try .success200(JSONDecoder.decode(data: data))
                case 400: self = try .failure400(JSONDecoder.decode(data: data))
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
