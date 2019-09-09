import Foundation
import JSONUtilities
import PathKit
import Yams

public struct SwaggerSpec {

    public let json: [String: Any]
    public let version: String
    public let info: Info
    public let paths: [Path]
    public let servers: [Server]
    public let components: Components
    public let securityRequirements: [SecurityRequirement]?

    public let operations: [Operation]

    public var tags: [String] {
        let tags: [String] = operations.reduce([]) { $0 + $1.tags }
        let distinctTags = Array(Set(tags))
        return distinctTags.sorted { $0.compare($1) == .orderedAscending }
    }
}

public enum TransferScheme: String {
    case http
    case https
    case ws
    case wss
}

public protocol NamedMappable {
    init(name: String, jsonDictionary: JSONDictionary) throws
}

extension SwaggerSpec {

    public init(url: URL) throws {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SwaggerError.loadError(url)
        }

        if let string = String(data: data, encoding: .utf8) {
            try self.init(string: string)
        } else if let string = String(data: data, encoding: .ascii) {
            try self.init(string: string)
        } else {
            throw SwaggerError.parseError("Swagger doc is not utf8 or ascii encoded")
        }
    }

    public init(path: PathKit.Path) throws {
        let string: String = try path.read()
        try self.init(string: string)
    }

    public init(string: String) throws {
        let yaml = try Yams.load(yaml: string)
        let json = yaml as? JSONDictionary ?? [:]

        try self.init(jsonDictionary: json)
    }
}

extension SwaggerSpec: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {

        func decodeNamed<T: NamedMappable>(jsonDictionary: JSONDictionary, key: String) throws -> [T] {
            var values: [T] = []
            if let dictionary = jsonDictionary[key] as? [String: Any] {
                for (key, value) in dictionary {
                    if let dictionary = value as? [String: Any] {
                        let value = try T(name: key, jsonDictionary: dictionary)
                        values.append(value)
                    }
                }
            }
            return values
        }

        json = jsonDictionary
        version = try jsonDictionary.json(atKeyPath: "openapi")
        let versionParts = version.components(separatedBy: ".")
        if Int(versionParts[0]) != 3 {
            throw SwaggerError.invalidVersion(version)
        }

        info = try jsonDictionary.json(atKeyPath: "info")
        servers = jsonDictionary.json(atKeyPath: "servers") ?? []
        securityRequirements = jsonDictionary.json(atKeyPath: "security")
        if jsonDictionary["components"] != nil {
            components = try jsonDictionary.json(atKeyPath: "components")
        } else {
            components = Components()
        }
        paths = try decodeNamed(jsonDictionary: jsonDictionary, key: "paths")
        operations = paths.reduce([]) { $0 + $1.operations }
            .sorted(by: { (lhs, rhs) -> Bool in
                if lhs.path == rhs.path {
                    return lhs.method.rawValue < rhs.method.rawValue
                }
                return lhs.path < rhs.path
            })

        let resolver = ComponentResolver(spec: self)
        resolver.resolve()
    }
}
