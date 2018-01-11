import JSONUtilities

public class Reference<T: JSONObjectConvertible> {

    let string: String

    private var _value: T?
    public var value: T {
        guard let value = _value else {
            fatalError("Reference \(string) is unresolved")
        }
        return value
    }

    public let name: String

    public init(_ string: String) {
        self.string = string
        name = string.components(separatedBy: "/").last!
    }

    public convenience init(jsonDictionary: JSONDictionary) throws {
        let string: String = try jsonDictionary.json(atKeyPath: "$ref")
        self.init(string)
    }

    public var swaggerObject: SwaggerObject<T> {
        return SwaggerObject(name: name, value: value)
    }

    func resolve(with value: T) {
        _value = value
    }

    func getReferenceComponent(index: Int) -> String? {
        let components = string.components(separatedBy: "/")
        guard components.count > index else { return nil }
        return components[index]
    }

    public var referenceType: String? {
        return getReferenceComponent(index: 1)
    }

    public var referenceName: String? {
        return getReferenceComponent(index: 2)
    }
}

public enum PossibleReference<T: JSONObjectConvertible>: JSONObjectConvertible {

    case reference(Reference<T>)
    case value(T)

    public var value: T {
        switch self {
        case let .reference(reference): return reference.value
        case let .value(value): return value
        }
    }

    public var name: String? {
        if case let .reference(reference) = self {
            return reference.name
        }
        return nil
    }

    public var swaggerObject: SwaggerObject<T>? {
        if case let .reference(reference) = self {
            return reference.swaggerObject
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
