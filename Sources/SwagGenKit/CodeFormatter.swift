//
//  CodeFormatter.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import SwaggerParser

typealias Context = [String: Any?]

public class CodeFormatter {

    var spec: Swagger

    var filenames: [String] = []

    public var schemaTypeErrors: [Schema] = []

    var enums: [Enum] = []

    public init(spec: Swagger) {
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
        return getSpecContext().clean()
    }

    func getSpecContext() -> Context {
        var context: Context = [:]
        //context["raw"] = spec.json
        enums = spec.enums
        context["enums"] = enums.map(getEnumContext)
        context["operations"] = spec.operationFormatters.map(getOperationContext)
        context["tags"] = spec.operationsByTag.map { ["name": $0, "operations": $1.map(getOperationContext)] }
        context["definitions"] = spec.definitions.map(getDefinitionContext)
        context["info"] = getSpecInformationContext(spec.information)
        context["host"] = spec.host
        context["basePath"] = spec.basePath
        let scheme = (spec.schemes?.first?.rawValue).flatMap { "\($0)://" } ?? "http://"
        context["baseURL"] = "\(scheme)\(spec.host?.absoluteString ?? "")\(spec.basePath ?? "")"

        context["securityDefinitions"] = spec.securityDefinitions.map(getSecurityDefinitionContext)
        return context
    }

    func getSecurityDefinitionContext(name: String, securityDefinition: SecuritySchema) -> Context {
        var context: Context = [:]//securityDefinition.jsonDictionary
        context["name"] = name
        //TODO: fill out
        return context
    }

    func getSpecInformationContext(_ info: Information) -> Context {
        var context: Context = [:]

        context["title"] = info.title.description
        context["description"] = info.description
        context["version"] = info.version

        return context
    }

    func getDefinitionContext(_ schema: Structure<Schema>) -> Context {
        var context: Context = getSchemaContext(schema.structure)
        context["filename"] = getFilename(schema.name)
        context["type"] = getSchemaType(schema)

        return context
    }

    func getSchemaContext(_ schema: Schema) -> Context {
        var context: Context = [:]

        if let parent = schema.parent {
            context["parent"] = getDefinitionContext(parent)
        }

        context["description"] = schema.metadata.description

        context["requiredProperties"] = schema.requiredProperties.map(getPropertyContext)
        context["optionalProperties"] = schema.optionalProperties.map(getPropertyContext)
        context["properties"] = schema.properties.map(getPropertyContext)
        context["allProperties"] = schema.parentProperties.map(getPropertyContext)

        context["enums"] = schema.enums.map(getEnumContext)

        //TODO: context["isGlobal"] = value.isGlobal
        //TODO: if value.schema?.anonymous == true {
        //       context["anonymousSchema"] = value.schema.flatMap(getSchemaContext)
        //    }
        return context
    }

//    func getEndpointContext(endpoint: Endpoint) -> Context {
//        var context: Context = [:]
//        context["path"] = endpoint.path
//        context["methods"] = endpoint.operations.map(getOperationContext)
//        return context
//    }

