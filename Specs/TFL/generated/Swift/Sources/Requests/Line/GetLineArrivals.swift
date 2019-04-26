//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension Line {

    /** Get the list of arrival predictions for given line ids based at the given stop */
    public enum GetLineArrivals {

        public static let service = APIService<Response>(id: "getLineArrivals", tag: "Line", method: "GET", path: "/Line/{ids}/Arrivals", hasBody: false)

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** Id of stop to get arrival predictions for (station naptan code e.g. 940GZZLUASL, you can use /StopPoint/Search/{query} endpoint to find a stop point id from a station name) */
                public var stopPointId: String

                /** A comma-separated list of line ids e.g. victoria,circle,N133. Max. approx. 20 ids. */
                public var ids: [String]

                public init(stopPointId: String, ids: [String]) {
                    self.stopPointId = stopPointId
                    self.ids = ids
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: GetLineArrivals.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(stopPointId: String, ids: [String]) {
                let options = Options(stopPointId: stopPointId, ids: ids)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "ids" + "}", with: "\(self.options.ids.joined(separator: ","))")
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                params["stopPointId"] = options.stopPointId
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = [Prediction]

            /** OK */
            case status200([Prediction])

            public var success: [Prediction]? {
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
                case 200: self = try .status200(decoder.decode([Prediction].self, from: data))
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
