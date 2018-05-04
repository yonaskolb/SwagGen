{% include "Includes/Header.stencil" %}

import Foundation

public struct Authorization {
    public let type: String
    public let scope: String

    public init(type: String, scope: String) {
        self.type = type
        self.scope = scope
    }
}

public struct AuthorizationError: Error {

    public let authorization: Authorization
    public let reason: String

    public init(authorization: Authorization, reason: String) {
        self.authorization = authorization
        self.reason = reason
    }
}

/// Allows a request that has an authorization on it to be authorized asynchronously
public protocol RequestAuthorizer {

    /// complete must be called with either .success(authorizedURLRequest) or .failure(failureReason)
    func authorize(request: AnyRequest, authorization: Authorization, urlRequest: URLRequest, complete: @escaping (AuthorizationResult) -> Void)
}

public enum AuthorizationResult {
    case success(authorizedRequest: URLRequest)
    case failure(reason: String)
}
