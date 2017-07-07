//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

extension Rocket.Profile {

    /** Returns the list of watched items under the active profile. */
    public enum GetWatchedList {

      public static let service = APIService<Response>(id: "getWatchedList", tag: "profile", method: "GET", path: "/account/profile/watched/list", hasBody: false, authorization: Authorization(type: "profileAuth", scope: "Catalog"))

      /** What to order by.

      Ordering by `date-modified` equates to ordering by the last watched date.
       */
      public enum OrderBy: String {
          case dateAdded = "date-added"
          case dateModified = "date-modified"

          public static let cases: [OrderBy] = [
            .dateAdded,
            .dateModified,
          ]
      }

      public class Request: APIRequest<Response> {

          public struct Options {

              /** The page of items to load. Starts from page 1. */
              public var page: Int?

              /** The number of items to return in a page. */
              public var pageSize: Int?

              /** The list sort order, either 'asc' or 'desc'. */
              public var order: ListOrder?

              /** What to order by.

Ordering by `date-modified` equates to ordering by the last watched date.
 */
              public var orderBy: OrderBy?

              /** The item type to filter by. Defaults to unspecified. */
              public var itemType: ItemType?

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

              public init(page: Int? = nil, pageSize: Int? = nil, order: ListOrder? = nil, orderBy: OrderBy? = nil, itemType: ItemType? = nil, device: String? = nil, sub: String? = nil, segments: [String]? = nil, ff: [FeatureFlags]? = nil) {
                  self.page = page
                  self.pageSize = pageSize
                  self.order = order
                  self.orderBy = orderBy
                  self.itemType = itemType
                  self.device = device
                  self.sub = sub
                  self.segments = segments
                  self.ff = ff
              }
          }

          public var options: Options

          public init(options: Options) {
              self.options = options
              super.init(service: GetWatchedList.service)
          }

          /// convenience initialiser so an Option doesn't have to be created
          public convenience init(page: Int? = nil, pageSize: Int? = nil, order: ListOrder? = nil, orderBy: OrderBy? = nil, itemType: ItemType? = nil, device: String? = nil, sub: String? = nil, segments: [String]? = nil, ff: [FeatureFlags]? = nil) {
              let options = Options(page: page, pageSize: pageSize, order: order, orderBy: orderBy, itemType: itemType, device: device, sub: sub, segments: segments, ff: ff)
              self.init(options: options)
          }

          public override var parameters: [String: Any] {
              var params: JSONDictionary = [:]
              if let page = options.page {
                params["page"] = page
              }
              if let pageSize = options.pageSize {
                params["page_size"] = pageSize
              }
              if let order = options.order?.encode() {
                params["order"] = order
              }
              if let orderBy = options.orderBy?.encode() {
                params["order_by"] = orderBy
              }
              if let itemType = options.itemType?.encode() {
                params["item_type"] = itemType
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
              if let ff = options.ff?.encode().map { String(describing: $0) }.joined(separator: ",") {
                params["ff"] = ff
              }
              return params
          }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = ItemList

            /** The list of items requested. */
            case success200(ItemList)

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

            public var success: ItemList? {
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
            public var responseResult: APIResponseResult<ItemList, ServiceError> {
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
