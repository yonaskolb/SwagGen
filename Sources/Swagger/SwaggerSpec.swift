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
    public let securityDefinitions: [String: SecurityDefinition]
    public let info: Info
    public let host: String?
    public let basePath: String?
    public let schemes: [String]
    public var enums: [Value] = []
    public let json: JSONDictionary
    public var invalidReferences: [String] = []

    public var operations: [Operation] {
        return paths.values.reduce([]) { return $0 + $1.operations }
    }

    public var tags: [String] {
        return Array(Set(operations.reduce([]) { $0 + $1.tags })).sorted { $0.compare($1) == .orderedAscending }
    }

    public var opererationsByTag: [String: [Operation]] {
        var dictionary: [String: [Operation]] = [:]

        if tags.isEmpty {
            dictionary[""] = operations
            return dictionary
        }

        let operationWithoutTag = operations.filter { $0.tags.isEmpty }
        dictionary[""] = operationWithoutTag


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

        try self.init(string: string)
    }

    public convenience init(string: String) throws {
        let yaml = try Yams.load(yaml: string)
        let json = yaml as! JSONDictionary

        try self.init(jsonDictionary: json)
    }

    required public init(jsonDictionary: JSONDictionary) throws {
        self.json = jsonDictionary
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
        securityDefinitions = jsonDictionary.json(atKeyPath: "securityDefinitions") ?? [:]

        resolve()
    }

    func resolve() {

        for (name, parameter) in parameters {
            parameter.isGlobal = true
            parameter.globalName = name
            if parameter.isEnum {
                parameter.isGlobal = true
                parameter.globalName = name
                enums.append(parameter)
            }
            resolveValue(parameter)
        }

        for (name, definition) in definitions {
            definition.name = name
            resolveSchema(definition)
        }

        for operation in operations {

            for (index, parameter) in operation.parameters.enumerated() {
                if let reference = getParameterSchema(parameter.reference) {
                    operation.parameters[index] = reference
                } else {
                    resolveValue(parameter)
                }
            }
            for response in operation.responses {
                if let schema = response.schema {
                    resolveValue(schema)
                }
            }
        }
    }

    func resolveSchema(_ schema: Schema) {
        if let reference = getDefinitionSchema(schema.reference) {
            schema.reference = nil

            for property in reference.properties {
                schema.propertiesByName[property.name] = property
            }
            resolveSchema(reference)
        }

        if let reference = getDefinitionSchema(schema.parentReference) {
            reference.parentReference = nil
            schema.parent = reference
            resolveSchema(reference)
        }

        if case .a(let additionalSchema) = schema.additionalProperties,
            let reference =  getDefinitionSchema(schema.reference) {
            additionalSchema.schema = reference
            resolveSchema(reference)
        }

        for property in schema.properties {

            if property.isEnum {

                for enumValue in enums {

                    if (property.nestedEnumValues?.count ?? 0) > 0 && (enumValue.nestedEnumValues?.count ?? 0) > 0 && property.nestedEnumValues! == enumValue.nestedEnumValues! {
                        property.isGlobal = true
                        property.globalName = enumValue.globalName ?? enumValue.name
                    }
                }
            }
            resolveValue(property)
        }
    }

    func resolveValue(_ value: Value) {

        if let schema = getDefinitionSchema(value.reference) {
            value.reference = nil
            value.schema = schema
            resolveSchema(schema)
        }

        if let schema = getDefinitionSchema(value.arrayRef) {
            value.arrayRef = nil
            value.arraySchema = schema
            resolveSchema(schema)
        }

        if let schema = getDefinitionSchema(value.dictionarySchemaRef) {
            value.dictionarySchemaRef = nil
            value.dictionarySchema = schema
            resolveSchema(schema)
        }

        if let value = value.arrayValue {
            resolveValue(value)
        }

        if let value = value.dictionaryValue {
            resolveValue(value)
        }
    }

    func getDefinitionSchema(_ reference: String?) -> Schema? {
        guard let reference = reference,
            reference.contains("/definitions/"),
            let definitionReference = reference.components(separatedBy: "/").last else {
                return nil
        }

        guard let schema = definitions[definitionReference] else {
            // Couldn't find definition!
            invalidReferences.append(reference)
            return nil
        }
        return schema
    }

    func getParameterSchema(_ reference: String?) -> Parameter? {
        guard let reference = reference,
            reference.contains("/parameters/"),
            let parameterReference = reference.components(separatedBy: "/").last else {
                return nil
        }
        guard let schema = parameters[parameterReference] else {
            // Couldn't find parameter!
            invalidReferences.append(reference)
            return nil
        }
        return schema
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
    public let operations: [Operation]

    required public init(path: String, jsonDictionary: JSONDictionary) throws {
        self.path = path

        var operations: [Operation] = []
        for method in jsonDictionary.keys {
            if let operationMethod = Operation.Method(rawValue: method), let dictionary = jsonDictionary[method] as? JSONDictionary {
                let operation = try Operation(path: path, method: operationMethod, jsonDictionary: dictionary)
                operations.append(operation)
            }
        }
        self.operations = operations
    }
}
