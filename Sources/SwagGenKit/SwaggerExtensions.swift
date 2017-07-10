//
//  SwaggerExtensions.swift
//  SwagGen
//
//  Created by Yonas Kolb on 2/6/17.
//
//

import Foundation
import Swagger
import Yams
import JSONUtilities
import PathKit

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

extension SwaggerSpec {

    var operationsByTag: [String: [Swagger.Operation]] {
        var dictionary: [String: [Swagger.Operation]] = [:]
        for tag in tags {
            dictionary[tag] = operations.filter { $0.tags.contains(tag) }
        }
        return dictionary
    }

    var enums: [Enum] {
        return parameters.flatMap { $0.value.getEnum(name: $0.name, description: $0.value.description) }
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

extension Schema {

    var parent: SwaggerObject<Schema>? {
        if case let .allOf(object) = type {
            for schema in object.subschemas {
                if case let .reference(reference) = schema.type {
                    return reference.swaggerObject
                }
            }
        }
        return nil
    }

    var properties: [Property] {
        return requiredProperties + optionalProperties
    }

    var requiredProperties: [Property] {
        switch type {
        case let .object(objectSchema): return objectSchema.requiredProperties
        case let .allOf(allOffSchema):
            for schema in allOffSchema.subschemas {
                if case let .object(objectSchema) = schema.type {
                    return objectSchema.requiredProperties
                }
            }
            return []
        default: return []
        }
    }

    var optionalProperties: [Property] {
        switch type {
        case let .object(objectSchema): return objectSchema.optionalProperties
        case let .allOf(allOffSchema):
            for schema in allOffSchema.subschemas {
                if case let .object(objectSchema) = schema.type {
                    return objectSchema.optionalProperties
                }
            }
        default: break
        }
        return []
    }

    var parentProperties: [Property] {
        return parentRequiredProperties + parentOptionalProperties
    }

    private var parentRequiredProperties: [Property] {
        return (parent?.value.parentRequiredProperties ?? []) + requiredProperties
    }

    private var parentOptionalProperties: [Property] {
        return (parent?.value.parentOptionalProperties ?? []) + optionalProperties
    }

    func getEnum(name: String, description: String?) -> Enum? {
        switch type {
        case let .object(objectSchema):
            if case let .schema(schema) = objectSchema.additionalProperties {
                return schema.getEnum(name: name, description: description)
            }
        case .string: return metadata.getEnum(name: name, description: description ?? metadata.description)
            // TODO: support enums other than string
        case let .array(array):
            if case let .single(schema) = array.items {
                return schema.getEnum(name: name, description: description)
            }
        default: break
        }
        return nil
    }

    var enums: [Enum] {
        var enums = properties.flatMap { $0.schema.getEnum(name: $0.name, description: $0.schema.metadata.description) }
        if case let .object(objectSchema) = type, case let .schema(schema) = objectSchema.additionalProperties {
            enums += schema.enums
        }
        return enums
    }
}

extension Swagger.Operation {

    func getParameters(type: ParameterLocation) -> [Parameter] {
        return parameters.map { $0.value }.filter { $0.location == type }
    }

    var enums: [Enum] {
        return requestEnums + responseEnums
    }

    var requestEnums: [Enum] {
        return parameters.flatMap { $0.value.enumValue }
    }

    var responseEnums: [Enum] {
        return responses.flatMap { $0.enumValue }
    }
}

extension ObjectSchema {

    var enums: [Enum] {
        var enums: [Enum] = []
        for property in properties {
            if let enumValue = property.schema.getEnum(name: property.name, description: property.schema.metadata.description) {
                enums.append(enumValue)
            }
        }
        if case let .schema(schema) = additionalProperties {
            if let enumValue = schema.getEnum(name: schema.metadata.title ?? "UNNKNOWN_ENUM", description: schema.metadata.description) {
                enums.append(enumValue)
            }
        }
        return enums
    }
}

extension OperationResponse {

    public var successful: Bool {
        return statusCode?.description.hasPrefix("2") ?? false
    }

    public var name: String {
        if let statusCode = statusCode {
            return "\(successful ? "success":"failure")\(statusCode.description)"
        } else {
            return "failureDefault"
        }
    }

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return response.value.schema?.getEnum(name: name, description: response.value.description)
    }
}

extension Property {

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return schema.getEnum(name: name, description: schema.metadata.description)
    }
}

extension Parameter {

    func getEnum(name: String, description: String?) -> Enum? {
        switch type {
        case let .body(schema): return schema.getEnum(name: name, description: description)
        case let .other(item): return item.getEnum(name: name, description: description)
        }
    }

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return getEnum(name: name, description: description)
    }
}


extension Item {

    func getEnum(name: String, description: String?) -> Enum? {

        switch type {
        case let .array(array):
            if case .string = array.items.type {
                if let enumValue = array.items.metadata.getEnum(name: name, description: description) {
                    return enumValue
                }
            }
        case .string:
            return metadata.getEnum(name: name, description: description)
        default: break
        }
        return nil
    }
}
