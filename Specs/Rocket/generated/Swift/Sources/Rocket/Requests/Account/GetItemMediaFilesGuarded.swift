//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension Rocket.Account {

    /** Get the video files associated with an item given maximum resolution, device type
and one or more delivery types.

This endpoint is identical to the `/account/items/{id}/videos` however it expects
an Account Playback token. This token, and in association this endpoint, is specifically
for use when playback files are classification restricted and require an account
level pin to access them.

Returns an array of video file objects which each include a url to a video.

The first entry in the array contains what is predicted to be the best match.
The remainder of the entries, if any, may contain resolutions below what was
requests. For example if you request HD-720 the response may also contain
SD entries.

If you specify multiple delivery types, then the response array will insert
types in the order you specify them in the query. For example `stream,progressive`
would return an array with 0 or more stream files followed by 0 or more progressive files.

If no files are found a 404 is returned.
 */
    public enum GetItemMediaFilesGuarded {

      public static let service = APIService<Response>(id: "getItemMediaFilesGuarded", tag: "account", method: "GET", path: "/account/items/{id}/videos-guarded", hasBody: false, authorization: Authorization(type: "accountAuth", scope: "Playback"))

      public class Request: APIRequest<Response> {

          public struct Options {

              /** The identifier of the item whose video files to load. */
              public var id: String

              /** The video delivery type you require. */
              public var delivery: [MediaFileDelivery]

              /** The maximum resolution the device to playback the media can present. */
              public var resolution: MediaFileResolution

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

              public init(id: String, delivery: [MediaFileDelivery], resolution: MediaFileResolution, device: String? = nil, sub: String? = nil, segments: [String]? = nil, ff: [FeatureFlags]? = nil) {
                  self.id = id
                  self.delivery = delivery
                  self.resolution = resolution
                  self.device = device
                  self.sub = sub
                  self.segments = segments
                  self.ff = ff
              }
          }

          public var options: Options

          public init(options: Options) {
              self.options = options
              super.init(service: GetItemMediaFilesGuarded.service)
          }

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init(id: String, delivery: [MediaFileDelivery], resolution: MediaFileResolution, device: String? = nil, sub: String? = nil, segments: [String]? = nil, ff: [FeatureFlags]? = nil) {
              let options = Options(id: id, delivery: delivery, resolution: resolution, device: device, sub: sub, segments: segments, ff: ff)
              self.init(options: options)
          }

          public override var path: String {
              return super.path.replacingOccurrences(of: "{" + "id" + "}", with: "\(self.options.id)")
          }

          public override var parameters: [String: Any] {
              var params: JSONDictionary = [:]
              params["delivery"] = options.delivery.encode().map({ "\($0)" }).joined(separator: ",")
              params["resolution"] = options.resolution.encode()
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
            public typealias SuccessType = [MediaFile]

            /** The list of video files available.
The first entry containing what is predicted to be the best match.
 */
            case success200([MediaFile])

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

            public var success: [MediaFile]? {
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
            public var responseResult: APIResponseResult<[MediaFile], ServiceError> {
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
