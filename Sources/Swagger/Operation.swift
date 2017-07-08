import JSONUtilities

public struct Operation {

    public let json: [String: Any]
    public let path: String
    public let method: Method
    public let summary: String?
    public let description: String?
    public let pathParameters: [PossibleReference<Parameter>]
    public let operationParameters: [PossibleReference<Parameter>]

    public var parameters: [PossibleReference<Parameter>] {
        return operationParameters + pathParameters.filter { pathParam in
                operationParameters.contains { $0.value.name == pathParam.name }
        }
    }

    public var bodyParam: PossibleReference<Parameter>? {
        return parameters.first { $0.value.location == .body }
    }

    public let responses: [StatusCodeResponse]
    public let defaultResponse: PossibleReference<Response>?
    public let deprecated: Bool
    public let identifier: String?
    public let tags: [String]
    public let security: [SecurityRequirement]?

    public enum Method: String {
        case get
        case put
        case post
        case delete
        case options
        case head
        case patch
    }
}

extension Operation {

    public init(path: String, method: Method, pathParameters: [PossibleReference<Parameter>], jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        self.path = path
        self.method = method
        self.pathParameters = pathParameters
        operationParameters = (jsonDictionary.json(atKeyPath: "parameters")) ?? []
        summary = jsonDictionary.json(atKeyPath: "summary")
        description = jsonDictionary.json(atKeyPath: "description")

        identifier = jsonDictionary.json(atKeyPath: "operationId")
        tags = (jsonDictionary.json(atKeyPath: "tags")) ?? []
        security = jsonDictionary.json(atKeyPath: "security")

        let allResponses: [String: PossibleReference<Response>] = try jsonDictionary.json(atKeyPath: "responses")
        var mappedResponses: [StatusCodeResponse] = []
        for (key, response) in allResponses {
            if let statusCode = Int(key) {
                let response = StatusCodeResponse(statusCode: statusCode, response: response)
                mappedResponses.append(response)
            }
        }

        responses = mappedResponses.sorted { $0.statusCode < $1.statusCode }
        defaultResponse = allResponses["default"]
        deprecated = (jsonDictionary.json(atKeyPath: "deprecated")) ?? false
    }
}
