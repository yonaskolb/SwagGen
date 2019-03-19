import Foundation

public enum SerializationStyle: String {
    case form
    case simple
    case matrix
    case label
    case spaceDelimited
    case pipeDelimited
    case deepObject
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

extension ParameterLocation {

    var defaultSerializationStyle: SerializationStyle {
        switch self {
        case .query: return .form
        case .header: return .simple
        case .path: return .simple
        case .cookie: return .form
        }
    }
}

extension ParameterSchema {

    public var collectionFormat: CollectionFormat? {
        switch serializationStyle {
        case .form:
            return .csv
        // return explode ? nil : .csv //TODO: support multi for explode == truer
        case .spaceDelimited:
            return .ssv
        case .simple:
            return .csv
        case .pipeDelimited:
            return .pipes
        case .matrix:
            return nil
        case .label:
            return nil
        case .deepObject:
            return nil
        }
    }
}
