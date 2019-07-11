import Foundation
import JSONUtilities

public struct Components {
    public let securitySchemes: [ComponentObject<SecurityScheme>]
    public let schemas: [ComponentObject<Schema>]
    public let parameters: [ComponentObject<Parameter>]
    public let responses: [ComponentObject<Response>]
    public let requestBodies: [ComponentObject<RequestBody>]
    public let headers: [ComponentObject<Header>]

}

extension Components {

    init() {
        securitySchemes = []
        schemas = []
        parameters = []
        responses = []
        requestBodies = []
        headers = []
    }
}

extension Components: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {

        func decode<T: Component>() throws -> [ComponentObject<T>] {
            var values: [ComponentObject<T>] = []
            if let dictionary = jsonDictionary[T.componentType.rawValue] as? [String: Any] {
                for (key, value) in dictionary {
                    if let dictionary = value as? [String: Any] {
                        let value = try T(jsonDictionary: dictionary)
                        values.append(ComponentObject<T>(name: key, value: value))
                    }
                }
            }
            return values
        }

        securitySchemes = try decode()
        schemas = try decode()
        parameters = try decode()
        responses = try decode()
        requestBodies = try decode()
        headers = try decode()
    }
}

public protocol Named {
    var name: String { get }
}

extension ComponentObject: Named {}

extension Array where Element: Named {

    public func named(_ name: String) -> Element? {
        return first { $0.name == name }
    }
}
