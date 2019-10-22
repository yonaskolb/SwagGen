//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension TVDB.Series {

    /** Query images for the given series ID. */
    public enum GetSeriesByIdImagesQuery {

        public static let service = APIService<Response>(id: "getSeriesByIdImagesQuery", tag: "Series", method: "GET", path: "/series/{id}/images/query", hasBody: false, securityRequirement: SecurityRequirement(type: "jwtToken", scopes: []))

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** ID of the series */
                public var id: Int

                /** Type of image you're querying for (fanart, poster, etc. See ../images/query/params for more details). */
                public var keyType: String?

                /** Resolution to filter by (1280x1024, for example) */
                public var resolution: String?

                /** Subkey for the above query keys. See /series/{id}/images/query/params for more information */
                public var subKey: String?

                /** Records are returned with the Episode name and Overview in the desired language, if it exists. If there is no translation for the given language, then the record is still returned but with empty values for the translated fields. */
                public var acceptLanguage: String?

                public init(id: Int, keyType: String? = nil, resolution: String? = nil, subKey: String? = nil, acceptLanguage: String? = nil) {
                    self.id = id
                    self.keyType = keyType
                    self.resolution = resolution
                    self.subKey = subKey
                    self.acceptLanguage = acceptLanguage
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: GetSeriesByIdImagesQuery.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(id: Int, keyType: String? = nil, resolution: String? = nil, subKey: String? = nil, acceptLanguage: String? = nil) {
                let options = Options(id: id, keyType: keyType, resolution: resolution, subKey: subKey, acceptLanguage: acceptLanguage)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "id" + "}", with: "\(self.options.id)")
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let keyType = options.keyType {
                  params["keyType"] = keyType
                }
                if let resolution = options.resolution {
                  params["resolution"] = resolution
                }
                if let subKey = options.subKey {
                  params["subKey"] = subKey
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
            public typealias SuccessType = SeriesImageQueryResults

            /** An array of basic Episode results that matched the query */
            case status200(SeriesImageQueryResults)

            /** Returned if your JWT token is missing or expired */
            case status401(NotAuthorized)

            /** Returned if the given series ID does not exist or the query returns no results. */
            case status404(NotFound)

            public var success: SeriesImageQueryResults? {
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
                case 200: self = try .status200(decoder.decode(SeriesImageQueryResults.self, from: data))
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