    func getOperationContext(operation: OperationFormatter) -> Context {
        let successResponse = operation.responses.filter { $0.successful }.first

        var responses = operation.responses.map(getResponseContext)
        let successResponses = operation.responses.filter { $0.successful }.map(getResponseContext)
        var failureResponses = operation.responses.filter { !$0.successful }.map(getResponseContext)
        let defaultResponse = operation.defaultResponse.flatMap(getResponseContext)
        if let defaultResponse = defaultResponse {
            responses.append(defaultResponse)
            failureResponses.append(defaultResponse)
        }

        var context: Context = [:]

        if let operationId = operation.operation.operationId {
            context["operationId"] = operationId
            context["filename"] = getFilename(operationId)
        } else {
            let pathParts = operation.path.components(separatedBy: "/")
            var pathName = pathParts.map{$0.upperCamelCased()}.joined(separator: "")
            pathName = pathName.replacingOccurrences(of: "\\{(.*?)\\}", with: "By_$1", options: .regularExpression, range: nil)
            let generatedOperationId = operation.method.rawValue.lowercased() + pathName.upperCamelCased()
            context["operationId"] = generatedOperationId
            context["filename"] = getFilename(generatedOperationId)
        }

        //context["raw"] = operation.json
        context["method"] = operation.method.rawValue.uppercased()
        context["path"] = operation.path
        context["description"] = operation.operation.description
        context["tag"] = operation.operation.tags?.first
        context["tags"] = operation.operation.tags
        context["params"] = operation.parameters.map(getParameterContext)
        context["hasBody"] = operation.parameters.contains { $0.parameter.fields.location == .body || $0.parameter.fields.location == .formData }
        context["nonBodyParams"] = operation.parameters.filter { $0.parameter.fields.location != .body}.map(getParameterContext)
        context["encodedParams"] = operation.parameters.filter { $0.parameter.fields.location == .formData || $0.parameter.fields.location == .query}.map(getParameterContext)
        context["bodyParam"] = operation.getParameters(type: .body).first.flatMap(getParameterContext)
        context["pathParams"] = operation.getParameters(type: .path).map(getParameterContext)
        context["queryParams"] = operation.getParameters(type: .query).map(getParameterContext)
        context["formParams"] = operation.getParameters(type: .formData).map(getParameterContext)
        context["hasFileParam"] = operation.parameters.contains { $0.parameter.metadata.type == .file }
        context["headerParams"] = operation.getParameters(type: .header).map(getParameterContext)
        context["enums"] = operation.enums.map(getEnumContext)
        context["securityRequirement"] = operation.operation.security?.first.flatMap(getSecurityRequirementContext)
        context["securityRequirements"] = operation.operation.security?.map(getSecurityRequirementContext)
        context["responses"] = responses
        context["successResponse"] = successResponses.first
        context["defaultResponse"] = defaultResponse
        context["successType"] = successResponse?.response.schema.flatMap { getSchemaType(name: "UNKNOWN_NAME", schema: $0) }
        context["alwaysHasResponseType"] = responses.filter { $0["type"] != nil }.count == responses.count

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

    func getResponseContext(response: ResponseFormatter) -> Context {
        var context: Context = [:]
        context["statusCode"] = response.statusCode
        context["name"] = (response.successful ? "success" : "failure") + (response.statusCode?.description ?? "Default")
        context["schema"] = response.response.schema.flatMap(getSchemaContext)
        context["description"] = response.response.description
        context["type"] = response.response.schema.flatMap { getSchemaType(name: "UNKNOWN_NAME", schema: $0) }
        context["success"] = response.successful
        return context
    }

    func getSecurityRequirementContext(_ securityRequirement: SecurityRequirement) -> Context {
        var context: Context = [:]
        context["name"] = securityRequirement.name
        context["scope"] = securityRequirement.scopes.first
        context["scopes"] = securityRequirement.scopes
        return context
    }

    func getParameterContext(_ parameter: ParameterFormatter) -> Context {
        var context: Context = [:]

        context["raw"] = [
            "name": parameter.parameter.fields.name,
            "type": parameter.parameter.metadata.type.rawValue,
        ]

        context["name"] = getName(parameter.parameter.fields.name)
        context["value"] = parameter.parameter.fields.name
        context["example"] = parameter.parameter.fields.example
        context["required"] = parameter.parameter.fields.required
        context["optional"] = !parameter.parameter.fields.required
        context["parameterType"] = parameter.parameter.fields.location.rawValue
        context["isFile"] = parameter.parameter.metadata.type == .file
        context["description"] = parameter.parameter.fields.description

        switch parameter.parameter {
        case .body(_, let schema): context["type"] = getSchemaType(name: parameter.name ?? parameter.parameter.fields.name, schema: schema)
        case .other(_, let item): context["type"] = getItemType(name: parameter.name ?? parameter.parameter.fields.name, item: item)
        }

        return context
    }

    func getPropertyContext(_ property: PropertyFormatter) -> Context {
        var context: Context = getSchemaContext(property.schema)

        context["raw"] = [
            "name": property.name,
            "type": property.schema.metadata.type.rawValue,
        ]

        context["required"] = property.required
        context["optional"] = !property.required
        context["name"] = getName(property.name)
        context["value"] = property.name
        context["type"] = getSchemaType(name: property.name, schema: property.schema)

        return context
    }

    func getEnumContext(_ enumFormatter: Enum) -> Context {
        var context: Context = [:]

        var specEnum: Enum?
        for globalEnum in self.enums {
            if String(describing: globalEnum.cases) == String(describing: enumFormatter.cases) {
                specEnum = globalEnum
                break
            }
        }
        context["enumName"] = getEnumTypeType(enumFormatter.name)

        if let specEnum = specEnum {
            context["enumName"] = getEnumTypeType(specEnum.name)
            context["isGlobal"] = true
        }
        context["enums"] = enumFormatter.cases.map { ["name": getName("\($0)"), "value": $0] }
        context["description"] = specEnum?.description ?? enumFormatter.description
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

    func getItemType(name: String, item: Items) -> String {
        return "UNKNOWN_TYPE"
    }

    func getEnumTypeType(_ name: String) -> String {
        return escapeType(name.upperCamelCased())
    }

    func getName(_ name: String) -> String {
        let name = name.lowerCamelCased()
        return escapeName(name)
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

    func getFilename(_ name: String) -> String {
        let filename = escapeString(name.upperCamelCased())
//        if filenames.contains(filename) {
//            filename += "2"
//        }
        filenames.append(filename)
        return filename
    }

    func getSchemaType(_ schema: Structure<Schema>) -> String {
        let type = schema.name.upperCamelCased()
        return escapeType(type)
    }

    func getSchemaType(name: String, schema: Schema) -> String {
        return "UKNOWN_TYPE"
    }

}
