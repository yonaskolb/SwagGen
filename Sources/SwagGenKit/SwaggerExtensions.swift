//
//  SwaggerExtensions.swift
//  SwagGen
//
//  Created by Yonas Kolb on 2/6/17.
//
//

import Foundation
import SwaggerParser
import Yams
import JSONUtilities
import PathKit

struct OperationFormatter {

    public let path: String
    public let method: OperationType
    public let operation: SwaggerParser.Operation
    public let responses: [ResponseFormatter]
    public let defaultResponse: ResponseFormatter?
    public let parameters: [ParameterFormatter]

    func getParameters(type: ParameterLocation) -> [ParameterFormatter] {
        return parameters.filter { $0.parameter.fields.location == type }
    }

    var enums: [Enum] {
        return parameters.flatMap { $0.enumValue }
    }
}

typealias SwaggerReference<T> = Either<T, Structure<T>>

struct PropertyFormatter {
    let name: String
    let required: Bool
    let schema: Schema

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return schema.getEnum(name: name, description: schema.metadata.description)
    }
}

struct Enum {
    let name: String
    let cases: [Any]
    let description: String?
}

struct ResponseFormatter {
    let response: Response
    let successful: Bool
    let name: String?
    let statusCode: Int?
}

struct ParameterFormatter {
    let parameter: Parameter
    let name: String?

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return parameter.getEnum(name: name ?? parameter.fields.name, description: parameter.fields.description)
    }
}

extension Swagger {

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

        try self.init(JSON: json)
    }
}

extension Swagger {

    var operationFormatters: [OperationFormatter] {
        var operations: [OperationFormatter] = []
        for (pathString, path) in paths {
            for (method, operation) in path.operations {

                var responses: [ResponseFormatter] = operation.responses.map {
                    switch $0.1 {
                    case let .a(response): return ResponseFormatter(response: response, successful: $0.key.description.hasPrefix("2"), name: nil, statusCode: $0.key)
                    case let .b(structure): return ResponseFormatter(response: structure.structure, successful: $0.key.description.hasPrefix("2"), name: structure.name, statusCode: $0.0)
                    }
                }

                let parameters: [ParameterFormatter] = operation.parameters.map {
                    switch $0 {
                    case let .a(parameter): return ParameterFormatter(parameter: parameter, name: nil)
                    case let .b(structure): return ParameterFormatter(parameter: structure.structure, name: structure.name)
                    }
                }

                var defaultResponseFormatter: ResponseFormatter?
                if let defaultResponse = operation.defaultResponse {
                    switch defaultResponse {
                    case let .a(response): defaultResponseFormatter = ResponseFormatter(response: response, successful: false, name: nil, statusCode: nil)
                    case let .b(structure): defaultResponseFormatter = ResponseFormatter(response: structure.structure, successful: false, name: structure.name, statusCode: nil)
                    }
                }

                responses = responses.sorted {
                    let code1 = $0.statusCode
                    let code2 = $1.statusCode
                    switch (code1, code2) {
                    case let (.some(code1), .some(code2)): return code1 < code2
                    case (.some, .none): return true
                    case (.none, .some): return false
                    default: return false
                    }
                }

                let operationFormatter = OperationFormatter(path: pathString, method: method, operation: operation, responses: responses, defaultResponse: defaultResponseFormatter, parameters: parameters)
                operations.append(operationFormatter)
            }
        }
        return operations
    }

    public var tags: [String] {
        let tags: [String] = operationFormatters.reduce([]) { $0 + ($1.operation.tags ?? []) }
        let distinctTags = Array(Set(tags))
        return distinctTags.sorted { $0.compare($1) == .orderedAscending }
    }

    var operationsByTag: [String: [OperationFormatter]] {
        var dictionary: [String: [OperationFormatter]] = [:]

        let operationsWithoutTag = operationFormatters.filter { $0.operation.tags?.isEmpty ?? false }

        if !operationsWithoutTag.isEmpty {
            dictionary[""] = operationsWithoutTag
        }

        for tag in tags {
            dictionary[tag] = operationFormatters.filter { $0.operation.tags?.contains(tag) ?? false }
        }

        return dictionary
    }

    var enums: [Enum] {
        return parameters.flatMap { $0.structure.getEnum(name: $0.name, description: $0.structure.fields.description) }
    }
}

extension Metadata {

    func getEnum(name: String, description: String?) -> Enum? {
        if let enumValues = enumeratedValues {
            return Enum(name: name, cases: enumValues.flatMap { $0 }, description: description)
        }
        return nil
    }
}

extension Structure {

    init(name: String, structure: T) {
        self.name = name
        self.structure = structure
    }
}

extension Schema {

    var metadata: Metadata {
        switch self {
        case let .allOf(schema): return schema.metadata
        case let .any(metadata): return metadata
        case let .array(array): return array.metadata
        case let .boolean(metadata): return metadata
        case let .enumeration(metadata): return metadata
        case let .file(metadata): return metadata
        case let .integer(metadata, _): return metadata
        case let .number(metadata, _): return metadata
        case let .object(object): return object.metadata
        case let .string(metadata, _): return metadata
        case let .structure(metadata, _): return metadata
        case .resolvingReference: fatalError()
        }
    }

