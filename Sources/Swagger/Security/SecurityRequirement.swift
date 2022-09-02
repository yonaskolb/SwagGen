import Foundation
import JSONUtilities

public struct SecurityRequirement: Equatable {
    public let name: String
    public let isRequired: Bool
    public let scopes: [String]

    public static let optionalMarker: SecurityRequirement = {
        .init(name: "optional-marker", isRequired: false, scopes: [])
    }()
}

extension SecurityRequirement: JSONObjectConvertible {
    public init(jsonDictionary: JSONDictionary) throws {
        guard let firstKey = jsonDictionary.keys.first else {
            self = .optionalMarker
            return
        }
        name = firstKey
        isRequired = true
        scopes = try jsonDictionary.json(atKeyPath: .key(name))
    }
}

extension Array where Element == SecurityRequirement {
    func updatingRequiredFlag() -> [Element] {
        // Check if there is an optional security requirement marker
        guard (contains(where: { $0 == .optionalMarker })) else {
            return self
        }
        // Remove the optional marker and set all security requirements as optional
        return self
            .drop { $0 == .optionalMarker }
            .map { .init(name: $0.name, isRequired: false, scopes: $0.scopes) }
    }
}
