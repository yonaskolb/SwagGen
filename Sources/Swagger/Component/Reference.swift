import JSONUtilities

public class Reference<T: JSONObjectConvertible> {
	
	let string: String
	
	private(set) public var _value: T?
	
	public func value(file: String = #filePath, line: Int = #line) throws -> T {
		guard let value = _value else {
			throw SwaggerError.unresolvedReference("\(string) \(file) \(line)")
		}
		return value
	}
	
	public var name: String {
		string.components(separatedBy: "/").last!
	}
	
	public init(_ string: String) {
		self.string = string
	}
	
	public convenience init(jsonDictionary: JSONDictionary) throws {
		let string: String = try jsonDictionary.json(atKeyPath: "$ref")
		self.init(string)
	}
	
	func resolve(with value: T) {
		_value = value
	}
	
	func getReferenceComponent(last index: Int) -> String? {
		let index = index - 1
		let components = string.components(separatedBy: "/")
		guard components.count >= -index, index < 0 else { return nil }
		return components[components.count + index]
	}
	
	public var referenceType: String? {
		getReferenceComponent(last: -1)
	}
	
	public var referenceName: String? {
		getReferenceComponent(last: 0)
	}
}

extension Reference where T: Component {
	
	public func component(file: String = #filePath, line: Int = #line) throws -> ComponentObject<T> {
		try ComponentObject(name: name, value: value(file: file, line: line))
	}
}

public enum PossibleReference<T: JSONObjectConvertible>: JSONObjectConvertible {
	case reference(Reference<T>)
	case value(T)
	
	public func value() throws -> T {
		switch self {
		case let .reference(reference): return try reference.value()
		case let .value(value): return value
		}
	}
	
	public var _value: T? {
		switch self {
		case let .reference(reference): return reference._value
		case let .value(value): return value
		}
	}
	
	public var reference: Reference<T>? {
		switch self {
		case .reference(let reference): return reference
		case .value: return nil
		}
	}
	
	public var name: String? {
		if case let .reference(reference) = self {
			return reference.name
		}
		return nil
	}
	
	public init(jsonDictionary: JSONDictionary) throws {
		if let reference: String = jsonDictionary.json(atKeyPath: "$ref") {
			self = .reference(Reference<T>(reference))
		} else {
			self = .value(try T(jsonDictionary: jsonDictionary))
		}
	}
}

extension PossibleReference where T: Component {
	
	public func swaggerObject() throws -> ComponentObject<T>? {
		if case let .reference(reference) = self {
			return try reference.component()
		}
		return nil
	}
}
