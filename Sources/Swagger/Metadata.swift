import JSONUtilities

public struct Metadata {
    public private(set) var type: DataType?
    public private(set) var title: String?
    public private(set) var description: String?
    public private(set) var defaultValue: Any?
    public private(set) var enumValues: [Any]?
    public private(set) var enumNames: [String]?
    public private(set) var nullable: Bool
    public private(set) var example: Any?
    public var json: JSONDictionary

    public init() {
        type = nil
        title = nil
        description = nil
        defaultValue = nil
        enumValues = nil
        enumNames = nil
        nullable = false
        example = nil
        json = [:]
    }
    
    public mutating func merging(_ other: Metadata) {
        precondition(type != nil && type == other.type)
        title = optionalDiamond(title, other.title, merging: +)
        description = optionalDiamond(description, other.description, merging: +)
        enumValues = optionalDiamond(enumValues, other.enumValues, merging: +)
        enumNames = optionalDiamond(enumNames, other.enumNames, merging: +)
        nullable = nullable && other.nullable
        json["enum"] = optionalDiamond(json["enum"] as? [Any], other.json["enum"] as? [Any], merging: +)
        json["x-enum-names"] = optionalDiamond(json["x-enum-names"] as? [Any], other.json["x-enum-names"] as? [Any], merging: +)
    }
    
    func optionalDiamond<S>(
        _ lhs: S?,
        _ rhs: S?,
        merging op: (S, S) -> S
    ) -> S? {
        switch (lhs, rhs) {
        case (nil, nil):
            return nil
        case (nil, .some(let rvalue)):
            return rvalue
        case (.some(let lvalue), nil):
            return lvalue
        case (.some(let lvalue), .some(let rvalue)):
            return op(lvalue, rvalue)
        }
    }
}

extension Metadata: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        type = DataType(jsonDictionary: jsonDictionary)
        title = jsonDictionary.json(atKeyPath: "title")
        description = jsonDictionary.json(atKeyPath: "description")
        defaultValue = jsonDictionary["default"]
        enumValues = jsonDictionary["enum"] as? [Any]
        enumNames = jsonDictionary["x-enum-names"] as? [String]
        nullable = jsonDictionary.json(atKeyPath: "nullable") ?? jsonDictionary.json(atKeyPath: "x-nullable") ?? false
        example = jsonDictionary["example"]
        json = jsonDictionary
    }
}
