//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension AppStoreConnect.AppStoreReviewAttachments {

    public enum AppStoreReviewAttachmentsDeleteInstance {

        public static let service = APIService<Response>(id: "appStoreReviewAttachments-delete_instance", tag: "AppStoreReviewAttachments", method: "DELETE", path: "/v1/appStoreReviewAttachments/{id}", hasBody: false, securityRequirements: [SecurityRequirement(type: "itc-bearer-token", scopes: [])])

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** the id of the requested resource */
                public var id: String

                public init(id: String) {
                    self.id = id
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: AppStoreReviewAttachmentsDeleteInstance.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(id: String) {
                let options = Options(id: id)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "id" + "}", with: "\(self.options.id)")
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = Void

            /** Success (no content) */
            case status204

            /** Parameter error(s) */
            case status400(ErrorResponse)

            /** Forbidden error */
            case status403(ErrorResponse)

            /** Not found error */
            case status404(ErrorResponse)

            /** Request entity error(s) */
            case status409(ErrorResponse)

            public var success: Void? {
                switch self {
                case .status204: return ()
                default: return nil
                }
            }

            public var failure: ErrorResponse? {
                switch self {
                case .status400(let response): return response
                case .status403(let response): return response
                case .status404(let response): return response
                case .status409(let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<Void, ErrorResponse> {
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
                case .status400(let response): return response
                case .status403(let response): return response
                case .status404(let response): return response
                case .status409(let response): return response
                default: return ()
                }
            }

            public var statusCode: Int {
                switch self {
                case .status204: return 204
                case .status400: return 400
                case .status403: return 403
                case .status404: return 404
                case .status409: return 409
                }
            }

            public var successful: Bool {
                switch self {
                case .status204: return true
                case .status400: return false
                case .status403: return false
                case .status404: return false
                case .status409: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 204: self = .status204
                case 400: self = try .status400(decoder.decode(ErrorResponse.self, from: data))
                case 403: self = try .status403(decoder.decode(ErrorResponse.self, from: data))
                case 404: self = try .status404(decoder.decode(ErrorResponse.self, from: data))
                case 409: self = try .status409(decoder.decode(ErrorResponse.self, from: data))
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
