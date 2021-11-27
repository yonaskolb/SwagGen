import Foundation
import Swagger

typealias Context = [String: Any?]

public class CodeFormatter {

    var spec: SwaggerSpec
    var filenames: [String] = []
    var enums: [Enum] = []
    let templateConfig: TemplateConfig
    var modelPrefix: String
    var modelSuffix: String
    var modelInheritance: Bool
    var modelNames: [String: String]
    var enumNames: [String: String]
    var propertyNames: [String: String]

    public init(spec: SwaggerSpec, templateConfig: TemplateConfig) {
        self.spec = spec
        self.templateConfig = templateConfig
        modelPrefix = templateConfig.getStringOption("modelPrefix") ?? ""
        modelSuffix = templateConfig.getStringOption("modelSuffix") ?? ""
        modelInheritance = templateConfig.getBooleanOption("modelInheritance") ?? true
        modelNames = templateConfig.options["modelNames"] as? [String: String] ?? [:]
        enumNames = templateConfig.options["enumNames"] as? [String: String] ?? [:]
        propertyNames = templateConfig.options["propertyNames"] as? [String: String] ?? [:]
    }

    var disallowedNames: [String] {
        return []
    }

    var disallowedTypes: [String] {
        return []
    }

    public func getContext() -> [String: Any] {
        return getSpecContext().clean()
    }

    func getSpecContext() -> Context {
        var context: Context = [:]

        context["raw"] = spec.json
        enums = spec.enums
        context["enums"] = enums.map(getEnumContext)
        context["paths"] = spec.paths.map(getPathContext)
        context["operations"] = spec.operations.map(getOperationContext)
        context["tags"] = spec.tags
        context["operationsByTag"] = spec.operationsByTag
            .map { ($0, $1) }
            .sorted { $0.0.lowercased() < $1.0.lowercased() }
            .map { ["name": $0, "operations": $1.map(getOperationContext)] }
        context["schemas"] = spec.components.schemas.map(getSchemaContent).sorted { sortContext(by: "type", value1: $0, value2: $1) }
        context["info"] = getSpecInformationContext(spec.info)
        context["servers"] = spec.servers.enumerated().map(getServerContext)
        if let server = spec.servers.first, server.variables.isEmpty {
            context["defaultServer"] = getServerContext(index: 0, server: server)
        }
        context["securityDefinitions"] = spec.components.securitySchemes.map(getSecuritySchemeContext)

        return context
    }

    private func sortContext(by: String, value1: [String: Any?], value2: [String: Any?]) -> Bool {
        return (value1[by] as? String ?? "") < (value2[by] as? String ?? "")
    }

    func getServerContext(index: Int, server: Server) -> Context {
        var context: Context = [:]
        let defaultName = index == 0 ? "main" : "server\(index + 1)"
        context["name"] = getName(server.name?.lowercased() ?? defaultName)
        context["url"] = server.url
        context["description"] = server.description
        context["variables"] = server.variables.sorted { $0.key < $1.key }.map { name, variable -> Context in
            var context: Context = [:]
            context["name"] = name
            context["enum"] = variable.enumValues
            context["defaultValue"] = variable.defaultValue
            context["description"] = variable.description
            return context
        }

        return context
    }

    func getSecuritySchemeContext(_ securityScheme: ComponentObject<SecurityScheme>) -> Context {
        var context: Context = [:]

        context["name"] = securityScheme.name
        context["raw"] = securityScheme.value.json

        return context
    }

    func getSpecInformationContext(_ info: Info) -> Context {
        var context: Context = [:]

        context["title"] = info.title.description
        context["description"] = info.description
        context["version"] = info.version

        return context
    }

    func getSchemaContent(_ schema: ComponentObject<Schema>) -> Context {
        var context = getSchemaContext(schema.value)

        context["type"] = getSchemaTypeName(schema)

        let schemaType = getSchemaType(name: schema.name, schema: schema.value)

        switch schema.value.type {
        case .string, .boolean, .integer, .number:
            context["simpleType"] = schemaType
            context["aliasType"] = schemaType
            if let enumValue = schema.value.getEnum(name: schema.name, description: schema.value.metadata.description) {
                context["enum"] = getEnumContext(enumValue)
            }
        case .reference:
            context["referenceType"] = schemaType
            context["aliasType"] = schemaType
        case .array:
            context["arrayType"] = schemaType
            context["aliasType"] = schemaType
        default: break
        }

        return context
    }

    func getSchemaTypeName(_ schema: ComponentObject<Schema>) -> String {
        if schema.value.canBeEnum,
            schema.value.getEnum(name: schema.name, description: schema.value.metadata.description) != nil {
            return getEnumType(schema.name)
        } else {
            return getModelType(schema.name)
        }
    }

