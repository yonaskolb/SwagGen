{% include "Includes/Header.stencil" %}

import Foundation

public enum APIError: Error {
    case unexpectedStatusCode(statusCode: Int, data: Data)
    case decodingError(DecodingError)
    case invalidBaseURL(String)
    case authorizationError(AuthorizationError)
    case networkError(Error)
    case unknownError(Error)
    case noData

    public var name:String {
        switch self {
        case .unexpectedStatusCode: return "Unexpected status code"
        case .decodingError: return "Decoding error"
        case .invalidBaseURL: return "Invalid base URL"
        case .authorizationError: return "Failed to authorize"
        case .networkError: return "Network error"
        case .unknownError: return "Unknown error"
        case .noData: return "No Data"
        }
    }
}

extension APIError: CustomStringConvertible {

    public var description:String {
        switch self {
        case .unexpectedStatusCode(let statusCode, _): return "\(name): \(statusCode)"
        case .decodingError(let error): return "\(name): \(error.localizedDescription)"
        case .invalidBaseURL(let url): return "\(name): \(url)"
        case .authorizationError(let error): return "\(name): \(error.reason)"
        case .networkError(let error): return "\(name): \(error.localizedDescription)"
        case .unknownError(let error): return "\(name): \(error.localizedDescription)"
        case .noData: return name
        }
    }
}
