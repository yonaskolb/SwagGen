{% include "Includes/Header.stencil" %}

import Foundation
import Alamofire
import JSONUtilities

/// Manages and sends APIRequests
public class APIClient {

    public static var `default` = APIClient(baseURL: "{% if options.baseURL %}{{ options.baseURL }}{% else %}{{ baseURL }}{% endif %}")

    /// A list of RequestBehaviours that can be used to monitor and alter all requests
    public var behaviours: [RequestBehaviour] = []

    /// The base url prepended before every request path
    public var baseURL: String

    /// The Alamofire SessionManager used for each request
    public var sessionManager: SessionManager

    /// These headers will get added to every request
    public var defaultHeaders: [String: String]

    /// Used to authorise requests
    public var authorizer: RequestAuthorizer?

    public init(baseURL: String, sessionManager: SessionManager = .default, defaultHeaders: [String: String] = [:], behaviours: [RequestBehaviour] = [], authorizer: RequestAuthorizer? = nil) {
        self.baseURL = baseURL
        self.authorizer = authorizer
        self.sessionManager = sessionManager
        self.behaviours = behaviours
        self.defaultHeaders = defaultHeaders
    }

    /// Any request behaviours will be run in addition to the client behaviours
    @discardableResult
    public func makeRequest<T>(_ request: APIRequest<T>, behaviours: [RequestBehaviour] = [], complete: @escaping (APIResponse<T>) -> Void) -> Request? {
        // create composite behaviour to make it easy to call functions on array of behaviours
        let requestBehaviour = RequestBehaviourGroup(request: request, behaviours: self.behaviours + behaviours)

        // create the url request from the request
        var urlRequest: URLRequest
        do {
            urlRequest = try request.createURLRequest(baseURL: baseURL)
        } catch _ {
            let error = APIError.invalidBaseURL(baseURL)
            requestBehaviour.onFailure(error: error)
            let response = APIResponse<T>(request: request, result: .failure(error))
            complete(response)
            return nil
        }

        // add the default headers
        if urlRequest.allHTTPHeaderFields == nil {
            urlRequest.allHTTPHeaderFields = [:]
        }
        for (key, value) in defaultHeaders {
            urlRequest.allHTTPHeaderFields?[key] = value
        }

        urlRequest = requestBehaviour.modifyRequest(urlRequest)

        if let authorizer = authorizer, let authorization = request.service.authorization {

            // authorize request
            authorizer.authorize(request: requestBehaviour.request, authorization: authorization, urlRequest: urlRequest) { result in

                switch result {
                case .success(let urlRequest):
                    self.makeNetworkRequest(request: request, urlRequest: urlRequest, requestBehaviour: requestBehaviour, complete: complete)
                case .failure(let reason):
                    let error = APIError.authorizationError(AuthorizationError(authorization: authorization, reason: reason))
                    let response = APIResponse<T>(request: request, result: .failure(error), urlRequest: urlRequest)
                    requestBehaviour.onFailure(error: error)
                    complete(response)
                }
            }
            return nil
        } else {
            return self.makeNetworkRequest(request: request, urlRequest: urlRequest, requestBehaviour: requestBehaviour, complete: complete)
        }
    }

    @discardableResult
    private func makeNetworkRequest<T: APIResponseValue>(request: APIRequest<T>, urlRequest: URLRequest, requestBehaviour: RequestBehaviourGroup, complete: @escaping (APIResponse<T>) -> Void) -> Request {
        requestBehaviour.beforeSend()
        return sessionManager.request(urlRequest)
            .responseData { dataResponse in

                let result: APIResult<T>

                switch dataResponse.result {
                case .success(let value):
                    do {
                        let statusCode = dataResponse.response!.statusCode
                        let decoded = try T(statusCode: statusCode, data: value)
                        result = .success(decoded)
                        if decoded.successful {
                            requestBehaviour.onSuccess(result: decoded.response as Any)
                        }
                    } catch let error {
                        let apiError: APIError
                        if let error = error as? JSONUtilsError {
                            apiError = APIError.jsonDeserializationError(error)
                        } else if let error = error as? DecodingError {
                            apiError = APIError.decodingError(error)
                        } else {
                            apiError = APIError.unknownError(error)
                        }

                        result = .failure(apiError)
                        requestBehaviour.onFailure(error: apiError)
                    }
                case .failure(let error):
                    let apiError = APIError.networkError(error)
                    result = .failure(apiError)
                    requestBehaviour.onFailure(error: apiError)
                }
                let response = APIResponse<T>(request: request, result: result, urlRequest: dataResponse.request, urlResponse: dataResponse.response, data: dataResponse.data, timeline: dataResponse.timeline)
                requestBehaviour.onResponse(response: response.asAny())
                complete(response)
        }
    }
}

// Helper extension for sending requests
extension APIRequest {

    /// makes a request using the default APIClient. Change your baseURL in APIClient.default.baseURL
    public func makeRequest(complete: @escaping (APIResponse<ResponseType>) -> Void) {
        APIClient.default.makeRequest(self, complete: complete)
    }
}

// Create URLRequest
extension APIRequest {

    /// pass in an optional baseURL, otherwise URLRequest.url will be relative
    public func createURLRequest(baseURL: String = "") throws -> URLRequest {
        let url = URL(string: "\(baseURL)\(path)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = service.method
        urlRequest.allHTTPHeaderFields = headers

        // filter out parameters with empty string value
        var params: [String: Any] = [:]
        for (key, value) in parameters {
            if String.init(describing: value) != "" {
                params[key] = value
            }
        }
        if !params.isEmpty {
            let encoding: ParameterEncoding = service.hasBody ? URLEncoding.httpBody : URLEncoding.queryString
            urlRequest = try encoding.encode(urlRequest, with: params)
        }
        if let jsonBody = jsonBody {
            // not using Alamofire's JSONEncoding so that we can send a json array instead of being restricted to [String: Any]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}
