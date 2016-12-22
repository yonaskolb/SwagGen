//
//  SwaggerSpec.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import JSONUtilities
import Yaml
import PathKit

class SwaggerSpec: JSONObjectConvertible, CustomStringConvertible {

    let paths: [String: Endpoint]
    let definitions: [String: Definition]
    let parameters: [String: Parameter]
    let security: [String: Security]
    let info: Info
    let host: String?
    let basePath: String?
    let schemes: [String]

    struct Info: JSONObjectConvertible {

        let title: String?
        let version: String?
        let description: String?

        init(jsonDictionary: JSONDictionary) throws {
            title = jsonDictionary.json(atKeyPath: "title")
            version = jsonDictionary.json(atKeyPath: "version")
            description = jsonDictionary.json(atKeyPath: "description")
        }
    }

    convenience init(path: String) throws {
        var url = URL(string: path)!
        if url.scheme == nil {
            url = URL(fileURLWithPath: path)
        }
        else {
            print("Loading spec from \(path)")
        }

        let data = try Data(contentsOf: url)
        let json: JSONDictionary

        //if the file is sure to by json do a simple parse otherwise use the slower YAML parser
        if url.pathExtension == "json" {
            json = try JSONDictionary.from(jsonData: data)
        }
        else {
            if let maybeJSON: JSONDictionary = try? JSONDictionary.from(jsonData: data) {
                json = maybeJSON
            }
            else {
                print("Parsing yaml")
                let string = String(data: data, encoding: .utf8)!
                let yaml = try Yaml.load(string)
                json = yaml.jsonDictionary!
            }
        }

        try self.init(jsonDictionary: json)
    }

    required init(jsonDictionary: JSONDictionary) throws {
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
        definitions = try jsonDictionary.json(atKeyPath: "definitions")
        parameters = jsonDictionary.json(atKeyPath: "parameters") ?? [:]
        security = try jsonDictionary.json(atKeyPath: "securityDefinitions")

        resolve()
    }

    func resolve() {
        for (name, security) in security {
            security.name = name
        }

        for (_, parameter) in parameters {
            parameter.isGlobal = true
        }

        for (name, definition) in definitions {
            definition.name = name

            if let reference = getDefinitionReference(definition.reference) {
                for property in reference.properties {
                    definition.propertiesByName[property.name] = property
                }
            }

            if let reference = getDefinitionReference(definition.parentReference) {
                definition.parent = reference
            }

            for property in definition.properties {
                if let reference = getDefinitionReference(property.reference) {
                    property.object = reference
                }
                if let reference = getDefinitionReference(property.arrayRef) {
                    property.arrayDefinition = reference
                }
                if let reference = getDefinitionReference(property.dictionaryDefinitionRef) {
                    property.dictionaryDefinition = reference
                }
            }
        }

        for operation in operations {

            for (index, parameter) in operation.parameters.enumerated() {
                if let reference = getDefinitionReference(parameter.reference) {
                    parameter.object = reference
                }
                if let reference = getParameterReference(parameter.reference) {
                    operation.parameters[index] = reference
                }
                if let reference = getDefinitionReference(parameter.arrayRef) {
                    parameter.arrayDefinition = reference
                }
            }
            for response in operation.responses {
                if let reference = getDefinitionReference(response.schema?.reference) {
                    response.schema?.object = reference
                } else if let reference = getDefinitionReference(response.schema?.arrayRef) {
                    response.schema?.arrayDefinition = reference
                }
                if let reference = getDefinitionReference(response.schema?.dictionaryDefinitionRef) {
                    response.schema?.dictionaryDefinition = reference
                }
            }
        }
    }

    func getDefinitionReference(_ reference: String?) -> Definition? {
        return reference?.components(separatedBy: "/").last.flatMap { definitions[$0] }
    }

    func getParameterReference(_ reference: String?) -> Parameter? {
        return reference?.components(separatedBy: "/").last.flatMap { parameters[$0] }
    }

