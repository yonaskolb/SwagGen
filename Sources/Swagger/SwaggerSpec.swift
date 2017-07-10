import Foundation
import JSONUtilities
import Yams
import PathKit

public struct SwaggerSpec {

    public let json: [String: Any]
    public let version: String
    public let info: Info
    public let host: URL?
    public let basePath: String?
    public let schemes: [TransferScheme]?
    public let consumes: [String]?
    public let produces: [String]?
    public let paths: [Path]
    public let securityDefinitions: [SecuritySchema]
    public let definitions: [SwaggerObject<Schema>]
    public let parameters: [SwaggerObject<Parameter>]
    public let responses: [SwaggerObject<Response>]

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

public struct SwaggerObject<T: JSONObjectConvertible> {
    public let name: String
    public let value: T
}

extension SwaggerSpec {

    public init(path: PathKit.Path) throws {
        var url = URL(string: path.string)!
        if url.scheme == nil {
            url = URL(fileURLWithPath: path.string)
        }

        let data = try Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)!

        try self.init(string: string)
    }

    public init(string: String) throws {
        let yaml = try Yams.load(yaml: string)
        let json = yaml as! JSONDictionary

        try self.init(jsonDictionary: json)
    }
}

extension SwaggerSpec: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        json = jsonDictionary
        version = String(describing: jsonDictionary["swagger"])
        if let swaggerVersion = Double(version),
            floor(swaggerVersion) != 2 {
            throw SwaggerError.incorrectVersion(version)
        }

        info = try jsonDictionary.json(atKeyPath: "info")
        host = jsonDictionary.json(atKeyPath: "host")
        basePath = jsonDictionary.json(atKeyPath: "basePath")
        schemes = jsonDictionary.json(atKeyPath: "schemes")
        consumes = jsonDictionary.json(atKeyPath: "consumes")
        produces = jsonDictionary.json(atKeyPath: "produces")

        func decodeObject<T: JSONObjectConvertible>(jsonDictionary: JSONDictionary, key: String) throws -> [SwaggerObject<T>] {
            var values: [SwaggerObject<T>] = []
            if let dictionary = jsonDictionary[key] as? [String: Any] {
                for (key, value) in dictionary {
                    if let dictionary = value as? [String: Any] {
                        let value = try T(jsonDictionary: dictionary )
                        values.append(SwaggerObject<T>(name: key, value: value))
                    }
                }
            }
            return values
        }

        func decodeNamed<T: NamedMappable>(jsonDictionary: JSONDictionary, key: String) throws -> [T] {
            var values: [T] = []
            if let dictionary = jsonDictionary[key] as? [String: Any] {
                for (key, value) in dictionary {
                    if let dictionary = value as? [String: Any] {
                        let value = try T(name: key, jsonDictionary: dictionary )
                        values.append(value)
                    }
                }
            }
            return values
        }

        paths = try decodeNamed(jsonDictionary: jsonDictionary , key: "paths")
        securityDefinitions = try decodeNamed(jsonDictionary: jsonDictionary , key: "securityDefinitions")
        definitions = try decodeObject(jsonDictionary: jsonDictionary , key: "definitions")
        parameters = try decodeObject(jsonDictionary: jsonDictionary , key: "parameters")
        responses = try decodeObject(jsonDictionary: jsonDictionary , key: "responses")

        operations = paths.reduce([]) { $0 + $1.operations }

        resolveReferences()
    }

    func resolveReferences() {

        func resolveDefinitionReference(_ reference: Reference<Schema>) {
            let components = reference.string.components(separatedBy: "/")
            if components.count == 3 && components[0] == "#" && components[1] == "definitions" {
                let name = components[2]
                if let schema = definitions.first(where: { $0.name == name }) {
                    reference.resolve(with: schema.value)
                }
            }
        }

        func resolveParameterReference(_ reference: PossibleReference<Parameter>) {
            if case let .reference(reference) = reference {
                let components = reference.string.components(separatedBy: "/")
                if components.count == 3 && components[0] == "#" && components[1] == "parameters" {
                    let name = components[2]
                    if let param = parameters.first(where: { $0.name == name }) {
                        reference.resolve(with: param.value)
                    }
                }
            }
        }

        func resolveSchema(_ schema: Schema) {
            switch schema.type {
            case let .reference(reference): resolveDefinitionReference(reference)
            case let .object(object): object.properties.forEach { resolveSchema($0.schema) }
            case let .allOf(allOf): allOf.subschemas.forEach(resolveSchema)
            case let .array(array):
                switch array.items {
                case let .single(schema): resolveSchema(schema)
                case let .multiple(schemas): schemas.forEach(resolveSchema)
                }
            default: break
            }
        }

        func resolveParamater(_ parameter: Parameter) {
            switch parameter.type {
            case let .body(schema): resolveSchema(schema)
            default: break
            }
        }

        definitions.forEach { resolveSchema($0.value) }
        parameters.forEach { resolveParamater($0.value) }
        paths.forEach { path in
            path.parameters.forEach(resolveParameterReference)
            path.operations.forEach {
                $0.pathParameters.forEach(resolveParameterReference)
                $0.operationParameters.forEach(resolveParameterReference)
            }
        }
    }
}
