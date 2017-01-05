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

    override func getValueContext(value: Value) -> [String: Any?] {
        var encodedValue = getValueName(value)
        if value.type == "array" {
            if let value = value.arrayValue, let path = getEncodedValuePath(value: value) {
                encodedValue += ".map({ $0\(path) })"
            }
        }
        if let path = getEncodedValuePath(value: value) {
            encodedValue += path
        }

        if !value.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
        }
        return super.getValueContext(value: value) + [
            "encodedValue": encodedValue,
            "optionalType": getValueType(value) + (value.required ? "" : "?"),
        ]
    }

    func getEncodedValuePath(value: Value) -> String? {
        if value.enumValues != nil {
            return ".rawValue"
        } else if value.object != nil {
            return ".encode()"
        }
        return nil
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
