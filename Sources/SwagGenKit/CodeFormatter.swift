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

    var spec: SwaggerSpec

    public var schemaTypeErrors: [Schema] = []
    public var valueTypeErrors: [Value] = []

    public init(spec: SwaggerSpec) {
        self.spec = spec
    }

    var disallowedNames: [String] {
        return []
    }

    var disallowedTypes: [String] {
        return []
    }

    public func getContext() -> [String: Any] {
        schemaTypeErrors = []
        valueTypeErrors = []
        return getSpecContext().clean()
    }

    func getSpecContext() -> [String: Any?] {
        var context: [String: Any?] = [:]

        context["raw"] = spec.json
        context["operations"] = spec.operations.map(getOperationContext)
        context["tags"] = spec.opererationsByTag.map { ["name": $0, "operations": $1.map(getOperationContext)] }
        context["definitions"] = Array(spec.definitions.values).map(getSchemaContext)
        context["info"] = getSpecInfoContext(info: spec.info)
        context["host"] = spec.host
        context["basePath"] = spec.basePath
        context["baseURL"] = "\(spec.schemes.first ?? "http")://\(spec.host ?? "")\(spec.basePath ?? "")"
        context["enums"] = spec.enums.map(getValueContext)
        context["securityDefinitions"] = spec.securityDefinitions.map(getSecurityDefinitionContext)
        return context
    }

    func getSecurityDefinitionContext(name: String, securityDefinition: SecurityDefinition) -> [String: Any?] {
        var context: [String: Any?] = securityDefinition.jsonDictionary
        context["name"] = name
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
        var context: [String: Any?] = [:]
        context["path"] = endpoint.path
        context["methods"] = endpoint.operations.map(getOperationContext)
        return context
    }

    func getOperationContext(operation: Swagger.Operation) -> [String: Any?] {

        let successResponses = operation.responses.filter { $0.success }.map(getResponseContext)
        let failureResponses = operation.responses.filter { !$0.success }.map(getResponseContext)
        let defaultResponse = operation.responses.filter { $0.statusCode == nil}.first.map(getResponseContext)

        var context: [String: Any?] = [:]

        if let operationId = operation.operationId {
            context["operationId"] = operationId
        } else {
            let pathParts = operation.path.components(separatedBy: "/")
            var pathName = pathParts.map{$0.upperCamelCased()}.joined(separator: "")
            pathName = pathName.replacingOccurrences(of: "\\{(.*?)\\}", with: "By_$1", options: .regularExpression, range: nil)
            let generatedOperationId = operation.method.rawValue.lowercased() + pathName.upperCamelCased()
            context["operationId"] = generatedOperationId
        }

        context["raw"] = operation.json
        context["method"] = operation.method.rawValue.uppercased()
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
        context["securityRequirement"] = operation.securityRequirements.map(getSecurityRequirementContext).first
        context["securityRequirements"] = operation.securityRequirements.map(getSecurityRequirementContext)
        context["responses"] = operation.responses.map(getResponseContext)
        context["successResponse"] = successResponses.first
        context["defaultResponse"] = defaultResponse
        context["alwaysHasResponseType"] = operation.responses.map(getResponseContext).filter { $0["type"] != nil }.count == operation.responses.count

        let successTypes = successResponses.flatMap { $0["type"] as? String }
        let failureTypes = failureResponses.flatMap { $0["type"] as? String }

        if Set(successTypes).count == 1 {
            context["singleSuccessType"] = successTypes.first
        }
        if Set(failureTypes).count == 1 {
            context["singleFailureType"] = failureTypes.first
        }

        return context
    }

    func getSecurityRequirementContext(securityRequirement: SecurityRequirement) -> [String: Any?] {
        var context: [String: Any?] = [:]
        context["name"] = securityRequirement.name
        context["scope"] = securityRequirement.scopes.first
        context["scopes"] = securityRequirement.scopes
        return context
    }

    func getResponseContext(response: Response) -> [String: Any?] {
        var context: [String: Any?] = [:]
        context["statusCode"] = response.statusCode
        context["name"] = (response.success ? "success" : "failure") + (response.statusCode?.description ?? "Default")
        context["schema"] = response.schema.flatMap(getValueContext)
        context["description"] = response.description
        context["type"] = response.schema.flatMap(getValueType)
        context["success"] = response.success
        return context
    }

    func getValueContext(value: Value) -> [String: Any?] {
        var context: [String: Any?] = [:]

        context["raw"] = value.json
        context["type"] = getValueType(value)
        context["name"] = getValueName(value)
        context["value"] = value.name
        context["required"] = value.required
        context["optional"] = !value.required
        context["enumName"] = getEnumName(value)
        context["description"] = value.description
        context["enums"] = value.nestedEnumValues?.map { ["name": getEnumCaseName($0), "value": $0] }
        context["arrayType"] = value.arraySchema.flatMap(getSchemaType)
        context["dictionaryType"] = value.dictionarySchema.flatMap(getSchemaType)
        context["isArray"] = value.type == "array"
        context["isDictionary"] = value.type == "object" && (value.dictionarySchema != nil || value.dictionaryValue != nil)
        context["isGlobal"] = value.isGlobal
        if value.schema?.anonymous == true {
            context["anonymousSchema"] = value.schema.flatMap(getSchemaContext)
        }
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
        context["raw"] = schema.json
        context["type"] = getSchemaType(schema)
        context["parent"] = schema.parent.flatMap(getSchemaContext)
        context["description"] = schema.description
        context["requiredProperties"] = schema.requiredProperties.map(getPropertyContext)
        context["optionalProperties"] = schema.optionalProperties.map(getPropertyContext)
        context["properties"] = schema.properties.map(getPropertyContext)
        context["allProperties"] = schema.allProperties.map(getPropertyContext)
        context["enums"] = schema.enums.map(getValueContext)
        return context
    }

    func escapeString(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        let replacements: [String: String] = [
            ">=": "greaterThanOrEqualTo",
            "<=": "lessThanOrEqualTo",
            ">": "greaterThan",
            "<": "lessThan",
            "$": "dollar",
            ".": "dot",
            "%": "percent",
            "#": "hash",
            "@": "alpha",
            "&": "and",
        ]
        var escapedString = string
        for (symbol, replacement) in replacements {
            escapedString = escapedString.replacingOccurrences(of: symbol, with: replacement)
        }
        escapedString = String(String.UnicodeScalarView(escapedString.unicodeScalars.filter { allowedCharacters.contains($0) }))

        // prepend _ strings starting with numbers
        if let firstCharacter = escapedString.unicodeScalars.first,
            CharacterSet.decimalDigits.contains(firstCharacter) {
            escapedString = "_\(escapedString)"
        }

        if escapedString.isEmpty || escapedString == "_" {
            escapedString = "UNKNOWN"
        }
        return escapedString
    }

    func escapeName(_ name: String) -> String {
        let string = escapeString(name)
        return disallowedNames.contains(string) ? getEscapedName(string) : string
    }

    func escapeType(_ type: String) -> String {
        let string = escapeString(type)
        return disallowedTypes.contains(string) ? getEscapedType(string) : string
    }

    func getEscapedType(_ type: String) -> String {
        return "_\(type)"
    }

    func getEscapedName(_ name: String) -> String {
        return "_\(name)"
    }

    func getSchemaType(_ schema: Schema) -> String {
        guard let name = schema.name else {
            schemaTypeErrors.append(schema)
            return "UNKNOWN_TYPE"
        }
        let type = name.upperCamelCased()
        return escapeType(type)
    }

    func getValueName(_ value: Value) -> String {
        let name = value.name.lowerCamelCased()
        return escapeName(name)
    }

    func getValueType(_ value: Value) -> String {
        if let object = value.schema {
            return getSchemaType(object)
        }
        guard let type = value.type else {
            valueTypeErrors.append(value)
            return "UKNOWN_TYPE"
        }
        return type
    }

    func getEnumName(_ value: Value) -> String {
        let name = (value.globalName ?? value.name).upperCamelCased()
        return escapeType(name)
    }

    func getEnumCaseName(_ name: String) -> String {
        return escapeName(name.upperCamelCased())
    }
}
