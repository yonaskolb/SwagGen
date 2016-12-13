//
//  SwiftCodegen.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation

class SwiftFormatter: CodeFormatter {

    override func getValueType(_ value:Value)->String {

        if value.enumValues != nil && value.name != "" {
           return getEnumName(value)
        }

        if let format = value.format {
            switch format.lowercased() {
                case "date-time": return "Date"
            default: break
            }
        }

        switch value.type.lowercased() {
        case "int", "integer", "int32", "int64": return "Int"
        case "string": return "String"
        case "number", "double": return "Double"
        case "date": return "Date"
        case "boolean": return "Bool"
        case "object":
            if let definition = value.dictionaryDefinition {
                return "[String: \(getModelName(definition))]"
            }
            else if let value = value.dictionaryValue {
                return "[String: \(getValueType(value))]"
            }
            else {
                return "[String: Any]"
            }
        case "array":
            if let definition = value.arrayDefinition {
                return "[\(getModelName(definition))]"
            }
            else {
                let arrayValue = value.arrayValue!
                return "[\(arrayValue.enumValues != nil ? getEnumName(value) : getValueType(arrayValue))]"
            }
        default: break
        }
        return super.getValueType(value)
    }

    override func getOperationContext(operation:Operation) -> [String:Any?] {
        return super.getOperationContext(operation: operation) + [
            "nonBodyParams":operation.parameters.filter{$0.parameterType != .body}.map(getParameterContext),
        ]
    }


    override func getValueContext(value:Value) -> [String:Any?] {
        var decodedValue = getValueName(value)
        if value.enumValues != nil {
            decodedValue += ".rawValue"
        }
        else if value.object != nil {
            decodedValue += ".decode()"
        }
        if !value.required {
            decodedValue = decodedValue.replacingOccurrences(of: ".", with: "?.")
        }
        return super.getValueContext(value: value) + [
            "decodedValue": decodedValue,
            "optionalType": getValueType(value) + (value.required ? "" : "?"),
        ]
    }

    override func getEnumCaseName(_ name:String)->String {
        return name.lowerCamelCased()
    }
}
