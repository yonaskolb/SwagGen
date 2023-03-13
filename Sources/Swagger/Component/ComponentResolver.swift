import Foundation
import Yams
import JSONUtilities

#if !swift(>=4.2)
    public protocol CaseIterable {
        static var allCases: [Self] { get }
    }
#endif

class ComponentResolver {
    
    static var schemeURL: URL?

    var spec: SwaggerSpec

    var components: Components {
        get { spec.components }
        set { spec.components = newValue }
    }

    init(spec: SwaggerSpec) {
        self.spec = spec
    }

    func resolve() throws {

        try resolve(components.schemas, resolve)
        try resolve(components.parameters, resolve)
        try resolve(components.requestBodies, resolve)
        try resolve(components.headers, resolve)
        try resolve(components.requestBodies, resolve)

        try spec.paths.forEach { path in
            try path.parameters.forEach(resolve)
            try path.operations.forEach { operation in
                try operation.pathParameters.forEach(resolve)
                try operation.operationParameters.forEach(resolve)
                try operation.responses.forEach(resolve)
                if let requestBody = operation.requestBody {
                    try resolveReference(requestBody, objects: &components.requestBodies, resolve)
                    try resolve(requestBody.value.content)
                }
            }
        }
    }
    
    private func resolveReference<T>(_ reference: Reference<T>, objects: inout [ComponentObject<T>], _ resolver: (T) throws -> Void) throws {
        if reference.referenceType == T.componentType.rawValue,
           let name = reference.referenceName,
           let object = objects.first(where: { $0.name == name }) {
            reference.resolve(with: object.value)
        } else {
            try resolveReference(reference, resolver)
            objects.append(reference.component)
        }
    }
    
    private func resolveReference<T: Component>(_ reference: PossibleReference<T>, objects: inout [ComponentObject<T>], _ resolver: (T) throws -> Void) throws {
        if case let .reference(reference) = reference {
            try resolveReference(reference, objects: &objects, resolver)
        } else if case .value(let value) = reference {
            try resolver(value)
        }
    }
    
    private func resolveReference<T>(_ reference: PossibleReference<T>, _ resolver: (T) throws -> Void) throws {
        if case let .reference(reference) = reference {
            try resolveReference(reference, resolver)
        } else if case .value(let value) = reference {
            try resolver(value)
        }
    }
    
    private func resolveReference<T: JSONObjectConvertible>(_ reference: Reference<T>, _ resolver: (T) throws -> Void) throws {
        let url = try url(for: reference.string)
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SwaggerError.loadError(url)
        }
        let json: JSONDictionary
        do {
            let string = String(data: data, encoding: .utf8) ?? ""
            let yaml = try Yams.load(yaml: string)
            json = yaml as? JSONDictionary ?? [:]
        } catch {
            json = try .from(jsonData: data)
        }
        let value = try T.init(jsonDictionary: json)
        reference.resolve(with: value)
        let currentURL = ComponentResolver.schemeURL
        ComponentResolver.schemeURL = url
        try resolver(reference.value)
        ComponentResolver.schemeURL = currentURL
    }
    
    private func resolve(_ schema: SchemaType) throws {
        switch schema {
        case let .reference(reference): try resolveReference(reference, objects: &components.schemas) { _ in }
        case let .object(object):
            try object.properties.forEach { try resolve($0.schema) }
            if let additionalProperties = object.additionalProperties {
                try resolve(additionalProperties)
            }
        case let .group(schemaGroup): try schemaGroup.schemas.forEach(resolve)
        case let .array(array):
            switch array.items {
            case let .single(schema): try resolve(schema)
            case let .multiple(schemas): try schemas.forEach(resolve)
            }
        default: break
        }
    }

    private func resolve(_ mediaItem: MediaItem) throws {
        try resolve(mediaItem.schema)
    }

    private func resolve(_ content: Content) throws {
        for mediaItem in content.mediaItems.values {
            try resolve(mediaItem)
        }
    }

    private func resolve(_ header: Header) throws {
        try resolve(header.schema.schema)
    }

    private func resolve(_ requestBody: RequestBody) throws {
        try resolve(requestBody.content)
    }

    private func resolve(_ schema: Schema) throws {
        try resolve(schema.type)
    }

    private func resolve(_ reference: PossibleReference<Parameter>) throws {
        try resolveReference(reference, objects: &components.parameters, resolve)
        try resolve(reference.value)
    }

    private func resolve(_ parameter: Parameter) throws {

        switch parameter.type {
        case let .schema(schema): try resolve(schema.schema)
        case let .content(content): try resolve(content)
        }
    }

    private func resolve(_ response: OperationResponse) throws {
        try resolveReference(response.response, objects: &components.responses) {
            if let content = $0.content {
                try resolve(content)
            }
        }

        if let content = response.response.value.content {
            try resolve(content)
        }
        for reference in response.response.value.headers.values {
            try resolveReference(reference, objects: &components.headers) { _ in }
        }
    }

    private func resolve<T>(_ components: [ComponentObject<T>], _ resolver: (T) throws -> Void) throws {
        try components.forEach { try resolver($0.value) }
    }
    
    private func url(for ref: String) throws -> URL {
        let ref = ref.replacingOccurrences(of: "\\/", with: "/")
        if let url = URL(string: ref) { return url }
        guard
            let baseURL = ComponentResolver.schemeURL,
            let url = URL(string: ref, relativeTo: baseURL)
        else {
            throw SwaggerError.missingURL
        }
        return url
    }
}
