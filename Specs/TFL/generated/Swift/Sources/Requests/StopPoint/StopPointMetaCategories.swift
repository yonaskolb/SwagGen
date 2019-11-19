//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension StopPoint {

    /** Gets the list of available StopPoint additional information categories */
    public enum StopPointMetaCategories {

        public static let service = APIService<Response>(id: "StopPoint_MetaCategories", tag: "StopPoint", method: "GET", path: "/StopPoint/Meta/Categories", hasBody: false)

        public final class Request: APIRequest<Response> {

            public init() {
                super.init(service: StopPointMetaCategories.service)
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = [StopPointCategory]

            /** OK */
            case status200([StopPointCategory])

            public var success: [StopPointCategory]? {
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
                case 200: self = try .status200(decoder.decode([StopPointCategory].self, from: data))
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
