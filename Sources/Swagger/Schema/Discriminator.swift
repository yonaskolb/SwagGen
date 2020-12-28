import Foundation
import JSONUtilities

public struct Discriminator {

    public var propertyName: String
    public let mapping: [String: String]

    public init(propertyName: String, mapping: [String: String]) {
        self.propertyName = propertyName
        self.mapping = mapping
    }
}

extension Discriminator: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        propertyName = try jsonDictionary.json(atKeyPath: "propertyName")
        mapping = jsonDictionary.json(atKeyPath: "mapping") ?? [:]
    }
}