    var objectSchema: ObjectSchema? {
        if case let .object(object) = self {
            return object
        }
        return nil
    }

    var parent: Structure<Schema>? {
        if case let .allOf(object) = self {
            for schema in object.subschemas {
                if case let .structure(_, schema) = schema {
                    return schema
                }
            }
        }
        return nil
    }

    var properties: [PropertyFormatter] {
        return requiredProperties + optionalProperties
    }

    var requiredProperties: [PropertyFormatter] {
        switch self {
        case let .object(objectSchema): return objectSchema.requiredProperties
        case let .allOf(allOffSchema):
            for schema in allOffSchema.subschemas {
                if case let .object(objectSchema) = schema {
                    return objectSchema.requiredProperties
                }
            }
            return []
        default: return []
        }
    }

    var optionalProperties: [PropertyFormatter] {
        switch self {
        case let .object(objectSchema): return objectSchema.optionalProperties
        case let .allOf(allOffSchema):
            for schema in allOffSchema.subschemas {
                if case let .object(objectSchema) = schema {
                    return objectSchema.optionalProperties
                }
            }
        default: break
        }
        return []
    }

    var parentProperties: [PropertyFormatter] {
        return parentRequiredProperties + parentOptionalProperties
    }

    private var parentRequiredProperties: [PropertyFormatter] {
        return (parent?.structure.parentRequiredProperties ?? []) + requiredProperties
    }

    private var parentOptionalProperties: [PropertyFormatter] {
        return (parent?.structure.parentOptionalProperties ?? []) + optionalProperties
    }

    func getEnum(name: String, description: String?) -> Enum? {
        switch self {
        case let .object(objectSchema):
            if case let .b(schema) = objectSchema.additionalProperties {
                return schema.getEnum(name: name, description: description)
            }
        case let .string(metadata, _): return metadata.getEnum(name: name, description: description ?? metadata.description)
            // TODO: support enums other than string
        case let .array(array):
            if case let .one(schema) = array.items {
                return schema.getEnum(name: name, description: description)
            }
        default: break
        }
        return nil
    }

    var enums: [Enum] {
        return properties.flatMap { $0.schema.getEnum(name: $0.name, description: $0.schema.metadata.description) }
    }
}

extension ObjectSchema {

    var requiredProperties: [PropertyFormatter] {
        return required.map {
            let property = properties[$0]!
            return PropertyFormatter(name: $0, required: true, schema: property)
        }
    }

    var optionalProperties: [PropertyFormatter] {
        return properties
            .filter { !required.contains($0.0) }
            .map { PropertyFormatter(name: $0.0, required: false, schema: $0.1) }
            .sorted { $0.name < $1.name }
    }

    var allProperties: [PropertyFormatter] {
        return requiredProperties + optionalProperties
    }

    var enums: [Enum] {
        var enums: [Enum] = []
        for (name, property) in properties {
            if let enumValue = property.getEnum(name: name, description: property.metadata.description) {
                enums.append(enumValue)
            }
        }
        if case let .b(schema) = additionalProperties {
            if let enumValue = schema.getEnum(name: schema.metadata.title ?? "UNNKNOWN_ENUM", description: schema.metadata.description) {
                enums.append(enumValue)
            }
        }
        return enums
    }
}

extension Version: CustomStringConvertible {

    public var description: String {
        return [major, minor, patch].flatMap { $0?.description }
            .joined(separator: ".")
    }
}

extension Parameter {

    var metadata: Metadata {
        switch self {
        case let .body(_, schema): return schema.metadata
        case let .other(_, items): return items.metadata
        }
    }

    var fields: FixedParameterFields {
        switch self {
        case let .body(fields, _): return fields
        case let .other(fields, _): return fields
        }
    }

    func getEnum(name: String, description: String?) -> Enum? {

        switch self {
        case let .body(fields, schema): return schema.getEnum(name: name, description: description)
        case let .other(_, items): return items.getEnum(name: name, description: description)
        }
    }
}

extension Items {

    var metadata: Metadata {
        switch self {
        case let .array(item): return item.metadata
        case let .boolean(item): return item
        case let .integer(item): return item.metadata
        case let .number(item): return item.metadata
        case let .string(item): return item.metadata
        }
    }

    func getEnum(name: String, description: String?) -> Enum? {

        switch self {
        case let .array(array):
            if case let .string(item) = array.items {
                if let enumValue = item.metadata.getEnum(name: name, description: description) {
                    return enumValue
                }
            }
        case let .string(item):
            return item.metadata.getEnum(name: name, description: description)
        default: break
        }
        return nil
    }
}

extension CollectionFormat {

    var separator: String {
        switch self {
        case .csv: return ","
        case .ssv: return " "
        case .tsv: return "\t"
        case .pipes: return "|"
        }
    }
}
