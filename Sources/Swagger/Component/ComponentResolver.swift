import Foundation

#if !swift(>=4.2)
    public protocol CaseIterable {
        static var allCases: [Self] { get }
    }
#endif

class ComponentResolver {

    let spec: SwaggerSpec

    var components: Components {
        return spec.components
    }

    init(spec: SwaggerSpec) {
        self.spec = spec
    }

    func resolve() {

        resolve(components.schemas, resolve)
        resolve(components.parameters, resolve)
        resolve(components.requestBodies, resolve)
        resolve(components.headers, resolve)
        resolve(components.requestBodies, resolve)

        spec.paths.forEach { path in
            path.parameters.forEach(resolve)
            path.operations.forEach { operation in
                operation.pathParameters.forEach(resolve)
                operation.operationParameters.forEach(resolve)
                operation.responses.forEach(resolve)
                if let requestBody = operation.requestBody {
                    resolveReference(requestBody, objects: components.requestBodies)
                    resolve(requestBody.value.content)
                }
            }
        }
    }

    private func resolveReference<T>(_ reference: Reference<T>, objects: [ComponentObject<T>]) {
        if reference.referenceType == T.componentType.rawValue,
            let name = reference.referenceName,
            let object = objects.first(where: { $0.name == name }) {
            reference.resolve(with: object.value)
        }
    }

    private func resolveReference<T: Component>(_ reference: PossibleReference<T>, objects: [ComponentObject<T>]) {
        if case let .reference(reference) = reference {
            resolveReference(reference, objects: objects)
        }
    }

    private func resolve(_ schema: SchemaType) {
        switch schema {
        case let .reference(reference): resolveReference(reference, objects: components.schemas)
        case let .object(object):
            object.properties.forEach { resolve($0.schema) }
            if let additionalProperties = object.additionalProperties {
                resolve(additionalProperties)
            }
        case let .group(schemaGroup): schemaGroup.schemas.forEach(resolve)
        case let .array(array):
            switch array.items {
            case let .single(schema): resolve(schema)
            case let .multiple(schemas): schemas.forEach(resolve)
            }
        default: break
        }
    }

    private func resolve(_ mediaItem: MediaItem) {
        switch mediaItem.schema {
        case .reference(let schemaReference):
            resolveReference(schemaReference, objects: components.schemas)
        case .value(let schema):
            resolve(schema)
        }
    }

    private func resolve(_ content: Content) {
        for mediaItem in content.mediaItems.values {
            resolve(mediaItem)
        }
    }

    private func resolve(_ header: Header) {
        resolve(header.schema.schema)
    }

    private func resolve(_ requestBody: RequestBody) {
        resolve(requestBody.content)
    }

    private func resolve(_ schema: Schema) {
        resolve(schema.type)
    }

    private func resolve(_ reference: PossibleReference<Parameter>) {
        resolveReference(reference, objects: components.parameters)
        resolve(reference.value)
    }

    private func resolve(_ parameter: Parameter) {

        switch parameter.type {
        case let .schema(schema): resolve(schema.schema)
        case let .content(content): resolve(content)
        }
    }

    private func resolve(_ response: OperationResponse) {
        resolveReference(response.response, objects: components.responses)
        if let content = response.response.value.content {
            resolve(content)
        }
        for reference in response.response.value.headers.values {
            resolveReference(reference, objects: components.headers)
        }
    }

    private func resolve<T>(_ components: [ComponentObject<T>], _ resolver: (T) -> Void) {
        components.forEach { resolver($0.value) }
    }
}
