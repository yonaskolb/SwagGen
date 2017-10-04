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

    var disallowedKeywords: [String] {
        return [
            "Type",
            "class",
            "struct",
            "enum",
            "protocol",
            "extension",
            "return",
            "throw",
            "throws",
            "rethrows",
            "public",
            "open",
            "private",
            "fileprivate",
            "internal",
            "let",
            "var",
            "where",
            "guard",
            "associatedtype",
            "deinit",
            "func",
            "import",
            "inout",
            "operator",
            "static",
            "subscript",
            "typealias",
            "case",
            "break",
            "continue",
            "default",
            "defer",
            "do",
            "else",
            "fallthrough",
            "for",
            "if",
            "in",
            "repeat",
            "switch",
            "where",
            "while",
            "as",
            "Any",
            "AnyObject",
            "catch",
            "false",
            "true",
            "is",
            "nil",
            "super",
            "self",
            "Self",
        ]
    }

    var inbuiltTypes: [String] = [
        "Error",
        "Data",
        ]

    override var disallowedNames: [String] { return disallowedKeywords + inbuiltTypes }
    override var disallowedTypes: [String] { return disallowedKeywords + inbuiltTypes }

    override func getItemType(name: String, item: Item, checkEnum: Bool = true) -> String {

        var enumValue: String?
        if checkEnum {
            enumValue = item.metadata.getEnum(name: name, type: .item(item), description: "").flatMap { getEnumContext($0)["enumName"] as? String }
        }
        //TODO: support nonstring enums

        switch item.type {
        case let .array(item):
            let type = getItemType(name: name, item: item.items, checkEnum: checkEnum)
            return checkEnum ? "[\(enumValue ?? type )]" : type
        case let .simpleType(simpleType):
            if simpleType.canBeEnum, let enumValue = enumValue {
                return enumValue
            } else {
                return getSimpleType(simpleType)
            }
        }
    }

    func getSimpleType(_ simpleType: SimpleType) -> String {
        switch simpleType {
        case let .string(item):
            guard let format = item.format else {
                return "String"
            }
            switch format {
            case let .format(format):
                switch format {
                case .binary, .byte: return "String" // TODO: Data
                case .dateTime, .date: return "Date"
                case .email, .hostname, .ipv4, .ipv6, .password: return "String"
                case .uri: return "URL"
                }
            case .other: return "String"
            }
        case let .number(item):
            guard let format = item.format else {
                return "Double"
            }
            switch format {
            case .double: return "Double"
            case .float: return "Float"
            }
        case .integer:
            return "Int"
        case .boolean:
            return "Bool"
        case .file: return "URL"
        }
    }

    override func getSchemaType(name: String, schema: Schema, checkEnum: Bool = true) -> String {
        var enumValue: String?
        if checkEnum {
            enumValue = schema.getEnum(name: name, description: "").flatMap { getEnumContext($0)["enumName"] as? String }
        }

        switch schema.type {
        case let .simple(simpleType):
            if simpleType.canBeEnum, let enumValue = enumValue {
                return enumValue
            } else {
                return getSimpleType(simpleType)
            }
        case let .array(arraySchema):
            switch arraySchema.items {
            case let .single(type):
                let typeString = getSchemaType(name: name, schema: type, checkEnum: checkEnum)
                return checkEnum ? "[\(enumValue ?? typeString)]" : typeString
            case let .multiple(types):
                let typeString = getSchemaType(name: name, schema: types.first!, checkEnum: checkEnum)
                return checkEnum ? "[\(enumValue ?? typeString)]" : typeString
            }
        case let .object(schema):
//            if schema.properties.isEmpty {
                switch schema.additionalProperties {
                case .bool: return "[String: Any]"
                case let .schema(schema):
                    let typeString = getSchemaType(name: name, schema: schema, checkEnum: checkEnum)
                    return checkEnum ? "[String: \(enumValue ?? typeString)]" : typeString
                }
//            } else {
//                return getModelType(name)
//            }
        case let .reference(reference): return escapeType(reference.name.upperCamelCased())
        case .allOf: return "UNKNOWN_ALL_OFF"
        case .any: return "UNKNOWN_ANY"
        }
    }

    override func getSchemaContext(_ schema: Schema) -> Context {
        var context = super.getSchemaContext(schema)

        if case let .object(objectSchema) = schema.type {

            switch objectSchema.additionalProperties {
            case let .bool(bool):
                if bool {
                    context["additionalPropertiesType"] = "Any"
                }
            case let .schema(schema):
                context["additionalPropertiesType"] = getSchemaType(name: "Anonymous", schema: schema)
            }
        }

        return context
    }

    override func getParameterContext(_ parameter: Parameter) -> Context {
        var context = super.getParameterContext(parameter)

        let type = context["type"] as! String
        let name = context["name"] as! String

        context["optionalType"] = type + (parameter.required ? "" : "?")
        var encodedValue = getEncodedValue(name: getName(name), type: type)

        if case let .other(items) = parameter.type,
            case let .array(item) = items.type {
            if type != "[String]" {
                encodedValue += ".map({ String(describing: $0) })"
            }
            encodedValue += ".joined(separator: \"\(item.collectionFormat.separator)\")"
        }
        if !parameter.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
        }
        context["encodedValue"] = encodedValue
        return context
    }

    func getEncodedValue(name: String, type: String) -> String {
        var encodedValue = name

        let jsonTypes = ["Any", "[String: Any]", "Int", "String", "Float", "Double", "Bool"]

        if !jsonTypes.contains(type) && !jsonTypes.map({ "[\($0)]" }).contains(type) && !jsonTypes.map({ "[String: \($0)]" }).contains(type) {
            if type.hasPrefix("[[") {
                encodedValue += ".map({ $0.encode() })"
            } else if type.hasPrefix("[String: [") {
                encodedValue += ".mapValues({ $0.encode() })"
            } else {
                encodedValue += ".encode()"
            }
        }

        return encodedValue
    }

    override func getPropertyContext(_ property: Property) -> Context {
        var context = super.getPropertyContext(property)

        let type = context["type"] as! String
        let name = context["name"] as! String

        context["optionalType"] = type + (property.required ? "" : "?")
        var encodedValue = getEncodedValue(name: getName(name), type: type)

        if !property.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
        }

        context["encodedValue"] = encodedValue

        return context
    }

    override func getEscapedType(_ name: String) -> String {
        if inbuiltTypes.contains(name) {
            return "\(name)Type"
        }
        return "`\(name)`"
    }
    
    override func getEscapedName(_ name: String) -> String {
        return "`\(name)`"
    }
}
