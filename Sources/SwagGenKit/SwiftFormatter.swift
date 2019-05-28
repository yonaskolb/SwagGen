import Foundation
import Swagger

public class SwiftFormatter: CodeFormatter {

    var disallowedKeywords: [String] {
        return [
            "Type",
            "Protocol",
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

    let fixedWidthIntegers: Bool

    public override init(spec: SwaggerSpec, templateConfig: TemplateConfig) {
        fixedWidthIntegers = templateConfig.getBooleanOption("fixedWidthIntegers") ?? false
        super.init(spec: spec, templateConfig: templateConfig)
    }

    override func getSchemaType(name: String, schema: Schema, checkEnum: Bool = true) -> String {

        var enumValue: String?
        if checkEnum {
            enumValue = schema.getEnum(name: name, description: "").flatMap { getEnumContext($0)["enumName"] as? String }
        }

        if schema.canBeEnum, let enumValue = enumValue {
            return enumValue
        }

        switch schema.type {
        case .boolean:
            return "Bool"
        case let .string(item):
            guard let format = item.format else {
                return "String"
            }
            switch format {
            case let .format(format):
                switch format {
                case .binary: return "File"
                case .byte: return "File"
                case .base64: return "String"
                case .dateTime: return "DateTime"
                case .date: return "DateDay"
                case .email, .hostname, .ipv4, .ipv6, .password: return "String"
                case .uri: return "URL"
                case .uuid: return "ID"
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
        case let .integer(item):
            guard let format = item.format else {
                return "Int"
            }

            if fixedWidthIntegers {
                switch format {
                case .int32: return "Int32"
                case .int64: return "Int64"
                }
            } else {
                return "Int"
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
            if let additionalProperties = schema.additionalProperties {
                let typeString = getSchemaType(name: name, schema: additionalProperties, checkEnum: checkEnum)
                return checkEnum ? "[String: \(enumValue ?? typeString)]" : typeString
            } else if schema.properties.isEmpty {
                return "[String: Any]"
            } else {
                return escapeType(name.upperCamelCased())
            }
        case let .reference(reference):
            return getSchemaTypeName(reference.component)
        case .group:
            return escapeType(name.upperCamelCased())
        case .any:
            return "Any"
        }
    }

    override func getSchemaContext(_ schema: Schema) -> Context {
        var context = super.getSchemaContext(schema)

        if let objectSchema = schema.type.object,
            let additionalProperties = objectSchema.additionalProperties {
            context["additionalPropertiesType"] = getSchemaType(name: "Anonymous", schema: additionalProperties)
        }

        return context
    }

    override func getParameterContext(_ parameter: Parameter) -> Context {
        var context = super.getParameterContext(parameter)

        let type = context["type"] as! String
        let name = context["name"] as! String

        context["optionalType"] = type + (parameter.required ? "" : "?")
        var encodedValue = getEncodedValue(name: getName(name), type: type)

        if case let .schema(schema) = parameter.type,
            case .array = schema.schema.type,
            let collectionFormat = schema.collectionFormat {
            if type != "[String]" {
                encodedValue += ".map({ String(describing: $0) })"
            }
            encodedValue += ".joined(separator: \"\(collectionFormat.separator)\")"
        }
        if !parameter.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
        }
        context["encodedValue"] = encodedValue
        context["isAnyType"] = type.contains("Any")
        return context
    }

    override func getRequestBodyContext(_ requestBody: PossibleReference<RequestBody>) -> Context {
        var context = super.getRequestBodyContext(requestBody)
        let type = context["type"] as! String
        context["optionalType"] = type + (requestBody.value.required ? "" : "?")
        return context
    }

    func getEncodedValue(name: String, type: String) -> String {
        var encodedValue = name

        let jsonTypes = ["Any", "[String: Any]", "Int", "String", "Float", "Double", "Bool"]

        if !jsonTypes.contains(type), !jsonTypes.map({ "[\($0)]" }).contains(type), !jsonTypes.map({ "[String: \($0)]" }).contains(type) {
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

        context["optionalType"] = type + (property.required && !property.schema.metadata.nullable ? "" : "?")
        var encodedValue = getEncodedValue(name: getName(name), type: type)

        if !property.required, let range = encodedValue.range(of: ".") {
            encodedValue = encodedValue.replacingOccurrences(of: ".", with: "?.", options: [], range: range)
        }

        context["encodedValue"] = encodedValue
        context["isAnyType"] = type.contains("Any")
        return context
    }

    override func getResponseContext(_ response: OperationResponse) -> Context {
        var context = super.getResponseContext(response)
        let type = context["type"] as? String ?? ""
        context["isAnyType"] = type.contains("Any")
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
