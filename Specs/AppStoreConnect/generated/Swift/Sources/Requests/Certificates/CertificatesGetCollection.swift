//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension AppStoreConnect.Certificates {

    public enum CertificatesGetCollection {

        public static let service = APIService<Response>(id: "certificates-get_collection", tag: "Certificates", method: "GET", path: "/v1/certificates", hasBody: false, securityRequirements: [SecurityRequirement(type: "itc-bearer-token", scopes: [])])

        /** filter by attribute 'certificateType' */
        public enum FiltercertificateType: String, Codable, Equatable, CaseIterable {
            case iosDevelopment = "IOS_DEVELOPMENT"
            case iosDistribution = "IOS_DISTRIBUTION"
            case macAppDistribution = "MAC_APP_DISTRIBUTION"
            case macInstallerDistribution = "MAC_INSTALLER_DISTRIBUTION"
            case macAppDevelopment = "MAC_APP_DEVELOPMENT"
            case developerIdKext = "DEVELOPER_ID_KEXT"
            case developerIdApplication = "DEVELOPER_ID_APPLICATION"
            case development = "DEVELOPMENT"
            case distribution = "DISTRIBUTION"
        }

        /** comma-separated list of sort expressions; resources will be sorted as specified */
        public enum Sort: String, Codable, Equatable, CaseIterable {
            case certificateType = "certificateType"
            case _certificateType = "-certificateType"
            case displayName = "displayName"
            case _displayName = "-displayName"
            case id = "id"
            case _id = "-id"
            case serialNumber = "serialNumber"
            case _serialNumber = "-serialNumber"
        }

        /** the fields to include for returned resources of type certificates */
        public enum Fieldscertificates: String, Codable, Equatable, CaseIterable {
            case certificateContent = "certificateContent"
            case certificateType = "certificateType"
            case csrContent = "csrContent"
            case displayName = "displayName"
            case expirationDate = "expirationDate"
            case name = "name"
            case platform = "platform"
            case serialNumber = "serialNumber"
        }

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** filter by attribute 'certificateType' */
                public var filtercertificateType: [FiltercertificateType]?

                /** filter by attribute 'displayName' */
                public var filterdisplayName: [String]?

                /** filter by attribute 'serialNumber' */
                public var filterserialNumber: [String]?

                /** filter by id(s) */
                public var filterid: [String]?

                /** comma-separated list of sort expressions; resources will be sorted as specified */
                public var sort: [Sort]?

                /** the fields to include for returned resources of type certificates */
                public var fieldscertificates: [Fieldscertificates]?

                /** maximum resources per page */
                public var limit: Int?

                public init(filtercertificateType: [FiltercertificateType]? = nil, filterdisplayName: [String]? = nil, filterserialNumber: [String]? = nil, filterid: [String]? = nil, sort: [Sort]? = nil, fieldscertificates: [Fieldscertificates]? = nil, limit: Int? = nil) {
                    self.filtercertificateType = filtercertificateType
                    self.filterdisplayName = filterdisplayName
                    self.filterserialNumber = filterserialNumber
                    self.filterid = filterid
                    self.sort = sort
                    self.fieldscertificates = fieldscertificates
                    self.limit = limit
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: CertificatesGetCollection.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(filtercertificateType: [FiltercertificateType]? = nil, filterdisplayName: [String]? = nil, filterserialNumber: [String]? = nil, filterid: [String]? = nil, sort: [Sort]? = nil, fieldscertificates: [Fieldscertificates]? = nil, limit: Int? = nil) {
                let options = Options(filtercertificateType: filtercertificateType, filterdisplayName: filterdisplayName, filterserialNumber: filterserialNumber, filterid: filterid, sort: sort, fieldscertificates: fieldscertificates, limit: limit)
                self.init(options: options)
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let filtercertificateType = options.filtercertificateType?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["filter[certificateType]"] = filtercertificateType
                }
                if let filterdisplayName = options.filterdisplayName?.joined(separator: ",") {
                  params["filter[displayName]"] = filterdisplayName
                }
                if let filterserialNumber = options.filterserialNumber?.joined(separator: ",") {
                  params["filter[serialNumber]"] = filterserialNumber
                }
                if let filterid = options.filterid?.joined(separator: ",") {
                  params["filter[id]"] = filterid
                }
                if let sort = options.sort?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["sort"] = sort
                }
                if let fieldscertificates = options.fieldscertificates?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[certificates]"] = fieldscertificates
                }
                if let limit = options.limit {
                  params["limit"] = limit
                }
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = CertificatesResponse

            /** List of Certificates */
            case status200(CertificatesResponse)

            /** Parameter error(s) */
            case status400(ErrorResponse)

            /** Forbidden error */
            case status403(ErrorResponse)

            public var success: CertificatesResponse? {
                switch self {
                case .status200(let response): return response
                default: return nil
                }
            }

            public var failure: ErrorResponse? {
                switch self {
                case .status400(let response): return response
                case .status403(let response): return response
                default: return nil
                }
            }

            /// either success or failure value. Success is anything in the 200..<300 status code range
            public var responseResult: APIResponseResult<CertificatesResponse, ErrorResponse> {
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
                }
            }

            public var statusCode: Int {
                switch self {
                case .status200: return 200
                case .status400: return 400
                case .status403: return 403
                }
            }

            public var successful: Bool {
                switch self {
                case .status200: return true
                case .status400: return false
                case .status403: return false
                }
            }

            public init(statusCode: Int, data: Data, decoder: ResponseDecoder) throws {
                switch statusCode {
                case 200: self = try .status200(decoder.decode(CertificatesResponse.self, from: data))
                case 400: self = try .status400(decoder.decode(ErrorResponse.self, from: data))
                case 403: self = try .status403(decoder.decode(ErrorResponse.self, from: data))
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
