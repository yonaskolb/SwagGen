//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension TFL.StopPoint {

    /** Gets all disruptions for the specified StopPointId, plus disruptions for any child Naptan records it may have. */
    public enum StopPointDisruption {

        public static let service = APIService<Response>(id: "StopPoint_Disruption", tag: "StopPoint", method: "GET", path: "/StopPoint/{ids}/Disruption", hasBody: false, securityRequirements: [])

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** A comma-separated list of stop point ids. Max. approx. 20 ids.
            You can use /StopPoint/Search/{query} endpoint to find a stop point id from a station name. */
                public var ids: [String]

                /** Specify true to return disruptions for entire family, or false to return disruptions for just this stop point. Defaults to false. */
                public var getFamily: Bool?

                public var includeRouteBlockedStops: Bool?

                /** Specify true to associate all disruptions with parent stop point. (Only applicable when getFamily is true). */
                public var flattenResponse: Bool?

                public init(ids: [String], getFamily: Bool? = nil, includeRouteBlockedStops: Bool? = nil, flattenResponse: Bool? = nil) {
                    self.ids = ids
                    self.getFamily = getFamily
                    self.includeRouteBlockedStops = includeRouteBlockedStops
                    self.flattenResponse = flattenResponse
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: StopPointDisruption.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(ids: [String], getFamily: Bool? = nil, includeRouteBlockedStops: Bool? = nil, flattenResponse: Bool? = nil) {
                let options = Options(ids: ids, getFamily: getFamily, includeRouteBlockedStops: includeRouteBlockedStops, flattenResponse: flattenResponse)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "ids" + "}", with: "\(self.options.ids.joined(separator: ","))")
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let getFamily = options.getFamily {
                  params["getFamily"] = getFamily
                }
                if let includeRouteBlockedStops = options.includeRouteBlockedStops {
                  params["includeRouteBlockedStops"] = includeRouteBlockedStops
                }
                if let flattenResponse = options.flattenResponse {
                  params["flattenResponse"] = flattenResponse
                }
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = [DisruptedPoint]

            /** OK */
            case status200([DisruptedPoint])

            public var success: [DisruptedPoint]? {
                switch self {
                case .status200(let response): return response
                }
            }

            public var response: Any {
                switch self {
                case .status200(let response): return response
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode([DisruptedPoint].self, from: data))
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
