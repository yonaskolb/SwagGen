//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension AppStoreConnect.BuildBetaDetails {

    public enum BuildBetaDetailsGetInstance {

        public static let service = APIService<Response>(id: "buildBetaDetails-get_instance", tag: "BuildBetaDetails", method: "GET", path: "/v1/buildBetaDetails/{id}", hasBody: false, securityRequirements: [SecurityRequirement(type: "itc-bearer-token", scopes: [])])

        /** the fields to include for returned resources of type buildBetaDetails */
        public enum FieldsbuildBetaDetails: String, Codable, Equatable, CaseIterable {
            case autoNotifyEnabled = "autoNotifyEnabled"
            case build = "build"
            case externalBuildState = "externalBuildState"
            case internalBuildState = "internalBuildState"
        }

        /** comma-separated list of relationships to include */
        public enum Include: String, Codable, Equatable, CaseIterable {
            case build = "build"
        }

        /** the fields to include for returned resources of type builds */
        public enum Fieldsbuilds: String, Codable, Equatable, CaseIterable {
            case app = "app"
            case appEncryptionDeclaration = "appEncryptionDeclaration"
            case appStoreVersion = "appStoreVersion"
            case betaAppReviewSubmission = "betaAppReviewSubmission"
            case betaBuildLocalizations = "betaBuildLocalizations"
            case betaGroups = "betaGroups"
            case buildBetaDetail = "buildBetaDetail"
            case diagnosticSignatures = "diagnosticSignatures"
            case expirationDate = "expirationDate"
            case expired = "expired"
            case iconAssetToken = "iconAssetToken"
            case icons = "icons"
            case individualTesters = "individualTesters"
            case minOsVersion = "minOsVersion"
            case perfPowerMetrics = "perfPowerMetrics"
            case preReleaseVersion = "preReleaseVersion"
            case processingState = "processingState"
            case uploadedDate = "uploadedDate"
            case usesNonExemptEncryption = "usesNonExemptEncryption"
            case version = "version"
        }

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** the id of the requested resource */
                public var id: String

                /** the fields to include for returned resources of type buildBetaDetails */
                public var fieldsbuildBetaDetails: [FieldsbuildBetaDetails]?

                /** comma-separated list of relationships to include */
                public var include: [Include]?

                /** the fields to include for returned resources of type builds */
                public var fieldsbuilds: [Fieldsbuilds]?

                public init(id: String, fieldsbuildBetaDetails: [FieldsbuildBetaDetails]? = nil, include: [Include]? = nil, fieldsbuilds: [Fieldsbuilds]? = nil) {
                    self.id = id
                    self.fieldsbuildBetaDetails = fieldsbuildBetaDetails
                    self.include = include
                    self.fieldsbuilds = fieldsbuilds
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: BuildBetaDetailsGetInstance.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(id: String, fieldsbuildBetaDetails: [FieldsbuildBetaDetails]? = nil, include: [Include]? = nil, fieldsbuilds: [Fieldsbuilds]? = nil) {
                let options = Options(id: id, fieldsbuildBetaDetails: fieldsbuildBetaDetails, include: include, fieldsbuilds: fieldsbuilds)
                self.init(options: options)
            }

            public override var path: String {
                return super.path.replacingOccurrences(of: "{" + "id" + "}", with: "\(self.options.id)")
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let fieldsbuildBetaDetails = options.fieldsbuildBetaDetails?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[buildBetaDetails]"] = fieldsbuildBetaDetails
                }
                if let include = options.include?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["include"] = include
                }
                if let fieldsbuilds = options.fieldsbuilds?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[builds]"] = fieldsbuilds
                }
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = BuildBetaDetailResponse

            /** Single BuildBetaDetail */
            case status200(BuildBetaDetailResponse)

            /** Parameter error(s) */
            case status400(ErrorResponse)

            /** Forbidden error */
            case status403(ErrorResponse)

            /** Not found error */
            case status404(ErrorResponse)

            public var success: BuildBetaDetailResponse? {
                switch self {
                case .status200(let response): return response
                default: return nil
                }
            }

            public var failure: ErrorResponse? {
                switch self {
                case .status400(let response): return response
                case .status403(let response): return response
                case .status404(let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<BuildBetaDetailResponse, ErrorResponse> {
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
                case .status200(let response): return response
                case .status400(let response): return response
                case .status403(let response): return response
                case .status404(let response): return response
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                case .status400: return 400
                case .status403: return 403
                case .status404: return 404
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                case .status400: return false
                case .status403: return false
                case .status404: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode(BuildBetaDetailResponse.self, from: data))
                case 400: self = try .status400(decoder.decode(ErrorResponse.self, from: data))
                case 403: self = try .status403(decoder.decode(ErrorResponse.self, from: data))
                case 404: self = try .status404(decoder.decode(ErrorResponse.self, from: data))
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
