
public class APIRequest<ResponseType> {

    public let id: String
    public let tag: String
    public private(set) var path: String
    public let method: String
    private(set) var parameters: [String: Any]
    public let hasBody: Bool
    public let decode: (Any) throws -> ResponseType
    public var headers: [String: String] = [:]
    public let authorization: Authorization?

    init(id: String, tag: String, method:String, path:String, parameters: [String: Any] = [:], headers: [String: String] = [:], hasBody: Bool, authorization: Authorization? = nil, decode: @escaping (Any) throws -> ResponseType) {
        self.id = id
        self.tag = tag
        self.method = method
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.hasBody = hasBody
        self.authorization = authorization
        self.decode = decode
    }

    public func addHeader(name: String, value: String) {
        if !value.isEmpty {
            headers[name] = value
        }
    }
}

public protocol Authorized {
    var authorization: Authorization {get}
}

public struct Authorization {
    let type:String
    let scope:String
}
