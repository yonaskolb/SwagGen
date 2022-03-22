import Foundation
import JSONUtilities
import PathKit
import Yams

#if !swift(>=4.2)
public protocol CaseIterable {
	static var allCases: [Self] { get }
}
#endif

class ComponentResolver {
	
	var spec: SwaggerSpec
	var schemeURL: URL?
	
	var components: Components {
		get { spec.components }
		set { spec.components = newValue }
	}
	
	init(spec: SwaggerSpec, schemeURL: URL?) {
		self.spec = spec
		self.schemeURL = schemeURL
	}
	
	func resolve() throws {
		try resolve(components.schemas, resolve)
		try resolve(components.parameters, resolve)
		try resolve(components.requestBodies, resolve)
		try resolve(components.headers, resolve)
		try resolve(components.requestBodies, resolve)
		try spec.paths.forEach {
			try resolve($0.value)
		}
	}
	
	private func resolveReference<T>(_ reference: Reference<T>, objects: inout [ComponentObject<T>], _ resolver: (T) throws -> Void) throws {
		if reference.referenceType == T.componentType.rawValue,
			 let name = reference.referenceName,
			 let object = objects.first(where: { $0.name == name }) {
			reference.resolve(with: object.value)
		} else {
			try resolveReference(reference, resolver)
			try? objects.append(reference.component())
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
		guard reference.string.hasSuffix("yaml") else {
			return
		}
		let url = try url(for: reference.string)
		let data: Data
		do {
			data = try Data(contentsOf: url)
		} catch {
			throw SwaggerError.loadError(url)
		}
		let string = String(data: data, encoding: .utf8) ?? ""
		let yaml = try Yams.load(yaml: string)
		let json = yaml as? JSONDictionary ?? [:]
		let value = try T.init(jsonDictionary: json)
		reference.resolve(with: value)
		let currentURL = schemeURL
		schemeURL = url
		try resolver(reference.value())
		schemeURL = currentURL
	}
	
	private func url(for ref: String) throws -> URL {
		guard var url = schemeURL?.deletingLastPathComponent() else {
			throw SwaggerError.noUrl
		}
		var value = ref.replacingOccurrences(of: "\\/", with: "/")
		while value.hasPrefix("./") {
			value.removeFirst(2)
		}
		while value.hasPrefix("../") {
			value.removeFirst(3)
			url = url.deletingLastPathComponent()
		}
		value = value.trimmingCharacters(in: CharacterSet(charactersIn: "./#"))
		return url.appendingPathComponent(value)
	}
	
	private func resolve(_ schema: SchemaType) throws {
		switch schema {
		case let .reference(reference):
			try resolveReference(reference, objects: &components.schemas) { _ in }
			
		case let .object(object):
			try object.properties.forEach { try resolve($0.schema) }
			try object.requiredProperties.forEach { try resolve($0.schema) }
			try object.optionalProperties.forEach { try resolve($0.schema) }
			
			if let additionalProperties = object.additionalProperties {
				try resolve(additionalProperties)
			}
			
		case let .group(schemaGroup):
			try schemaGroup.schemas.forEach(resolve)
			
		case let .array(array):
			switch array.items {
			case let .single(schema):
				try resolve(schema)
				
			case let .multiple(schemas):
				try schemas.forEach(resolve)
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
		if let schema = header.schema.schema {
			try resolve(schema)
		}
	}
	
	private func resolve(_ requestBody: RequestBody) throws {
		try resolve(requestBody.content)
	}
	
	private func resolve(_ schema: Schema) throws {
		try resolve(schema.type)
	}
	
	private func resolve(_ reference: PossibleReference<Path>) throws {
		try resolveReference(reference, resolve)
	}
	
	private func resolve(_ path: Path) throws {
		try path.parameters.forEach(resolve)
		try path.operations.forEach { operation in
//			public let defaultResponse: PossibleReference<Response>?
			
			try operation.pathParameters.forEach(resolve)
			try operation.operationParameters.forEach(resolve)
			try operation.responses.forEach(resolve)
			if let requestBody = operation.requestBody {
				try resolveReference(requestBody, objects: &components.requestBodies) {
				 	try resolve($0.content)
				}
			}
		}
	}
	
	private func resolve(_ reference: PossibleReference<Parameter>) throws {
		try resolveReference(reference, objects: &components.parameters, resolve)
	}
	
	private func resolve(_ parameter: Parameter) throws {
		switch parameter.type {
		case let .schema(schema):
			if let schema = schema.schema {
				try resolve(schema)
			}
		case let .content(content):
			try resolve(content)
		}
	}
	
	private func resolve(_ response: OperationResponse) throws {
		try resolveReference(response.response, objects: &components.responses) {
			if let content = $0.content {
				try resolve(content)
			}
		}
		for reference in try response.response.value().headers.values {
			try resolveReference(reference, objects: &components.headers) { _ in }
		}
	}
	
	private func resolve<T>(_ components: [ComponentObject<T>], _ resolver: (T) throws -> Void) throws {
		try components.forEach { try resolver($0.value) }
	}
}
