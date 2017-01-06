import Alamofire
import JSONUtilities

extension APIRequest {

    /// pass in an optional baseURL, otherwise {{ options.name }}.baseURL will be used
    public func createURLRequest(baseURL: String? = nil) -> URLRequest {
        let url = URL(string: "\(baseURL ?? {{ options.name }}.baseURL)/\(path)")!
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

        let encoding:ParameterEncoding = service.hasBody ? JSONEncoding.default : URLEncoding.queryString
        let encodedURLRequest = try! encoding.encode(urlRequest, with: params)
        return encodedURLRequest
    }

    /// pass in an optional baseURL, otherwise {{ options.name }}.baseURL will be used
    @discardableResult
    public func makeNetworkRequest(baseURL: String? = nil, sessionManager: SessionManager = .default, completion:@escaping (DataResponse<ResponseType>) -> Void) -> Request? {
        let urlRequest = createURLRequest(baseURL: baseURL)
        return sessionManager.request(urlRequest)
        .validate()
        .responseJSON { response in
            let result: Result<ResponseType>
            switch response.result {
            case .success(let value):
                if () is ResponseType {
                    result = .success(() as! ResponseType)
                } else {
                    do {
                        let decoded = try self.service.decode(json: value)
                        result = .success(decoded)
                    }
                    catch let error {
                        result = .failure(error)
                    }
                }
            case .failure(let error):
                result = .failure(error)
            }
            completion(DataResponse(request: response.request, response: response.response, data: response.data, result: result, timeline: response.timeline))
        }
    }
}
