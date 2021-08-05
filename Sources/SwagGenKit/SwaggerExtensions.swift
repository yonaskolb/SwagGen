import Foundation
import JSONUtilities
import PathKit
import Swagger
import Yams

struct Enum {
    let name: String
    let cases: [Any]
    let schema: Schema
    let description: String?
    let metadata: Metadata
    let names: [String]?
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

        // add operations with no tag at ""
        let operationsWithoutTag = operations
            .filter { $0.tags.isEmpty }
            .sorted { $0.generatedIdentifier < $1.generatedIdentifier }
        if !operationsWithoutTag.isEmpty {
            dictionary[""] = operationsWithoutTag
        }

        for tag in tags {
            dictionary[tag] = operations
                .filter { $0.tags.contains(tag) }
                .sorted { $0.generatedIdentifier < $1.generatedIdentifier }
        }
        return dictionary
    }

    var enums: [Enum] {
        return components.parameters.compactMap { $0.value.getEnum(name: $0.name, description: $0.value.description) }
    }
}

extension Metadata {

    func getEnum(name: String, schema: Schema, description: String?) -> Enum? {
        if let enumValues = enumValues {
            return Enum(name: name, cases: enumValues.compactMap { $0 }, schema: schema, description: description ?? self.description, metadata: self, names: enumNames)
        }
        return nil
    }
}

extension Schema {

    var parent: ComponentObject<Schema>? {
        if case let .group(group) = type, group.type == .all {
            for schema in group.schemas {
                if case let .reference(reference) = schema.type {
                    return reference.component
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
        case let .group(groupSchema) where groupSchema.type == .all:
            for schema in groupSchema.schemas {
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
        case let .group(groupSchema) where groupSchema.type == .all:
            for schema in groupSchema.schemas {
                if case let .object(objectSchema) = schema.type {
                    return objectSchema.optionalProperties
                }
            }
        default: break
        }
        return []
    }

    var inheritedProperties: [Property] {
        return inheritedRequiredProperties + inheritedOptionalProperties
    }

    var inheritedRequiredProperties: [Property] {
        return (parent?.value.inheritedRequiredProperties ?? []) + requiredProperties
    }

    var inheritedOptionalProperties: [Property] {
        return (parent?.value.inheritedOptionalProperties ?? []) + optionalProperties
    }

    func getEnum(name: String, description: String?) -> Enum? {
        switch type {
        case let .object(objectSchema):
            if let schema = objectSchema.additionalProperties {
                return schema.getEnum(name: name, description: description)
            }
        case .string, .integer, .number:
            return metadata.getEnum(name: name, schema: self, description: description)
        case let .array(array):
            if case let .single(schema) = array.items {
                return schema.getEnum(name: name, description: description)
            }
        default: break
        }
        return nil
    }

    var enums: [Enum] {
        var enums = properties.compactMap { $0.schema.getEnum(name: $0.name, description: $0.schema.metadata.description) }
        if case let .object(objectSchema) = type, let schema = objectSchema.additionalProperties {
            enums += schema.enums
        }
        return enums
    }

    var inheritedEnums: [Enum] {
        return (parent?.value.inheritedEnums ?? []) + enums
    }

    var inlineSchema: Schema? {
        switch type {
        case let .object(schema) where schema.additionalProperties == nil && !schema.properties.isEmpty:
            return self
        case let .array(arraySchema):
            switch arraySchema.items {
            case let .single(schema):
                return schema.inlineSchema
            case .multiple:
                break
            }
        case let .group(group):
            if group.discriminator != nil {
                return self
            } else if case .all = group.type, group.schemas.count > 1 {
                return self
            }
        default: break
        }
        return nil
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
        let paramEnums = parameters.compactMap { $0.value.enumValue }
        let bodyEnums = requestBody?.value.content.defaultSchema?.enums ?? []
        return paramEnums + bodyEnums
    }

    var responseEnums: [Enum] {
        return responses.compactMap { $0.enumValue }
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
        if let schema = additionalProperties {
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
            return "Status\(statusCode.description)"
        } else {
            return "DefaultResponse"
        }
    }

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return response.value.schema?.getEnum(name: name, description: response.value.description)
    }
}

extension Response {

    var schema: Schema? {
        return content?.defaultSchema
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
        case let .schema(schema): return schema.schema.getEnum(name: name, description: description)
        case let .content(content): return content.defaultSchema?.getEnum(name: name, description: description)
        }
    }

    var isEnum: Bool {
        return enumValue != nil
    }

    var enumValue: Enum? {
        return getEnum(name: name, description: description)
    }

    var schema: Schema? {
        switch type {
        case let .content(content): return content.defaultSchema
        case let .schema(schema): return schema.schema
        }
    }
}

extension Schema {

    var canBeEnum: Bool {
        switch type {
        case .string, .integer, .number:
            return true
        default: return false
        }
    }

    var isFile: Bool {
        switch type {
        case let .string(format):
            switch format.format {
            case let .format(format)?:
                switch format {
                case .binary: return true
                case .byte: return true
                default: return false
                }
            default: return false
            }
        default: return false
        }
    }
}

extension Content {

    var defaultSchema: Schema? {
        return getMediaItem(.json)?.schema ?? mediaItems.values.first?.schema
    }

    var containsFile: Bool {
        return mediaItems.values.contains { $0.schema.properties.contains { $0.schema.isFile } }
    }
}
