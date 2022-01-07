{% include "Includes/Header.stencil" %}

import Foundation
import Alamofire

/// Manages and sends APIRequests
public class APIClient {

    public static var `default` = APIClient(baseURL: {% if options.baseURL %}"{{ options.baseURL }}"{% elif defaultServer %}{{ options.name }}.Server.{{ defaultServer.name }}{% else %}""{% endif %})

    /// A list of RequestBehaviours that can be used to monitor and alter all requests
    public var behaviours: [RequestBehaviour] = []

    /// The base url prepended before every request path
    public var baseURL: String

    /// The Alamofire SessionManager used for each request
    public var sessionManager: Session

    /// These headers will get added to every request
    public var defaultHeaders: [String: String]

    public var jsonDecoder = JSONDecoder()
    public var jsonEncoder = JSONEncoder()

    public var decodingQueue = DispatchQueue(label: "apiClient", qos: .utility, attributes: .concurrent)

    public init(baseURL: String, sessionManager: Session = .default, defaultHeaders: [String: String] = [:], behaviours: [RequestBehaviour] = []) {
        self.baseURL = baseURL
        self.sessionManager = sessionManager
        self.behaviours = behaviours
        self.defaultHeaders = defaultHeaders
        jsonDecoder.dateDecodingStrategy = .custom(dateDecoder)
        jsonEncoder.dateEncodingStrategy = .formatted({{ options.name }}.dateEncodingFormatter)
    }

