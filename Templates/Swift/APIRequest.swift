{% include "Includes/Header.stencil" %}

public class APIRequest<ResponseType: APIResponseValue> {

    public let service: APIService<ResponseType>
    public private(set) var parameters: [String: Any]
    public private(set) var jsonBody: Any?
    public var headers: [String: String] = [:]

    public var path: String {
        return service.path
    }

    public init(service: APIService<ResponseType>, parameters: [String: Any] = [:], jsonBody: Any? = nil, headers: [String: String] = [:]) {
        self.service = service
        self.parameters = parameters
        self.jsonBody = jsonBody
        self.headers = headers
    }

    public func addHeader(name: String, value: String) {
        if !value.isEmpty {
            headers[name] = value
        }
    }
}

extension APIRequest: CustomStringConvertible {

    public var description: String {
        var string = "\(service.name): \(service.method) \(path)"
        if !parameters.isEmpty {
            string += "?" + parameters.map {"\($0)=\($1)"}.joined(separator: "&")
        }
        return string
    }
}

extension APIRequest: CustomDebugStringConvertible {

    public var debugDescription: String {
        var string = description
        if let body = jsonBody {
            string += "\nbody: \(body)"
        }
        return string
    }
}