    func getInlineSchemaContext(_ schema: Schema, name: String) -> Context? {
        guard let schema = schema.inlineSchema else { return nil }

        var context: Context = getSchemaContext(schema)
        context["type"] = escapeType(name.upperCamelCased())

        return context
    }

    func getSchemaContext(_ schema: Schema) -> Context {
        var context: Context = [:]

        context["raw"] = schema.metadata.json

        if modelInheritance, let parent = schema.parent {
            context["parent"] = getSchemaContent(parent)
        } else {
            context["parent"] = false
        }

        context["description"] = schema.metadata.description
        context["default"] = schema.metadata.defaultValue
        context["example"] = schema.metadata.example
        context["isFile"] = schema.isFile

        if modelInheritance {
            let requiredPropertiesContext = schema.requiredProperties.map(getPropertyContext)
            let optionalPropertiesContext = schema.optionalProperties.map(getPropertyContext)
            context["requiredProperties"] = requiredPropertiesContext
            context["optionalProperties"] = optionalPropertiesContext
            context["properties"] = requiredPropertiesContext + optionalPropertiesContext
            context["enums"] = schema.enums.map(getEnumContext)
            context["schemas"] = schema.properties.compactMap { property in
                getInlineSchemaContext(property.schema, name: property.name)
            }
        } else {
            let inheritedRequiredPropertiesContext = schema.inheritedRequiredProperties.map(getPropertyContext)
            let inheritedOptionalPropertiesContext = schema.inheritedOptionalProperties.map(getPropertyContext)
            context["requiredProperties"] = inheritedRequiredPropertiesContext
            context["optionalProperties"] = inheritedOptionalPropertiesContext
            context["properties"] = inheritedRequiredPropertiesContext + inheritedOptionalPropertiesContext
            context["enums"] = schema.inheritedEnums.map(getEnumContext)
            context["schemas"] = schema.inheritedProperties.compactMap { property in
                getInlineSchemaContext(property.schema, name: property.name)
            }
        }
        context["allProperties"] = schema.inheritedProperties.map(getPropertyContext)

        // fallback
        context["type"] = getSchemaType(name: "", schema: schema)

        switch schema.type {
        case let .group(groupSchema):
            switch groupSchema.type {
            case .any, .one:
                let references = groupSchema.schemas.compactMap { $0.type.reference }
                var discriminatorTypeContext = Context()

                func getReferenceContext<T>(_ reference: Reference<T>) -> Context {
                    var context: Context = [:]
                    context["type"] = getModelType(reference.name)
                    context["name"] = getName(reference.name)
                    return context
                }

                discriminatorTypeContext["subTypes"] = references.map(getReferenceContext)
                var mapping: [String: Context] = [:]
                for reference in references {
                    mapping[reference.name] = getReferenceContext(reference)
                }
                if let discriminatorMapping = groupSchema.discriminator?.mapping {
                    for (key, value) in discriminatorMapping {
                        // TODO: could reference another spec
                        let reference = Reference<Schema>(value)
                        mapping[key] = getReferenceContext(reference)
                    }
                }
                discriminatorTypeContext["discriminatorProperty"] = groupSchema.discriminator?.propertyName
                discriminatorTypeContext["mapping"] = mapping

                context["discriminatorType"] = discriminatorTypeContext
            case .all: break
            }
        default: break
        }

        return context
    }

    func getPathContext(_ path: Path) -> Context {
        var context: Context = [:]

        context["path"] = path.path
        context["parameters"] = path.parameters.map { $0.value }.map(getParameterContext)
        context["operations"] = path.operations.map(getOperationContext)

        return context
    }

