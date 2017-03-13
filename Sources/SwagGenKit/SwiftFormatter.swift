//
//  SwiftCodegen.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import Swagger

public class SwiftFormatter: CodeFormatter {

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
        case "string":
            if value.format == "uri" {
                return "URL"
            }
            return "String"
        case "number", "double": return "Double"
        case "date": return "Date"
        case "boolean": return "Bool"
        case "file": return "URL"
        case "uri": return "URL"
        case "object":
            if let schema = value.dictionarySchema {
                return "[String: \(getModelName(schema))]"
            } else if let value = value.dictionaryValue {
                return "[String: \(getValueType(value))]"
            } else {
                return "[String: Any]"
            }
        case "array":
            if let schema = value.arraySchema {
                return "[\(getModelName(schema))]"
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

        let type = getValueType(value)
        let jsonTypes = ["Any", "[String: Any]", "Int", "String", "Float", "Double", "Bool"]

        if !jsonTypes.contains(type) && !jsonTypes.map({"[\($0)]"}).contains(type) && !jsonTypes.map({"[String: \($0)]"}).contains(type) {
            encodedValue += ".encode()"
        }

        if value.type == "array", let collectionFormatSeperator = value.collectionFormatSeperator {
            if type != "[String]" {
                encodedValue += ".map({ \"\\($0)\" })"
            }
            encodedValue += ".joined(separator: \"\(collectionFormatSeperator)\")"
        }

        if !value.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
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
