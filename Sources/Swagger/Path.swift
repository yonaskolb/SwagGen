import JSONUtilities

public struct Path: JSONObjectConvertible {
    public let operations: [Operation]
    public let parameters: [PossibleReference<Parameter>]
	
	public init(jsonDictionary: JSONDictionary) throws {
		parameters = (jsonDictionary.json(atKeyPath: "parameters")) ?? []
		
		var mappedOperations: [Operation] = []
		for (key, value) in jsonDictionary {
			if let method = Operation.Method(rawValue: key) {
				if let json = value as? [String: Any] {
					let operation = try Operation(method: method, pathParameters: parameters, jsonDictionary: json)
					mappedOperations.append(operation)
				}
			}
		}
		operations = mappedOperations
	}
}
