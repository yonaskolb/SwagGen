//
//  CodeFormatter.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import Swagger

public class CodeFormatter {

    let spec: SwaggerSpec

    public init(spec: SwaggerSpec) {
        self.spec = spec
    }

    var disallowedTypes: [String] {
        return []
    }

    public func getContext() -> [String: Any] {
        return cleanDictionary(getSpecContext())
    }

    func getSpecContext() -> [String: Any?] {
        var context: [String: Any?] = [:]

        context["operations"] = spec.operations.map(getOperationContext)
        context["tags"] = spec.opererationsByTag.map { ["name": $0, "operations": $1.map(getOperationContext)] }
        context["definitions"] = Array(spec.definitions.values).map(getSchemaContext)
        context["info"] = spec.info.flatMap(getSpecInfoContext)
        context["host"] = spec.host
        context["basePath"] = spec.basePath
        context["baseURL"] = "\(spec.schemes.first ?? "http")://\(spec.host ?? "")\(spec.basePath ?? "")"
        context["enums"] = spec.enums.map(getValueContext)

        return context
    }

    func getSpecInfoContext(info: SwaggerSpec.Info) -> [String: Any?] {
        var context: [String: Any?] = [:]

        context["title"] = info.title
        context["description"] = info.description
        context["version"] = info.version

        return context
    }

    func getEndpointContext(endpoint: Endpoint) -> [String: Any?] {
        return [
            "path": endpoint.path,
            "methods": Array(endpoint.methods.values).map(getOperationContext),
        ]
    }

    func getOperationContext(operation: Swagger.Operation) -> [String: Any?] {
        let successResponse = operation.responses.filter { $0.statusCode == 200 || $0.statusCode == 204 }.first
        var context: [String: Any?] = [:]

        context["operationId"] = operation.operationId
        context["method"] = operation.method.uppercased()
        context["path"] = operation.path
        context["description"] = operation.description
        context["tag"] = operation.tags.first
        context["tags"] = operation.tags
        context["params"] = operation.parameters.map(getParameterContext)
        context["hasBody"] = operation.parameters.filter{$0.parameterType == .body || $0.parameterType == .form}.count > 0
        context["nonBodyParams"] = operation.parameters.filter { $0.parameterType != .body}.map(getParameterContext)
        context["bodyParam"] = operation.getParameters(type: .body).map(getParameterContext).first
        context["pathParams"] = operation.getParameters(type: .path).map(getParameterContext)
        context["queryParams"] = operation.getParameters(type: .query).map(getParameterContext)
        context["formParams"] = operation.getParameters(type: .form).map(getParameterContext)
        context["headerParams"] = operation.getParameters(type: .header).map(getParameterContext)
        context["enums"] = operation.enums.map(getParameterContext)
        context["security"] = operation.security.map(getSecurityContext).first
        context["responses"] = operation.responses.map(getResponseContext)
        context["successResponse"] = successResponse.flatMap(getResponseContext)
        context["successType"] = successResponse?.schema?.object.flatMap(getModelName) ?? successResponse?.schema.flatMap(getValueType)

        return context
    }

    func getSecurityContext(security: OperationSecurity) -> [String: Any?] {
        return [
            "name": security.name,
            "scope": security.scopes.first,
            "scopes": security.scopes,
        ]
    }

    func getResponseContext(response: Response) -> [String: Any?] {
        return [
            "statusCode": response.statusCode,
            "schema": response.schema.flatMap(getValueContext),
            "description": response.description,
        ]
    }

    func getValueContext(value: Value) -> [String: Any?] {
        var context: [String: Any?] = [:]

        context["type"] = getValueType(value)
        context["rawType"] = value.type
        context["name"] = value.name
        context["formattedName"] = getValueName(value)
        context["value"] = value.name
        context["required"] = value.required
        context["optional"] = !value.required
        context["enumName"] = getEnumName(value)
        context["description"] = value.description
        let enums = value.enumValues ?? value.arrayValue?.enumValues
        context["enums"] = enums?.map { ["name": getEnumCaseName($0), "value": $0] }
        context["arrayType"] = value.arraySchema.flatMap(getModelName)
        context["dictionaryType"] = value.dictionarySchema.flatMap(getModelName)
        context["isArray"] = value.type == "array"
        context["isDictionary"] = value.type == "object" && (value.dictionarySchema != nil || value.dictionaryValue != nil)
        context["isGlobal"] = value.isGlobal
        return context
    }

