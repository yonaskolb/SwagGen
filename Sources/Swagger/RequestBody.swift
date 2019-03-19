import Foundation
import JSONUtilities

public struct RequestBody {

    public let required: Bool
    public let description: String?
    public let content: Content
}

extension RequestBody: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        required = jsonDictionary.json(atKeyPath: "required") ?? false
        description = jsonDictionary.json(atKeyPath: "description")
        content = try jsonDictionary.json(atKeyPath: "content")
    }
}
