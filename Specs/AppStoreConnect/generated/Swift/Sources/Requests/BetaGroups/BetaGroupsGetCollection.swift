//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

extension AppStoreConnect.BetaGroups {

    public enum BetaGroupsGetCollection {

        public static let service = APIService<Response>(id: "betaGroups-get_collection", tag: "BetaGroups", method: "GET", path: "/v1/betaGroups", hasBody: false, securityRequirements: [SecurityRequirement(type: "itc-bearer-token", scopes: [])])

        /** comma-separated list of sort expressions; resources will be sorted as specified */
        public enum Sort: String, Codable, Equatable, CaseIterable {
            case createdDate = "createdDate"
            case createdDate = "-createdDate"
            case name = "name"
            case name = "-name"
            case publicLinkEnabled = "publicLinkEnabled"
            case publicLinkEnabled = "-publicLinkEnabled"
            case publicLinkLimit = "publicLinkLimit"
            case publicLinkLimit = "-publicLinkLimit"
        }

        /** the fields to include for returned resources of type betaGroups */
        public enum FieldsbetaGroups: String, Codable, Equatable, CaseIterable {
            case app = "app"
            case betaTesters = "betaTesters"
            case builds = "builds"
            case createdDate = "createdDate"
            case feedbackEnabled = "feedbackEnabled"
            case isInternalGroup = "isInternalGroup"
            case name = "name"
            case publicLink = "publicLink"
            case publicLinkEnabled = "publicLinkEnabled"
            case publicLinkId = "publicLinkId"
            case publicLinkLimit = "publicLinkLimit"
            case publicLinkLimitEnabled = "publicLinkLimitEnabled"
        }

        /** comma-separated list of relationships to include */
        public enum Include: String, Codable, Equatable, CaseIterable {
            case app = "app"
            case betaTesters = "betaTesters"
            case builds = "builds"
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

        /** the fields to include for returned resources of type betaTesters */
        public enum FieldsbetaTesters: String, Codable, Equatable, CaseIterable {
            case apps = "apps"
            case betaGroups = "betaGroups"
            case builds = "builds"
            case email = "email"
            case firstName = "firstName"
            case inviteType = "inviteType"
            case lastName = "lastName"
        }

        /** the fields to include for returned resources of type apps */
        public enum Fieldsapps: String, Codable, Equatable, CaseIterable {
            case appInfos = "appInfos"
            case appStoreVersions = "appStoreVersions"
            case availableInNewTerritories = "availableInNewTerritories"
            case availableTerritories = "availableTerritories"
            case betaAppLocalizations = "betaAppLocalizations"
            case betaAppReviewDetail = "betaAppReviewDetail"
            case betaGroups = "betaGroups"
            case betaLicenseAgreement = "betaLicenseAgreement"
            case betaTesters = "betaTesters"
            case builds = "builds"
            case bundleId = "bundleId"
            case contentRightsDeclaration = "contentRightsDeclaration"
            case endUserLicenseAgreement = "endUserLicenseAgreement"
            case gameCenterEnabledVersions = "gameCenterEnabledVersions"
            case inAppPurchases = "inAppPurchases"
            case isOrEverWasMadeForKids = "isOrEverWasMadeForKids"
            case name = "name"
            case perfPowerMetrics = "perfPowerMetrics"
            case preOrder = "preOrder"
            case preReleaseVersions = "preReleaseVersions"
            case prices = "prices"
            case primaryLocale = "primaryLocale"
            case sku = "sku"
        }

        public final class Request: APIRequest<Response> {

            public struct Options {

                /** filter by attribute 'isInternalGroup' */
                public var filterisInternalGroup: [String]?

                /** filter by attribute 'name' */
                public var filtername: [String]?

                /** filter by attribute 'publicLink' */
                public var filterpublicLink: [String]?

                /** filter by attribute 'publicLinkEnabled' */
                public var filterpublicLinkEnabled: [String]?

                /** filter by attribute 'publicLinkLimitEnabled' */
                public var filterpublicLinkLimitEnabled: [String]?

                /** filter by id(s) of related 'app' */
                public var filterapp: [String]?

                /** filter by id(s) of related 'builds' */
                public var filterbuilds: [String]?

                /** filter by id(s) */
                public var filterid: [String]?

                /** comma-separated list of sort expressions; resources will be sorted as specified */
                public var sort: [Sort]?

                /** the fields to include for returned resources of type betaGroups */
                public var fieldsbetaGroups: [FieldsbetaGroups]?

                /** maximum resources per page */
                public var limit: Int?

                /** comma-separated list of relationships to include */
                public var include: [Include]?

                /** the fields to include for returned resources of type builds */
                public var fieldsbuilds: [Fieldsbuilds]?

                /** the fields to include for returned resources of type betaTesters */
                public var fieldsbetaTesters: [FieldsbetaTesters]?

                /** the fields to include for returned resources of type apps */
                public var fieldsapps: [Fieldsapps]?

                /** maximum number of related betaTesters returned (when they are included) */
                public var limitbetaTesters: Int?

                /** maximum number of related builds returned (when they are included) */
                public var limitbuilds: Int?

