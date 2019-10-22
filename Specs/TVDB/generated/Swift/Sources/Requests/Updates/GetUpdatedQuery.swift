//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension TVDB.Updates {

    /** Returns an array of series that have changed in a maximum of one week blocks since the provided `fromTime`.
The user may specify a `toTime` to grab results for less than a week. Any timespan larger than a week will be reduced down to one week automatically. */
    public enum GetUpdatedQuery {

        public static let service = APIService<Response>(id: "getUpdatedQuery", tag: "Updates", method: "GET", path: "/updated/query", hasBody: false, securityRequirement: SecurityRequirement(type: "jwtToken", scopes: []))

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** Epoch time to start your date range. */
                public var fromTime: String

                /** Epoch time to end your date range. Must be one week from `fromTime`. */
                public var toTime: String?

                /** Records are returned with the Episode name and Overview in the desired language, if it exists. If there is no translation for the given language, then the record is still returned but with empty values for the translated fields. */
                public var acceptLanguage: String?

                public init(fromTime: String, toTime: String? = nil, acceptLanguage: String? = nil) {
                    self.fromTime = fromTime
                    self.toTime = toTime
                    self.acceptLanguage = acceptLanguage
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: GetUpdatedQuery.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(fromTime: String, toTime: String? = nil, acceptLanguage: String? = nil) {
                let options = Options(fromTime: fromTime, toTime: toTime, acceptLanguage: acceptLanguage)
                self.init(options: options)
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                params["fromTime"] = options.fromTime
                if let toTime = options.toTime {
                  params["toTime"] = toTime
                }
                return params
            }

            override var headerParameters: [String: String] {
                var headers: [String: String] = [:]
                if let acceptLanguage = options.acceptLanguage {
                  headers["Accept-Language"] = acceptLanguage
                }
                return headers
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = UpdateData

            /** An array of Update objects that match the given timeframe. */
            case status200(UpdateData)

            /** Returned if your JWT token is missing or expired */
            case status401(NotAuthorized)

            /** Returned if no records exist for the given timespan */
            case status404(NotFound)

            public var success: UpdateData? {
                switch self {
                case .status200(let response): return response
                default: return nil
                }
            }

            public var response: Any {
                switch self {
                case .status200(let response): return response
                case .status401(let response): return response
                case .status404(let response): return response
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                case .status401: return 401
                case .status404: return 404
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                case .status401: return false
                case .status404: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode(UpdateData.self, from: data))
                case 401: self = try .status401(decoder.decode(NotAuthorized.self, from: data))
                case 404: self = try .status404(decoder.decode(NotFound.self, from: data))
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
