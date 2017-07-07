//
//  SwiftCodegen.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import SwaggerParser

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

    override func getItemType(name: String, item: Items) -> String {

        let enumValue = item.metadata.getEnum(name: name, description: "").flatMap { getEnumContext($0)["enumName"] as? String }

        switch item {
        case let .array(item): return "[\(enumValue ?? getItemType(name: name, item: item.items))]"
        case .boolean: return "Bool"
        case let .integer(item): return enumValue ?? "Int"
        case let .number(item): return enumValue ?? getNumberFormatType(item.format)
        case let .string(item): return enumValue ?? getStringFormatType(item.format)
        }
    }

    func getNumberFormatType(_ format: NumberFormat?) -> String {
        guard let format = format else {
            return "Double"
        }
        switch format {
        case .double: return "Double"
        case .float: return "Float"
        }
    }

    func getStringFormatType(_ format: StringFormat?) -> String {
        guard let format = format else {
            return "String"
        }
        switch format {
        case .binary, .byte: return "String" // TODO: Data
        case .dateTime, .date: return "Date"
        case .email, .hostname, .ipv4, .ipv6, .password: return "String"
        case .other: return "String"
        case .uri: return "URL"
        }
    }

    override func getSchemaType(name: String, schema: Schema) -> String {

        let enumValue = schema.getEnum(name: name, description: "").flatMap { getEnumContext($0)["enumName"] as? String }

        switch schema {
        case let .string(_, format): return enumValue ?? getStringFormatType(format)
        case let .number(_, format): return getNumberFormatType(format)
        case .integer: return "Int"
        case let .array(arraySchema):
            switch arraySchema.items {
            case let .one(type): return "[\(enumValue ?? getSchemaType(name: name, schema: type))]"
            case let .many(types): return "[\(enumValue ?? getSchemaType(name: name, schema: types.first!))]"
            }
        case .boolean: return "Bool"
        case let .enumeration(metadata): return metadata.title ?? "UKNOWN_ENUM"
        case .file: return "URL"
        case let .object(schema):
            switch schema.additionalProperties {
            case let .a(bool): return "[String: Any]"
            case let .b(schema): return "[String: \(enumValue ?? getSchemaType(name: name, schema: schema))]"
            }
        case let .structure(_, structure): return escapeType(structure.name.upperCamelCased())
        case .allOf: return "UKNOWN_ALL_OFF"
        case .any: return "UKNOWN_ANY"
        case .resolvingReference: fatalError()
        }
    }

    override func getParameterContext(_ parameter: ParameterFormatter) -> Context {
        var context = super.getParameterContext(parameter)

        let type = context["type"] as! String
        let name = context["name"] as! String

        context["optionalType"] = type + (parameter.parameter.fields.required ? "" : "?")
        var encodedValue = getEncodedValue(name: getName(name), type: type)

        if case let .other(_, items) = parameter.parameter,
            case let .array(item) = items {
            if type != "[String]" {
                encodedValue += ".map { String(describing: $0) }"
            }
            encodedValue += ".joined(separator: \"\(item.collectionFormat.separator)\")"
        }
        if !parameter.parameter.fields.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
        }
        context["encodedValue"] = encodedValue
        return context
    }

    func getEncodedValue(name: String, type: String) -> String {
        var encodedValue = name

        let jsonTypes = ["Any", "[String: Any]", "Int", "String", "Float", "Double", "Bool"]

        if !jsonTypes.contains(type) && !jsonTypes.map({ "[\($0)]" }).contains(type) && !jsonTypes.map({ "[String: \($0)]" }).contains(type) {
            encodedValue += ".encode()"
        }

        return encodedValue
    }

    override func getPropertyContext(_ property: PropertyFormatter) -> Context {
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
