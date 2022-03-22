import Foundation
import JSONUtilities
import PathKit
import Yams

public struct SwaggerSpec {

    public var json: [String: Any]
    public var version: String
    public var info: Info
		public var paths: [String: PossibleReference<Path>]
    public var servers: [Server]
    public var components: Components
    public var securityRequirements: [SecurityRequirement]?

	public var allOperations: [(String, Operation)] {
		operations.flatMap { v in v.value.map { (v.key, $0) } }
	}
	
	public var operations: [String: [Operation]] {
		paths
			.mapValues {
				$0._value?.operations.sorted(by: { $0.method < $1.method }) ?? []
			}
//			.sorted(by: { $0.key < $1.key })
//			.reduce([]) { $0 + ($1.value._value?.operations.sorted(by: { $0.method < $1.method }) ?? []) }
	}

    public var tags: [String] {
			let tags: [String] = operations.reduce([]) { $0 + $1.value.flatMap({ $0.tags }) }
        let distinctTags = Set(tags)
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
					try self.init(string: string, url: url)
        } else if let string = String(data: data, encoding: .ascii) {
					try self.init(string: string, url: url)
        } else {
            throw SwaggerError.parseError("Swagger doc is not utf8 or ascii encoded")
        }
    }

    public init(path: PathKit.Path) throws {
        let string: String = try path.read()
			try self.init(string: string, url: nil)
    }

	public init(string: String, url: URL? = nil) throws {
		let yaml = try Yams.load(yaml: string)
		let json = yaml as? JSONDictionary ?? [:]
		try self.init(jsonDictionary: json, url: url)
	}
}

extension SwaggerSpec {

	public init(jsonDictionary: JSONDictionary, url: URL?) throws {

			func decodeNamed<T: JSONObjectConvertible>(jsonDictionary: JSONDictionary, key: String) throws -> [String: T] {
            if let dictionary = jsonDictionary[key] as? [String: Any] {
							return try dictionary.compactMapValues {
								if let dictionary = $0 as? [String: Any] {
									return try T(jsonDictionary: dictionary)
								} else {
									return nil
								}
							}
						} else {
							return [:]
						}
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
        let resolver = ComponentResolver(spec: self, schemeURL: url)
        try resolver.resolve()
    }
}
