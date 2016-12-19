//
//  CodeFormatter.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation

class CodeFormatter {

    let spec: SwaggerSpec

    init(spec: SwaggerSpec) {
        self.spec = spec
    }

    var disallowedTypes: [String] {
        return []
    }

    func getContext() -> [String: Any] {
        return cleanContext(getSpecContext())
    }

    func getSpecContext() -> [String: Any?] {
        return [
            "operations": spec.operations.map(getOperationContext),
            "tags": spec.opererationsByTag.map { ["name": $0, "operations": $1.map(getOperationContext)] },
            "definitions": Array(spec.definitions.values).map(getDefinitionContext),
            "info": geSpecInfoContext(info: spec.info),
        ]
    }

    func geSpecInfoContext(info: SwaggerSpec.Info) -> [String: Any?] {
        return [
            "title": info.title,
            "description": info.description,
            "version": info.version,
        ]
    }

    func getEndpointContext(endpoint: Endpoint) -> [String: Any?] {
        return [
            "path": endpoint.path,
            "methods": Array(endpoint.methods.values).map(getOperationContext),
        ]
    }

        return [
            "operationId": operation.operationId,
            "method": operation.method.uppercased(),
            "path": operation.path,
            "tag": operation.tags.first,
            "params":operation.parameters.map(getParameterContext),
            "hasBody": operation.getParameters(type: .body).count > 0 || operation.getParameters(type: .form).count > 0,
            "bodyParam":operation.getParameters(type: .body).map(getParameterContext).first,
            "pathParams":operation.getParameters(type: .path).map(getParameterContext),
            "queryParams":operation.getParameters(type: .query).map(getParameterContext),
            "enums": operation.enums.map(getValueContext),
            "security": operation.security.map(getSecurityContext).first,
            "responses": operation.responses.map(getResponseContext),
            "successResponse": successResponse.flatMap(getResponseContext),
            "successType": successResponse?.schema?.object.flatMap(getModelName) ?? successResponse?.schema.flatMap(getValueType),
        ]
    func getOperationContext(operation: Operation) -> [String: Any?] {
        let successResponse = operation.responses.filter { $0.statusCode == 200 || $0.statusCode == 204 }.first
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

        return [
            "type": getValueType(value),
            "rawType": value.type,
            "name": value.name,
            "formattedName": getValueName(value),
            "value": value.name,
            "required": value.required,
            "optional": !value.required,
            "enumName": getEnumName(value),
            "description": value.description,
            "enums": (value.enumValues ?? value.arrayValue?.enumValues)?.map{["name":getEnumCaseName($0), "value":$0]},
            "arrayType": value.arrayDefinition.flatMap(getModelName),
            "dictionaryType": value.dictionaryDefinition.flatMap(getModelName),
            "isArray": value.type == "array",
            "isDictionary": value.type == "object" && (value.dictionaryDefinition != nil || value.dictionaryValue != nil),
        ]
    }
    func getValueContext(value: Value) -> [String: Any?] {
    func getParameterContext(parameter: Parameter) -> [String: Any?] {
        return getValueContext(value: parameter) + [
            "parameterType": parameter.parameterType?.rawValue,
        ]
    }

    func getPropertyContext(property: Property) -> [String: Any?] {
        return getValueContext(value: property)
    }

        return [
            "name": definition.name,
            "formattedName": getModelName(definition),
            "parent": definition.parent.flatMap(getDefinitionContext),
            "description": definition.description,
            "requiredProperties": definition.requiredProperties.map(getPropertyContext),
            "optionalProperties": definition.optionalProperties.map(getPropertyContext),
            "properties": definition.properties.map(getPropertyContext),
            "allProperties": definition.allProperties.map(getPropertyContext),
            "enums": definition.enums.map(getValueContext),
        ]
    func getDefinitionContext(definition: Definition) -> [String: Any?] {
    }

    func escapeTypeName(_ name: String) -> String {
        return "_\(name)"
    }

    func escapedTypeName(_ name: String) -> String {
        return disallowedTypes.contains(name) ? escapeTypeName(name) : name
    }

    func getModelName(_ definition: Definition) -> String {
        let name = definition.name.upperCamelCased()
        return escapedTypeName(name)
    }

    func getValueName(_ value: Value) -> String {
        return value.name.lowerCamelCased()
    }

    func getValueType(_ value: Value) -> String {
        if let object = value.object {
            return getModelName(object)
        }
        return value.type
    }

    func getEnumName(_ value: Value) -> String {
        return escapedTypeName(value.name.upperCamelCased())
    }

    func getEnumCaseName(_ name: String) -> String {
        return name.upperCamelCased()
    }
}

fileprivate func cleanContext(_ dictionary: [String: Any?]) -> [String: Any] {
    var clean: [String: Any] = [:]
    for (key, value) in dictionary {
        if let value = value {
            clean[key] = value
            if let dictionary = value as? [String: Any?] {
                clean[key] = cleanContext(dictionary)
            } else if let array = value as? [[String: Any?]] {
                clean[key] = array.map { cleanContext($0) }
            }
        }
    }
    return clean
}

func +(lhs: [String: Any?], rhs: [String: Any?]) -> [String: Any?] {
    var combined = lhs
    for (key, value) in rhs {
        combined[key] = value
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
