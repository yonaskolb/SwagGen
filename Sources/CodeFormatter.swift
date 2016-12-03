//
//  CodeFormatter.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation

class CodeFormatter {

    let swaggerSpec:SwaggerSpec

    init(swaggerSpec:SwaggerSpec) {
        self.swaggerSpec = swaggerSpec
    }

    func getContext() -> [String:Any] {
        return cleanContext(getSpecContext())
    }

    func getSpecContext() -> [String:Any?] {
        return [
            "operations": swaggerSpec.operations.map(getOperationContext),
            "tags": swaggerSpec.opererationsByTag.map{["tag":$0, "operations": $1.map(getOperationContext)]},
            "definitions":Array(swaggerSpec.definitions.values).map(getDefinitionContext),
        ]
    }

    func getEndpointContext(endpoint:Endpoint) -> [String:Any?] {
        return [
            "path": endpoint.path,
            "methods":Array(endpoint.methods.values).map(getOperationContext)
        ]
    }

    func getOperationContext(operation:Operation) -> [String:Any?] {
        return [
            "operationId": operation.operationId,
            "method": operation.method.uppercased(),
            "path": operation.path,
            "tag": operation.tags.first,
            "params":operation.parameters.map(getParameterContext),
            "bodyParam":operation.parameters.filter{$0.parameterType == .body}.map(getParameterContext).first,
            "pathParams":operation.parameters.filter{$0.parameterType == .path}.map(getParameterContext),
            "queryParams":operation.parameters.filter{$0.parameterType == .query}.map(getParameterContext),
            "enums": operation.parameters.filter{$0.enumValues != nil}.map(getParameterContext),
            "security": operation.security.map(getSecurityContext).first,
        ]
    }

    func getSecurityContext(security:OperationSecurity) -> [String:Any?] {
        return [
            "name": security.name,
            "scope": security.scopes.first,
            "scopes": security.scopes,
        ]
    }

    func getValueContext(value:Value) -> [String:Any?] {
        return [
            "type": getValueType(value),
            "name": value.name,
            "formattedName": getValueName(value),
            "value": value.name,
            "required": value.required,
            "optional": !value.required,
            "enumName": getEnumName(value),
            "description": value.description,
            "enums": value.enumValues?.map{["name":getEnumCaseName($0), "value":$0]},
        ]
    }

    func getParameterContext(parameter:Parameter) -> [String:Any?] {
        return getValueContext(value: parameter) + [
            "parameterType": parameter.parameterType?.rawValue,
        ]
    }

    func getPropertyContext(property:Property) -> [String:Any?] {
        return getValueContext(value: property)
    }

    func getDefinitionContext(definition:Definition) -> [String:Any?] {
        return [
            "name": getModelName(definition),
            "parent": definition.parent.flatMap(getDefinitionContext),
            "description": definition.description,
            "requiredProperties": definition.requiredProperties.map(getPropertyContext),
            "optionalProperties": definition.optionalProperties.map(getPropertyContext),
            "properties": definition.properties.map(getPropertyContext),
            "enums": definition.properties.filter{$0.enumValues != nil}.map(getPropertyContext),
        ]
    }

    func getModelName(_ definition:Definition)->String {
        return definition.name.upperCamelCased()
    }

    func getValueName(_ value:Value)->String {
        return value.name.lowerCamelCased()
    }

    func getValueType(_ value:Value)->String {
        if let object = value.object {
            return getModelName(object)
        }
        return value.type
    }

    func getEnumName(_ value:Value)->String {
        return value.name.upperCamelCased()
    }

    func getEnumCaseName(_ name:String)->String {
        return name.upperCamelCased()
    }

}

fileprivate func cleanContext(_ dictionary:[String:Any?])-> [String:Any] {
    var clean:[String:Any] = [:]
    for (key, value) in dictionary {
        if let value = value {
            clean[key] = value
            if let dictionary = value as? [String:Any?] {
                clean[key] = cleanContext(dictionary)
            }
            else if let array = value as? [[String:Any?]] {
                clean[key] = array.map { cleanContext($0)}
            }
        }
    }
    return clean
}

func +(lhs:[String:Any?], rhs:[String:Any?]) -> [String: Any?] {
    var combined = lhs
    for (key, value) in rhs {
        combined[key] = value
    }
    return combined
}

extension String {

    private func camelCased(seperator:String)->String {
        return components(separatedBy: seperator).map{ $0.mapFirstChar{$0.uppercased()}}.joined(separator: "")
    }

    private func mapFirstChar(transform:(String)->String)->String {
        guard !characters.isEmpty else {return self}

        let first = transform(String(characters.prefix(1)))
        let rest = String(characters.dropFirst())
        return first + rest
    }


    private func camelCased()->String {
        return camelCased(seperator: " ")
            .camelCased(seperator: "_")
            .camelCased(seperator: "-")
    }

    func lowerCamelCased()->String {

        let string = camelCased()

        if string == string.uppercased() {
            return string.lowercased()
        }

        return string.mapFirstChar{$0.lowercased()}
    }

    func upperCamelCased()->String {
        return camelCased().mapFirstChar{$0.uppercased()}
    }
}
