import Foundation
import JSONUtilities

public struct Server {

    public let name: String?
    public let url: String
    public let description: String?
    public let variables: [String: Variable]

    public struct Variable {
        public let defaultValue: String
        public let enumValues: [String]?
        public let enumSafeValues: [String: String]?
        public let description: String?
    }
}

extension Server: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.json(atKeyPath: "name") ?? jsonDictionary.json(atKeyPath: "x-name")
        url = try jsonDictionary.json(atKeyPath: "url")
        description = jsonDictionary.json(atKeyPath: "description")
        variables = jsonDictionary.json(atKeyPath: "variables") ?? [:]
    }
}

extension Server.Variable: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        defaultValue = try jsonDictionary.json(atKeyPath: "default")
        enumValues = jsonDictionary.json(atKeyPath: "enum")
        description = jsonDictionary.json(atKeyPath: "description")
        
        var enumsList: [String: String] = [:]
        
        enumValues?.forEach {
            enumsList[$0.cleanEnumValue()] = $0
        }
        enumSafeValues = enumsList
    }
}

private extension String {
    func cleanEnumValue() -> String {
        var valueNameComponents = replacingOccurrences(of: "[\\[\\]^+<>\\. ]", with: "_", options: .regularExpression, range: nil)
            .components(separatedBy: "_")
        let firstPart = valueNameComponents.first ?? ""
        valueNameComponents.removeFirst(1)
        
        return firstPart + valueNameComponents.map{
            $0.prefix(1).uppercased() + $0.dropFirst()
            }.joined(separator: "")
    }
}
