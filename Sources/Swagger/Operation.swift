import JSONUtilities

public struct Operation {

    public let json: [String: Any]
    public let method: Method
    public let summary: String?
    public let description: String?
    public let requestBody: PossibleReference<RequestBody>?
    public let pathParameters: [PossibleReference<Parameter>]
    public let operationParameters: [PossibleReference<Parameter>]
    public let responses: [OperationResponse]
    public let defaultResponse: PossibleReference<Response>?
    public let deprecated: Bool
    public let identifier: String?
    public let tags: [String]
    public let securityRequirements: [SecurityRequirement]?
	
	public var parameters: [PossibleReference<Parameter>] {
		return pathParameters.filter { pathParam in
			!operationParameters.contains { $0._value?.name == pathParam._value?.name }
		} + operationParameters
	}
	
	public func generatedIdentifier(path: String) -> String {
		identifier ?? "\(method)\(path)"
	}

	public enum Method: String, Comparable {
		public static func < (lhs: Operation.Method, rhs: Operation.Method) -> Bool {
			lhs.rawValue < rhs.rawValue
		}
		
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

    public init(method: Method, pathParameters: [PossibleReference<Parameter>], jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        self.method = method
        self.pathParameters = pathParameters
        if jsonDictionary["parameters"] != nil {
            operationParameters = try jsonDictionary.json(atKeyPath: "parameters")
        } else {
            operationParameters = []
        }
        summary = jsonDictionary.json(atKeyPath: "summary")
        description = jsonDictionary.json(atKeyPath: "description")
        requestBody = jsonDictionary.json(atKeyPath: "requestBody")

        identifier = jsonDictionary.json(atKeyPath: "operationId")
        tags = (jsonDictionary.json(atKeyPath: "tags")) ?? []
        securityRequirements = jsonDictionary.json(atKeyPath: "security")

        let allResponses: [String: PossibleReference<Response>] = try jsonDictionary.json(atKeyPath: "responses")
        var mappedResponses: [OperationResponse] = []
        for (key, response) in allResponses {
            if let statusCode = Int(key) {
                let response = OperationResponse(statusCode: statusCode, response: response)
                mappedResponses.append(response)
            }
        }

        if let defaultResponse = allResponses["default"] {
            self.defaultResponse = defaultResponse
            mappedResponses.append(OperationResponse(statusCode: nil, response: defaultResponse))
        } else {
            defaultResponse = nil
        }

        responses = mappedResponses.sorted {
            let code1 = $0.statusCode
            let code2 = $1.statusCode
            switch (code1, code2) {
            case let (.some(code1), .some(code2)): return code1 < code2
            case (.some, .none): return true
            case (.none, .some): return false
            default: return false
            }
        }

        deprecated = (jsonDictionary.json(atKeyPath: "deprecated")) ?? false
    }
}