    func getOperationContext(_ operation: Swagger.Operation) -> Context {
        var context: Context = [:]

        if let operationId = operation.identifier {
            context["operationId"] = operationId
            context["type"] = escapeType(operationId.upperCamelCased())
        } else {
            let pathParts = operation.path.components(separatedBy: "/")
            var pathName = pathParts.map { $0.upperCamelCased() }.joined(separator: "")
            pathName = pathName.replacingOccurrences(of: "\\{(.*?)\\}", with: "By_$1", options: .regularExpression, range: nil)
            let generatedOperationId = operation.method.rawValue.lowercased() + pathName.upperCamelCased()
            context["operationId"] = generatedOperationId
            context["type"] = escapeType(generatedOperationId.upperCamelCased())
        }

        context["raw"] = operation.json
        context["method"] = operation.method.rawValue.uppercased()
        context["path"] = operation.path
        context["description"] = operation.description
        context["summary"] = operation.summary
        context["tag"] = operation.tags.first
        context["tags"] = operation.tags

        let params = operation.parameters.map { $0.value }

        context["params"] = params.map(getParameterContext)
        context["pathParams"] = operation.getParameters(type: .path).map(getParameterContext)
        context["queryParams"] = operation.getParameters(type: .query).map(getParameterContext)
        context["headerParams"] = operation.getParameters(type: .header).map(getParameterContext)
        context["cookieParams"] = operation.getParameters(type: .cookie).map(getParameterContext)

        context["hasBody"] = operation.requestBody != nil

        var requestSchemas: [Context] = params.compactMap { parameter in
            switch parameter.type {
            case let .content(content):
                if let schema = content.defaultSchema {
                    return getInlineSchemaContext(schema, name: parameter.name)
                } else {
                    return nil
                }
            case let .schema(schema):
                return getInlineSchemaContext(schema.schema, name: parameter.name)
            }
        }

        var formProperties: [Context] = []

        if let requestBody = operation.requestBody {
            // TODO: allow other types of schemas
            if let schema = requestBody.value.content.jsonSchema {
                let name = requestBody.name ?? "Body"
                if let schemaContext = getInlineSchemaContext(schema, name: name) {
                    requestSchemas.append(schemaContext)
                }
                context["body"] = getRequestBodyContext(requestBody)
                context["bodyProperties"] = schema.properties.map(getPropertyContext)
            }
            if let formSchema = requestBody.value.content.formSchema ?? requestBody.value.content.multipartFormSchema {
                formProperties = formSchema.properties.map(getPropertyContext)
                context["isUpload"] = formSchema.properties.contains { $0.schema.isFile }
            }
        }
        context["requestSchemas"] = requestSchemas
        context["formProperties"] = formProperties

        // TODO: separate
        context["nonBodyParams"] = params.map(getParameterContext) + formProperties // params and form properties

        let securityRequirements = operation.securityRequirements ?? spec.securityRequirements
        context["securityRequirement"] = securityRequirements?.first.flatMap(getSecurityRequirementContext)
        context["securityRequirements"] = securityRequirements?.map(getSecurityRequirementContext)

        // Responses

        let responses = operation.responses
        let successResponses = responses.filter { $0.successful }.map(getResponseContext)
        let failureResponses = responses.filter { !$0.successful }.map(getResponseContext)

        context["responses"] = successResponses + failureResponses
        context["successResponse"] = successResponses.first
        context["successType"] = successResponses.first?["type"]
        context["defaultResponse"] = failureResponses.first { $0["statusCode"] == nil }
        context["onlySuccessResponses"] = !successResponses.isEmpty && responses.count == 1
        context["alwaysHasResponseType"] = responses.filter { $0.response.value.schema != nil }.count == responses.count

        let successTypes = successResponses.compactMap { $0["type"] as? String }
        let failureTypes = failureResponses.compactMap { $0["type"] as? String }

        if Set(successTypes).count == 1 {
            context["singleSuccessType"] = successTypes.first
        }
        if Set(failureTypes).count == 1 {
            context["singleFailureType"] = failureTypes.first
        }

        context["enums"] = operation.enums.map(getEnumContext)
        context["requestEnums"] = operation.requestEnums.map(getEnumContext)
        context["responseEnums"] = operation.responseEnums.map(getEnumContext)

        let responseSchemas: [Context] = operation.responses.compactMap { response in
            guard let schema = response.response.value.schema else { return nil }
            return getInlineSchemaContext(schema, name: response.name.lowerCamelCased())
        }
        context["responseSchemas"] = responseSchemas
        context["hasResponseModels"] = !operation.responses.filter { $0.response.value.schema != nil }.isEmpty

        return context
    }

    func getRequestBodyContext(_ requestBody: PossibleReference<RequestBody>) -> Context {
        var context: Context = [:]
        let name = "body"
        if let schema = requestBody.value.content.defaultSchema {
            context = getSchemaContext(schema)
            context["type"] = getSchemaType(name: requestBody.name ?? name, schema: schema)
        }
        context["name"] = name
        context["required"] = requestBody.value.required

        return context
    }

    func getResponseContext(_ response: OperationResponse) -> Context {
        var context: Context = [:]

        context["success"] = response.successful
        context["name"] = response.name.lowerCamelCased()
        context["statusCode"] = response.statusCode
        context["success"] = response.successful
        context["schema"] = response.response.value.schema.flatMap(getSchemaContext)
        context["description"] = response.response.value.description.description
        context["type"] = response.response.value.schema.flatMap { getSchemaType(name: response.name, schema: $0) }

        return context
    }

