import JSONUtilities

public struct ArrayItem {

    public let items: Item
    public let collectionFormat: CollectionFormat
    public let minItems: Int
    public let maxItems: Int?
    public let uniqueItems: Bool
}

public enum CollectionFormat: String {
    case csv
    case ssv
    case tsv
    case pipes

    public var separator: String {
        switch self {
        case .csv: return ","
        case .ssv: return " "
        case .tsv: return "\t"
        case .pipes: return "|"
        }
    }
}

extension ArrayItem: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        items = try jsonDictionary.json(atKeyPath: "items")
        collectionFormat = (jsonDictionary.json(atKeyPath: "collectionFormat")) ?? .csv

        maxItems = jsonDictionary.json(atKeyPath: "maxItems")
        minItems = (jsonDictionary.json(atKeyPath: "minItems")) ?? 0
        uniqueItems = (jsonDictionary.json(atKeyPath: "uniqueItems")) ?? false
    }
}
