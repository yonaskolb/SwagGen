//
//  SwiftCodegen.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation

class SwiftFormatter: CodeFormatter {

    override var disallowedTypes: [String] {
        return [
            "Type",
            "Class",
            "Struct",
            "Enum",
            "Protocol",
            "Set",
        ]
    }

    override func getValueType(_ value: Value) -> String {

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
        case "file": return "Data"
        case "object":
            if let definition = value.dictionaryDefinition {
                return "[String: \(getModelName(definition))]"
            } else if let value = value.dictionaryValue {
                return "[String: \(getValueType(value))]"
            } else {
                return "[String: Any]"
            }
        case "array":
            if let definition = value.arrayDefinition {
                return "[\(getModelName(definition))]"
            } else {
                let arrayValue = value.arrayValue!
                return "[\(arrayValue.enumValues != nil ? getEnumName(value) : getValueType(arrayValue))]"
            }
        default: break
        }
        return super.getValueType(value)
    }

    override func getOperationContext(operation: Operation) -> [String: Any?] {
        return super.getOperationContext(operation: operation) + [
            "nonBodyParams": operation.parameters.filter { $0.parameterType != .body }.map(getParameterContext),
        ]
    }

    override func getValueContext(value: Value) -> [String: Any?] {
        var encodedValue = getValueName(value)
        if value.enumValues != nil {
            encodedValue += ".rawValue"
        } else if value.object != nil {
            encodedValue += ".encode()"
        }
        if !value.required {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.")
        }
        return super.getValueContext(value: value) + [
            "encodedValue": encodedValue,
            "optionalType": getValueType(value) + (value.required ? "" : "?"),
        ]
    }

    override func escapeModelType(_ name: String) -> String {
        return "\(name)Type"
    }

    override func escapeEnumType(_ name: String) -> String {
        return "\(name)Enum"
    }

    override func getEnumCaseName(_ name: String) -> String {
        return name.lowerCamelCased()
    }
}
