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
        let type = super.getValueType(value)
        if value.enumValues != nil && value.name != "" {
           return getEnumName(value)
        }

        switch type.lowercased() {
        case "int", "integer", "int32", "int64": return "Int"
        case "string": return "String"
        case "number", "double": return "Double"
        case "date": return "Date"
        case "boolean": return "Bool"
        case "array":
            let items = value.items!
            return "[\(items.enumValues != nil ? getEnumName(value) : getValueType(items))]"
        default: return type
        }
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
        ]
    }

    override func getEnumCaseName(_ name:String)->String {
        return name.lowerCamelCased()
    }
}