    var operations: [Operation] {
        return paths.values.reduce([]) { return $0 + $1.operations }
    }

    var tags: [String] {
        return Array(Set(operations.reduce([]) { $0 + $1.tags })).sorted { $0.compare($1) == .orderedAscending }
    }

    var opererationsByTag: [String: [Operation]] {
        var dictionary: [String: [Operation]] = [:]

        for tag in tags {
            dictionary[tag] = operations.filter { $0.tags.contains(tag) }
        }
        return dictionary
    }

    var description: String {
        let ops = "Operations:\n\t" + operations.map { $0.operationId }.joined(separator: "\n\t") as String
        let defs = "Definitions:\n" + Array(definitions.values).map { $0.deepDescription(prefix: "\t") }.joined(separator: "\n") as String
        return "\(info)\n\n\(ops)\n\n\(defs))"
    }
}

class Endpoint {

    let path: String
    let methods: [String: Operation]

    required init(path: String, jsonDictionary: JSONDictionary) throws {
        self.path = path
        let methodsTypes = ["get", "delete", "post", "put"]
        var methods: [String: Operation] = [:]
        for method in methodsTypes {

            if let dictionary = jsonDictionary[method] as? JSONDictionary, let operation = try? Operation(path: path, method: method, jsonDictionary: dictionary) {
                methods[method] = operation
            }
        }
        self.methods = methods
    }

    var operations: [Operation] { return Array(methods.values) }
}

class Operation {

    let operationId: String
    let description: String?
    let tags: [String]
    var parameters: [Parameter]
    let method: String
    let path: String
    let responses: [Response]
    var security: [OperationSecurity]

    init(path: String, method: String, jsonDictionary: JSONDictionary) throws {
        self.method = method
        self.path = path
        operationId = try jsonDictionary.json(atKeyPath: "operationId")
        description = jsonDictionary.json(atKeyPath: "description")
        tags = try jsonDictionary.json(atKeyPath: "tags")
        parameters = try jsonDictionary.json(atKeyPath: "parameters")
        security = jsonDictionary.json(atKeyPath: "security") ?? []
        let responseDictionary: JSONDictionary = try jsonDictionary.json(atKeyPath: "responses")
        var responses: [Response] = []
        for (key, value) in responseDictionary {
            if let statusCode = Int(key), let jsonDictionary = value as? JSONDictionary {
                responses.append(Response(statusCode: statusCode, jsonDictionary: jsonDictionary))
            }
        }
        self.responses = responses
    }

    func getParameters(type: Parameter.ParamaterType) -> [Parameter] {
        return parameters.filter { $0.parameterType == type }
    }

    var enums: [Parameter] {
        return parameters.filter { $0.enumValues != nil || $0.arrayValue?.enumValues != nil }
    }
}

class Response {

    let statusCode: Int
    let description: String?
    var schema: Value?

    init(statusCode: Int, jsonDictionary: JSONDictionary) {
        self.statusCode = statusCode
        description = jsonDictionary.json(atKeyPath: "description")
        schema = jsonDictionary.json(atKeyPath: "schema")
    }
}

class Definition: JSONObjectConvertible {

    var name: String = ""
    let type: String?
    let description: String?
    let reference: String?
    var parentReference: String?
    var parent: Definition?
    var propertiesByName: [String: Property]
    let requiredProperties: [Property]
    let optionalProperties: [Property]
    let properties: [Property]