    func getSecurityRequirementContext(_ securityRequirement: SecurityRequirement) -> Context {
        var context: Context = [:]

        context["name"] = securityRequirement.name
        context["scopes"] = securityRequirement.scopes
        context["scope"] = securityRequirement.scopes.first

        return context
    }

    func getParameterContext(_ parameter: Parameter) -> Context {
        var context: Context = [:]

        context["raw"] = parameter.json
        context["name"] = getName(parameter.name)
        context["value"] = parameter.name
        context["example"] = parameter.example
        context["required"] = parameter.required
        context["optional"] = !parameter.required
        context["parameterType"] = parameter.location.rawValue
        context["description"] = parameter.description

        if let schema = parameter.schema,
            case .array = schema.type {
            context["isArray"] = true
        }
        switch parameter.type {
        case let .content(content):
            if let schema = content.defaultSchema {
                context["type"] = getSchemaType(name: parameter.name, schema: schema)
            }
        case let .schema(schema):
            context["type"] = getSchemaType(name: parameter.name, schema: schema.schema)
        }

        return context
    }

    func getPropertyContext(_ property: Property) -> Context {
        var context: Context = getSchemaContext(property.schema)

        if let json = context["raw"] as? [String: Any] {
            var newJson = json
            newJson["name"] = property.name
            context["raw"] = newJson
        }

        context["required"] = property.required
        context["optional"] = property.nullable
        context["name"] = propertyNames[property.name] ?? getName(property.name)      
        context["value"] = property.name
        context["type"] = getSchemaType(name: property.name, schema: property.schema)

        if case .array = property.schema.type {
            context["isArray"] = true
        }

        return context
    }

    func getEnumContext(_ enumValue: Enum) -> Context {
        var context: Context = [:]

        var specEnum: Enum?
        for globalEnum in enums {
            if String(describing: globalEnum.cases) == String(describing: enumValue.cases) {
                specEnum = globalEnum
                break
            }
        }
        context["enumName"] = getEnumType(enumValue.name)

        if let specEnum = specEnum {
            context["enumName"] = getEnumType(specEnum.name)
            context["isGlobal"] = true
        }
        var enumCases: [[String: String]] = []
        for (index, value) in enumValue.cases.enumerated() {
            let value = String(describing: value)
            var name = value
            if let names = enumValue.names,
                enumValue.cases.count == names.count {
                name = names[index]
            }
            if name == "" {
                name = "empty"
            }
            enumCases.append(["name": getName(name), "value": value])
        }
        context["enums"] = enumCases
        context["description"] = specEnum?.description ?? enumValue.description
        context["raw"] = enumValue.metadata.json
        context["type"] = getSchemaType(name: "", schema: enumValue.schema, checkEnum: false)
        return context
    }

    func escapeString(_ string: String) -> String {
        let replacements: [(String, String)] = [
            (">=", "greaterThanOrEqualTo"),
            ("<=", "lessThanOrEqualTo"),
            (">", "greaterThan"),
            ("<", "lessThan"),
            ("$", "dollar"),
            ("%", "percent"),
            ("#", "hash"),
            ("@", "alpha"),
            ("&", "and"),
        ]
        var escapedString = string
        for (symbol, replacement) in replacements {
            escapedString = escapedString.replacingOccurrences(of: symbol, with: replacement)
        }
        escapedString = String(String.UnicodeScalarView(escapedString.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }))

        // prepend _ strings starting with numbers
        if let firstCharacter = escapedString.unicodeScalars.first,
            CharacterSet.decimalDigits.contains(firstCharacter) {
            escapedString = "_\(escapedString)"
        }

        if escapedString.isEmpty || escapedString == "_" {
            escapedString = "UNKNOWN234"
        }
        return escapedString
    }

    // MARK: name and types

    func getName(_ name: String) -> String {
        var name = name.replacingOccurrences(of: "^-(\\d)", with: "_negative$1", options: .regularExpression)
        name = name.lowerCamelCased()
        return escapeName(name)
    }

    func getEnumType(_ name: String) -> String {
        if let enumName = enumNames[name] {
            return enumName
        }
        return escapeType("\(modelPrefix)\(name.upperCamelCased())")
    }

    func getModelType(_ name: String) -> String {
        if let modelName = modelNames[name] {
            return modelName
        }
        let type = name.upperCamelCased()
        return escapeType("\(modelPrefix)\(type)\(modelSuffix)")
    }

    func getSchemaType(name: String, schema: Schema, checkEnum: Bool = true) -> String {
        return "UNKNOWN_SCHEMA_TYPE"
    }

    // MARK: escaping

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
}
