import Alamofire
import JSONUtilities

extension APIRequest {

    public func createURLRequest(base: String) -> URLRequest {
        let url = URL(string: "\(base)/\(path)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = service.method

        let encoding:ParameterEncoding = service.hasBody ? JSONEncoding.default : URLEncoding.queryString
        let encodedURLRequest = try! encoding.encode(urlRequest, with: parameters)
        return encodedURLRequest
    }

    @discardableResult
    public func makeNetworkRequest(base: String, sessionManager: SessionManager = .default, completion:@escaping (DataResponse<ResponseType>) -> Void) -> Request? {
        let urlRequest = createURLRequest(base: base)
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