    required init(jsonDictionary: JSONDictionary) throws {

        var json = jsonDictionary
        if let allOf = json.json(atKeyPath: "allOf") as [JSONDictionary]? {
            parentReference = allOf[0].json(atKeyPath: "$ref")
            json = allOf[1]
        }
        type = json.json(atKeyPath: "type")
        reference = json.json(atKeyPath: "$ref")
        description = json.json(atKeyPath: "description")
        propertiesByName = try json.json(atKeyPath: "properties")
        propertiesByName.forEach { name, property in
            property.name = name
        }

        if let required = json.json(atKeyPath: "required") as [String]? {
            for property in required {
                propertiesByName[property]?.required = true
            }
        }
        requiredProperties = Array(propertiesByName.values).filter { $0.required }.sorted{$0.name < $1.name}
        optionalProperties = Array(propertiesByName.values).filter { !$0.required }.sorted{$0.name < $1.name}
        properties = requiredProperties + optionalProperties
    }

    var allProperties: [Property] {
        return (parent?.allProperties ?? []) + properties
    }

    func deepDescription(prefix: String) -> String {
        return "\(prefix)\(name)\n\(prefix)\(properties.map { $0.deepDescription(prefix: prefix) }.joined(separator: "\n\(prefix)"))"
    }

    var enums: [Value] {
        return properties.filter { $0.enumValues != nil || $0.arrayValue?.enumValues != nil }
    }
}

class Value: JSONObjectConvertible {

    var name: String
    let description: String?
    var required: Bool
    var type: String
    var reference: String?
    var format: String?
    var enumValues: [String]?
    var arrayValue: Value?
    var arrayDefinition: Definition?
    var arrayRef: String?
    var object: Definition?
    var dictionaryDefinition: Definition?
    var dictionaryDefinitionRef: String?
    var dictionaryValue: Value?

    required init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.json(atKeyPath: "name") ?? ""
        description = jsonDictionary.json(atKeyPath: "description")
        reference = jsonDictionary.json(atKeyPath: "$ref")

        arrayRef = jsonDictionary.json(atKeyPath: "items.$ref")
        arrayValue = jsonDictionary.json(atKeyPath: "items")

        dictionaryDefinitionRef = jsonDictionary.json(atKeyPath: "additionalProperties.$ref")
        dictionaryValue = jsonDictionary.json(atKeyPath: "additionalProperties")

        required = jsonDictionary.json(atKeyPath: "required") ?? false
        type = jsonDictionary.json(atKeyPath: "type") ?? "unknown"
        format = jsonDictionary.json(atKeyPath: "format")
        enumValues = jsonDictionary.json(atKeyPath: "enum")
        if let schemaRef = jsonDictionary.json(atKeyPath: "schema.$ref") as String? {
            reference = schemaRef
        }

        if let ref = jsonDictionary.json(atKeyPath: "schema.items.$ref") as String? {
            arrayRef = ref
            if let type = jsonDictionary.json(atKeyPath: "schema.type") as String? {
                self.type = type
            }
        }
    }

    func deepDescription(prefix: String) -> String {
        return "\(prefix)\(name): \(type)"
    }
}

class Parameter: Value {

    var parameterType: ParamaterType?
    var isGlobal = false

    enum ParamaterType: String {
        case body
        case path
        case query
        case form
    }

    required init(jsonDictionary: JSONDictionary) throws {
        parameterType = (try? jsonDictionary.json(atKeyPath: "in") as String).flatMap { ParamaterType(rawValue: $0) }
        try super.init(jsonDictionary: jsonDictionary)
    }
}

class Property: Value {
}

class Security: JSONObjectConvertible {

    var name: String = ""
    var type: String
    let scopes: [String]?
    var description: String?

    required init(jsonDictionary: JSONDictionary) throws {
        type = try jsonDictionary.json(atKeyPath: "type")
        description = jsonDictionary.json(atKeyPath: "description")
        scopes = jsonDictionary.json(atKeyPath: "scopes")
    }

    func deepDescription(prefix: String) -> String {
        return "\(prefix)\(name): \(type)"
    }
}

struct OperationSecurity: JSONObjectConvertible {
    let name: String
    let scopes: [String]

    init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.keys.first ?? ""
        scopes = try jsonDictionary.json(atKeyPath: "\(name).scopes")
    }
}