    func getParameterContext(parameter: Parameter) -> [String: Any?] {
        var context = getValueContext(value: parameter)

        context["parameterType"] = parameter.parameterType?.rawValue

        return context
    }

    func getPropertyContext(property: Property) -> [String: Any?] {
        return getValueContext(value: property)
    }

    func getSchemaContext(schema: Schema) -> [String: Any?] {
        var context: [String: Any?] = [:]
        context["name"] = schema.name
        context["formattedName"] = getModelName(schema)
        context["parent"] = schema.parent.flatMap(getSchemaContext)
        context["description"] = schema.description
        context["requiredProperties"] = schema.requiredProperties.map(getPropertyContext)
        context["optionalProperties"] = schema.optionalProperties.map(getPropertyContext)
        context["properties"] = schema.properties.map(getPropertyContext)
        context["allProperties"] = schema.allProperties.map(getPropertyContext)
        context["enums"] = schema.enums.map(getValueContext)
        return context
    }

    func escapeModelType(_ name: String) -> String {
        return "_\(name)"
    }

    func escapeEnumType(_ name: String) -> String {
        return "_\(name)"
    }

    func getModelName(_ schema: Schema) -> String {
        let name = schema.name.upperCamelCased()
        return disallowedTypes.contains(name) ? escapeModelType(name) : name
    }

    func getValueName(_ value: Value) -> String {
        return value.name.lowerCamelCased()
    }

    func getValueType(_ value: Value) -> String {
        if let object = value.object {
            return getModelName(object)
        }
        if value.type == "unknown" {
            writeError("Couldn't calculate type")
        }
        return value.type
    }

    func getEnumName(_ value: Value) -> String {
        let name = (value.globalName ?? value.name).upperCamelCased()
        return disallowedTypes.contains(name) ? escapeEnumType(name) : name
    }

    func getEnumCaseName(_ name: String) -> String {
        return name.upperCamelCased()
    }
}

fileprivate func cleanDictionary(_ dictionary: [String: Any?]) -> [String: Any] {
    var clean: [String: Any] = [:]
    for (key, value) in dictionary {
        if let value = value {
            clean[key] = value
            if let dictionary = value as? [String: Any?] {
                clean[key] = cleanDictionary(dictionary)
            } else if let array = value as? [[String: Any?]] {
                clean[key] = array.map { cleanDictionary($0) }
            }
        }
    }
    return clean
}

func +(lhs: [String: Any?], rhs: [String: Any?]) -> [String: Any] {
    var combined = cleanDictionary(lhs)
    for (key, value) in rhs {
        if let value = value {
            combined[key] = value
        }
    }
    return combined
}

extension String {

    private func camelCased(seperator: String) -> String {
        return components(separatedBy: seperator).map { $0.mapFirstChar { $0.uppercased() } }.joined(separator: "")
    }

    private func mapFirstChar(transform: (String) -> String) -> String {
        guard !characters.isEmpty else { return self }

        let first = transform(String(characters.prefix(1)))
        let rest = String(characters.dropFirst())
        return first + rest
    }

    private func camelCased() -> String {
        return camelCased(seperator: " ")
            .camelCased(seperator: "_")
            .camelCased(seperator: "-")
    }

    func lowerCamelCased() -> String {

        let string = camelCased()

        if string == string.uppercased() {
            return string.lowercased()
        }

        return string.mapFirstChar { $0.lowercased() }
    }

    func upperCamelCased() -> String {
        return camelCased().mapFirstChar { $0.uppercased() }
    }
}