    /// Makes a network request
    ///
    /// - Parameters:
    ///   - request: The API request to make
    ///   - behaviours: A list of behaviours that will be run for this request. Merged with APIClient.behaviours
    ///   - completionQueue: The queue that complete will be called on
    ///   - complete: A closure that gets passed the APIResponse
    /// - Returns: A cancellable request. Not that cancellation will only work after any validation RequestBehaviours have run
    @discardableResult
    public func makeRequest<T>(_ request: APIRequest<T>, behaviours: [RequestBehaviour] = [], completionQueue: DispatchQueue = DispatchQueue.main, complete: @escaping (APIResponse<T>) -> Void) -> CancellableRequest? {
        // create composite behaviour to make it easy to call functions on array of behaviours
        let requestBehaviour = RequestBehaviourGroup(request: request, behaviours: self.behaviours + behaviours)

        // create the url request from the request
        var urlRequest: URLRequest
        do {
            guard let safeURL = URL(string: baseURL) else {
                throw InternalError.malformedURL
            }

            urlRequest = try request.createURLRequest(baseURL: safeURL, encoder: jsonEncoder)
        } catch {
            let error = APIClientError.requestEncodingError(error)
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

        let cancellableRequest = CancellableRequest(request: request.asAny())

        requestBehaviour.validate(urlRequest) { result in
            switch result {
            case .success(let urlRequest):
                let networkRequest = self.makeNetworkRequest(request: request, urlRequest: urlRequest, requestBehaviour: requestBehaviour, completionQueue: completionQueue, complete: complete)
                cancellableRequest.networkRequest = networkRequest
            case .failure(let error):
                let error = APIClientError.validationError(error)
                let response = APIResponse<T>(request: request, result: .failure(error), urlRequest: urlRequest)
                requestBehaviour.onFailure(error: error)
                complete(response)
            }
        }
        return cancellableRequest
    }

    private func makeNetworkRequest<T>(request: APIRequest<T>, urlRequest: URLRequest, requestBehaviour: RequestBehaviourGroup, completionQueue: DispatchQueue, complete: @escaping (APIResponse<T>) -> Void) -> Request {
        requestBehaviour.beforeSend()

        if request.service.isUpload {
            return sessionManager.upload(
                multipartFormData: { multipartFormData in
                    for (name, value) in request.formParameters {
                        if let file = value as? UploadFile {
                            switch file.type {
                            case let .url(url):
                                if let fileName = file.fileName, let mimeType = file.mimeType {
                                    multipartFormData.append(url, withName: name, fileName: fileName, mimeType: mimeType)
                                } else {
                                    multipartFormData.append(url, withName: name)
                                }
                            case let .data(data):
                                if let fileName = file.fileName, let mimeType = file.mimeType {
                                    multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
                                } else {
                                    multipartFormData.append(data, withName: name)
                                }
                            }
                        } else {
                            func recursiveAppend(formData: MultipartFormData, key: String, value: Any) {
                                switch value {
                                    case let dictionary as [String: Any]:
                                        for (dictionaryKey, dictionaryValue) in dictionary {
                                            recursiveAppend(formData: formData, key: "\(key)[\(dictionaryKey)]", value: dictionaryValue)
                                        }
                                    case let array as [Any]:
                                        for arrayValue in array {
                                            recursiveAppend(formData: formData, key: "\(key)[]", value: arrayValue)
                                        }
                                    case let number as NSNumber:
                                        formData.append(Data(number.stringValue.utf8), withName: key)
                                    case let string as String:
                                        formData.append(Data(string.utf8), withName: key)
                                    case let data as Data:
                                        formData.append(data, withName: key)
                                    case let url as URL:
                                        formData.append(url, withName: key)
                                    default:
                                        formData.append(Data("\(value)".utf8), withName: key)
                                }
                            }
                            recursiveAppend(formData: multipartFormData, key: name, value: value)
                        }
                    }
                },
                with: urlRequest
            )
            .responseData(queue: decodingQueue) { dataResponse in
                self.handleResponse(request: request, requestBehaviour: requestBehaviour, dataResponse: dataResponse, completionQueue: completionQueue, complete: complete)
            }
        } else {
            return sessionManager.request(urlRequest)
                .responseData(queue: decodingQueue) { dataResponse in
                    self.handleResponse(request: request, requestBehaviour: requestBehaviour, dataResponse: dataResponse, completionQueue: completionQueue, complete: complete)

            }
        }
    }

    private func handleResponse<T>(request: APIRequest<T>, requestBehaviour: RequestBehaviourGroup, dataResponse: AFDataResponse<Data>, completionQueue: DispatchQueue, complete: @escaping (APIResponse<T>) -> Void) {

        let result: APIResult<T>

        switch dataResponse.result {
        case .success(let value):
            do {
                guard let statusCode = dataResponse.response?.statusCode else {
                    throw InternalError.emptyResponse
                }

                let decoded = try T(statusCode: statusCode, data: value, decoder: jsonDecoder)
                result = .success(decoded)
                if decoded.successful {
                    requestBehaviour.onSuccess(result: decoded.response as Any)
                }
            } catch let error {
                let apiError: APIClientError
                if let error = error as? DecodingError {
                    apiError = APIClientError.decodingError(error)
                } else if let error = error as? APIClientError {
                    apiError = error
                } else {
                    apiError = APIClientError.unknownError(error)
                }

                result = .failure(apiError)
                requestBehaviour.onFailure(error: apiError)
            }
        case .failure(let error):
            let apiError = APIClientError.networkError(error)
            result = .failure(apiError)
            requestBehaviour.onFailure(error: apiError)
        }
        let response = APIResponse<T>(request: request, result: result, urlRequest: dataResponse.request, urlResponse: dataResponse.response, data: dataResponse.data, metrics: dataResponse.metrics)
        requestBehaviour.onResponse(response: response.asAny())

        completionQueue.async {
            complete(response)
        }
    }
}

private extension APIClient {
    enum InternalError: Error {
        case malformedURL
        case emptyResponse
    }
}

public class CancellableRequest {
    /// The request used to make the actual network request
    public let request: AnyRequest

    init(request: AnyRequest) {
        self.request = request
    }

    var networkRequest: Request?

    /// cancels the request
    public func cancel() {
        networkRequest?.cancel()
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

    public func createURLRequest(baseURL: URL, encoder: RequestEncoder = JSONEncoder()) throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = service.method
        urlRequest.allHTTPHeaderFields = headers

        // filter out parameters with empty string value
        var queryParams: [String: Any] = [:]
        for (key, value) in queryParameters {
            if !String(describing: value).isEmpty {
                queryParams[key] = value
            }
        }

        if !queryParams.isEmpty {
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParams)
        }

        var formParams: [String: Any] = [:]
        for (key, value) in formParameters {
            if !String(describing: value).isEmpty {
                formParams[key] = value
            }
        }

        if !formParams.isEmpty {
            urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: formParams)
        }

        if let encodeBody = encodeBody {
            urlRequest.httpBody = try encodeBody(encoder)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}