                public init(filterisInternalGroup: [String]? = nil, filtername: [String]? = nil, filterpublicLink: [String]? = nil, filterpublicLinkEnabled: [String]? = nil, filterpublicLinkLimitEnabled: [String]? = nil, filterapp: [String]? = nil, filterbuilds: [String]? = nil, filterid: [String]? = nil, sort: [Sort]? = nil, fieldsbetaGroups: [FieldsbetaGroups]? = nil, limit: Int? = nil, include: [Include]? = nil, fieldsbuilds: [Fieldsbuilds]? = nil, fieldsbetaTesters: [FieldsbetaTesters]? = nil, fieldsapps: [Fieldsapps]? = nil, limitbetaTesters: Int? = nil, limitbuilds: Int? = nil) {
                    self.filterisInternalGroup = filterisInternalGroup
                    self.filtername = filtername
                    self.filterpublicLink = filterpublicLink
                    self.filterpublicLinkEnabled = filterpublicLinkEnabled
                    self.filterpublicLinkLimitEnabled = filterpublicLinkLimitEnabled
                    self.filterapp = filterapp
                    self.filterbuilds = filterbuilds
                    self.filterid = filterid
                    self.sort = sort
                    self.fieldsbetaGroups = fieldsbetaGroups
                    self.limit = limit
                    self.include = include
                    self.fieldsbuilds = fieldsbuilds
                    self.fieldsbetaTesters = fieldsbetaTesters
                    self.fieldsapps = fieldsapps
                    self.limitbetaTesters = limitbetaTesters
                    self.limitbuilds = limitbuilds
                }
            }

            public var options: Options

            public init(options: Options) {
                self.options = options
                super.init(service: BetaGroupsGetCollection.service)
            }

            /// convenience initialiser so an Option doesn't have to be created
            public convenience init(filterisInternalGroup: [String]? = nil, filtername: [String]? = nil, filterpublicLink: [String]? = nil, filterpublicLinkEnabled: [String]? = nil, filterpublicLinkLimitEnabled: [String]? = nil, filterapp: [String]? = nil, filterbuilds: [String]? = nil, filterid: [String]? = nil, sort: [Sort]? = nil, fieldsbetaGroups: [FieldsbetaGroups]? = nil, limit: Int? = nil, include: [Include]? = nil, fieldsbuilds: [Fieldsbuilds]? = nil, fieldsbetaTesters: [FieldsbetaTesters]? = nil, fieldsapps: [Fieldsapps]? = nil, limitbetaTesters: Int? = nil, limitbuilds: Int? = nil) {
                let options = Options(filterisInternalGroup: filterisInternalGroup, filtername: filtername, filterpublicLink: filterpublicLink, filterpublicLinkEnabled: filterpublicLinkEnabled, filterpublicLinkLimitEnabled: filterpublicLinkLimitEnabled, filterapp: filterapp, filterbuilds: filterbuilds, filterid: filterid, sort: sort, fieldsbetaGroups: fieldsbetaGroups, limit: limit, include: include, fieldsbuilds: fieldsbuilds, fieldsbetaTesters: fieldsbetaTesters, fieldsapps: fieldsapps, limitbetaTesters: limitbetaTesters, limitbuilds: limitbuilds)
                self.init(options: options)
            }

            public override var queryParameters: [String: Any] {
                var params: [String: Any] = [:]
                if let filterisInternalGroup = options.filterisInternalGroup?.joined(separator: ",") {
                  params["filter[isInternalGroup]"] = filterisInternalGroup
                }
                if let filtername = options.filtername?.joined(separator: ",") {
                  params["filter[name]"] = filtername
                }
                if let filterpublicLink = options.filterpublicLink?.joined(separator: ",") {
                  params["filter[publicLink]"] = filterpublicLink
                }
                if let filterpublicLinkEnabled = options.filterpublicLinkEnabled?.joined(separator: ",") {
                  params["filter[publicLinkEnabled]"] = filterpublicLinkEnabled
                }
                if let filterpublicLinkLimitEnabled = options.filterpublicLinkLimitEnabled?.joined(separator: ",") {
                  params["filter[publicLinkLimitEnabled]"] = filterpublicLinkLimitEnabled
                }
                if let filterapp = options.filterapp?.joined(separator: ",") {
                  params["filter[app]"] = filterapp
                }
                if let filterbuilds = options.filterbuilds?.joined(separator: ",") {
                  params["filter[builds]"] = filterbuilds
                }
                if let filterid = options.filterid?.joined(separator: ",") {
                  params["filter[id]"] = filterid
                }
                if let sort = options.sort?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["sort"] = sort
                }
                if let fieldsbetaGroups = options.fieldsbetaGroups?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[betaGroups]"] = fieldsbetaGroups
                }
                if let limit = options.limit {
                  params["limit"] = limit
                }
                if let include = options.include?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["include"] = include
                }
                if let fieldsbuilds = options.fieldsbuilds?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[builds]"] = fieldsbuilds
                }
                if let fieldsbetaTesters = options.fieldsbetaTesters?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[betaTesters]"] = fieldsbetaTesters
                }
                if let fieldsapps = options.fieldsapps?.encode().map({ String(describing: $0) }).joined(separator: ",") {
                  params["fields[apps]"] = fieldsapps
                }
                if let limitbetaTesters = options.limitbetaTesters {
                  params["limit[betaTesters]"] = limitbetaTesters
                }
                if let limitbuilds = options.limitbuilds {
                  params["limit[builds]"] = limitbuilds
                }
                return params
            }
        }

        public enum Response: APIResponseValue, CustomStringConvertible, CustomDebugStringConvertible {
            public typealias SuccessType = BetaGroupsResponse

            /** List of BetaGroups */
            case status200(BetaGroupsResponse)

            /** Parameter error(s) */
            case status400(ErrorResponse)

            /** Forbidden error */
            case status403(ErrorResponse)

            public var success: BetaGroupsResponse? {
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
            public var responseResult: APIResponseResult<BetaGroupsResponse, ErrorResponse> {
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
                case 200: self = try .status200(decoder.decode(BetaGroupsResponse.self, from: data))
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
