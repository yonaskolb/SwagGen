//
//  SwaggerSpec.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import JSONUtilities
import Yams
import PathKit

public class SwaggerSpec: JSONObjectConvertible, CustomStringConvertible {

    public let paths: [String: Endpoint]
    public let definitions: [String: Schema]
    public let parameters: [String: Parameter]
    public let security: [String: Security]
    public let info: Info
    public let host: String?
    public let basePath: String?
    public let schemes: [String]
    public var enums: [Value] = []

    public var operations: [Operation] {
        return paths.values.reduce([]) { return $0 + $1.operations }
    }

    public var tags: [String] {
        return Array(Set(operations.reduce([]) { $0 + $1.tags })).sorted { $0.compare($1) == .orderedAscending }
    }

    public var opererationsByTag: [String: [Operation]] {
        var dictionary: [String: [Operation]] = [:]

        for tag in tags {
            dictionary[tag] = operations.filter { $0.tags.contains(tag) }
        }
        return dictionary
    }

    public struct Info: JSONObjectConvertible {

        public let title: String
        public let version: String?
        public let description: String?

        public init(jsonDictionary: JSONDictionary) throws {
            title = try jsonDictionary.json(atKeyPath: "title")
            version = jsonDictionary.json(atKeyPath: "version")
            description = jsonDictionary.json(atKeyPath: "description")
        }
    }

    public enum SwaggerSpecError: Error {
        case wrongVersion(version: Double)
    }

    public convenience init(path: Path) throws {
        var url = URL(string: path.string)!
        if url.scheme == nil {
            url = URL(fileURLWithPath: path.string)
        }

        let data = try Data(contentsOf: url)
        let string = String(data: data, encoding: .utf8)!
        let yaml = try Yams.load(yaml: string)
        let json = yaml as! JSONDictionary

        try self.init(jsonDictionary: json)
    }

    required public init(jsonDictionary: JSONDictionary) throws {
        let swaggerVersion: Double = try jsonDictionary.json(atKeyPath: "swagger")
        if floor(swaggerVersion) != 2 {
            throw SwaggerSpecError.wrongVersion(version: swaggerVersion)
        }
        info = try jsonDictionary.json(atKeyPath: "info")
        host = jsonDictionary.json(atKeyPath: "host")
        basePath = jsonDictionary.json(atKeyPath: "basePath")
        schemes = jsonDictionary.json(atKeyPath: "schemes") ?? []

        var paths: [String: Endpoint] = [:]
        if let pathsDictionary = jsonDictionary["paths"] as? [String: JSONDictionary] {

            for (path, endpointDictionary) in pathsDictionary {
                paths[path] = try Endpoint(path: path, jsonDictionary: endpointDictionary)
            }
        }
        self.paths = paths
        definitions = jsonDictionary.json(atKeyPath: "definitions") ?? [:]
        parameters = jsonDictionary.json(atKeyPath: "parameters") ?? [:]
        security = jsonDictionary.json(atKeyPath: "securityDefinitions") ?? [:]

        resolve()
    }

    func resolve() {
        for (name, security) in security {
            security.name = name
        }

        for (name, parameter) in parameters {
            parameter.isGlobal = true
            parameter.globalName = name
            if parameter.enumValues != nil {
                enums.append(parameter)
            }
            else if let arrayEnum = parameter.arrayValue, arrayEnum.enumValues != nil {
                arrayEnum.isGlobal = true
                arrayEnum.globalName = name
                enums.append(arrayEnum)
            }
        }

        for (name, definition) in definitions {
            definition.name = name

            if let reference = getDefinitionSchema(definition.reference) {
                for property in reference.properties {
                    definition.propertiesByName[property.name] = property
                }
            }

            if let reference = getDefinitionSchema(definition.parentReference) {
                definition.parent = reference
            }

            for property in definition.properties {
                if let reference = getDefinitionSchema(property.reference) {
                    property.schema = reference
                }
                if let reference = getDefinitionSchema(property.arrayRef) {
                    property.arraySchema = reference
                }
                if let reference = getDefinitionSchema(property.dictionarySchemaRef) {
                    property.dictionarySchema = reference
                }

                for enumValue in enums {
                    let propertyEnumValues = property.enumValues ?? property.arrayValue?.enumValues ?? []
                    let globalEnumValues = enumValue.enumValues ?? enumValue.arrayValue?.enumValues ?? []
                    if !propertyEnumValues.isEmpty && propertyEnumValues == globalEnumValues {
                        property.isGlobal = true
                        property.globalName = enumValue.globalName ?? enumValue.name
                        continue
                    }
                }
            }
        }

        for operation in operations {

            for (index, parameter) in operation.parameters.enumerated() {
                if let reference = getDefinitionSchema(parameter.reference) {
                    parameter.schema = reference
                }
                if let reference = getParameterReference(parameter.reference) {
                    operation.parameters[index] = reference
                }
                if let reference = getDefinitionSchema(parameter.arrayRef) {
                    parameter.arraySchema = reference
                }
            }
            for response in operation.responses {
                if let reference = getDefinitionSchema(response.schema?.reference) {
                    response.schema?.schema = reference
                } else if let reference = getDefinitionSchema(response.schema?.arrayRef) {
                    response.schema?.arraySchema = reference
                }
                if let reference = getDefinitionSchema(response.schema?.dictionarySchemaRef) {
                    response.schema?.dictionarySchema = reference
                }
            }
        }
    }

    func getDefinitionSchema(_ reference: String?) -> Schema? {
        return reference?.components(separatedBy: "/").last.flatMap { definitions[$0] }
    }

    func getParameterReference(_ reference: String?) -> Parameter? {
        return reference?.components(separatedBy: "/").last.flatMap { parameters[$0] }
    }

    public var description: String {
        let ops = "Operations:\n\t" + operations.map { $0.operationId ?? $0.path }.joined(separator: "\n\t") as String
        let defs = "Definitions:\n" + Array(definitions.values).map { $0.deepDescription(prefix: "\t") }.joined(separator: "\n") as String
        let params = "Parameters:\n" + Array(parameters.values).map { $0.deepDescription(prefix: "\t") }.joined(separator: "\n") as String
        return "\(info)\n\(ops)\n\n\(defs)\n\n\(params))"
    }
}

public class Endpoint {

    public let path: String
    public let methods: [String: Operation]

    required public init(path: String, jsonDictionary: JSONDictionary) throws {
        self.path = path

        var methods: [String: Operation] = [:]
        for method in jsonDictionary.keys {
            if method != "security", let dictionary = jsonDictionary[method] as? JSONDictionary {
                let operation = try Operation(path: path, method: method, jsonDictionary: dictionary)
                methods[method] = operation
            }
        }
        self.methods = methods
    }

    public var operations: [Operation] { return Array(methods.values) }
}

public class Security: JSONObjectConvertible {

    public var name: String = ""
    public var type: String
    public let scopes: [String]?
    public var description: String?

    required public init(jsonDictionary: JSONDictionary) throws {
        type = try jsonDictionary.json(atKeyPath: "type")
        description = jsonDictionary.json(atKeyPath: "description")
        scopes = jsonDictionary.json(atKeyPath: "scopes")
    }

    func deepDescription(prefix: String) -> String {
        return "\(prefix)\(name): \(type)"
    }
}


