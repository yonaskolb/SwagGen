{% include "Includes/Header.stencil" %}

import Foundation
import JSONUtilities

public enum APIError: Error {
    case unexpectedStatusCode(statusCode: Int, data: Data)
    case jsonDeserializationError(JSONUtilsError)
    case decodingError(DecodingError)
    case invalidBaseURL(String)
    case authorizationError(AuthorizationError)
    case networkError(Error)
    case unknownError(Error)

    public var name:String {
        switch self {
        case .unexpectedStatusCode: return "Unexpected status code"
        case .jsonDeserializationError: return "JSON deserialization error"
        case .decodingError: return "Decoding error"
        case .invalidBaseURL: return "Invalid base URL"
        case .authorizationError: return "Failed to authorize"
        case .networkError: return "Network error"
        case .unknownError: return "Unknown error"
        }
    }
}

extension APIError: CustomStringConvertible {

    public var description:String {
        switch self {
        case .unexpectedStatusCode(let statusCode, _): return "\(name): \(statusCode)"
        case .jsonDeserializationError(let error): return "\(name): \(error)"
        case .decodingError(let error): return "\(name): \(error.description)"
        case .invalidBaseURL(let url): return "\(name): \(url)"
        case .authorizationError(let error): return "\(name): \(error.reason)"
        case .networkError(let error): return "\(name): \(error.localizedDescription)"
        case .unknownError(let error): return "\(name): \(error.localizedDescription)"
        }
    }
}
