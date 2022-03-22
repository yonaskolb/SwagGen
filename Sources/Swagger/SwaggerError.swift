import Foundation
import JSONUtilities

public enum SwaggerError: CustomStringConvertible, LocalizedError {
	
	case invalidVersion(String)
	case invalidItemType(JSONDictionary)
	case invalidSchemaType(JSONDictionary)
	case invalidArraySchema([String: Any])
	case loadError(URL)
	case parseError(String)
	case noUrl
	case unresolvedReference(String)
	 
	public var errorDescription: String? { description }
	
	public var description: String {
		switch self {
			
		case let .invalidVersion(version):
			return "Invalid version \(version)"
		case let .invalidItemType(dictionary):
			return "Invalid item type:\n\(dictionary)"
		case let .invalidSchemaType(dictionary):
			return "Invalid schema type:\n\(dictionary)"
		case let .invalidArraySchema(array):
			return "Invalid array schema:\n\(array)"
		case let .loadError(url):
			return "Couldn't load url \(url)"
		case let .parseError(message):
			return "Swagger Parsing Error \(message)"
		case .noUrl:
			return "Missing base URL"
		case .unresolvedReference(let string):
			return "Reference \(string) is unresolved"
		}
	}
}
