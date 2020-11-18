import JSONUtilities

public struct StringSchema {
    public let format: StringFormat?
    public let maxLength: Int?
    public let minLength: Int?

    public init(format: StringFormat? = nil,
                maxLength: Int? = nil,
                minLength: Int? = nil) {
        self.format = format
        self.maxLength = maxLength
        self.minLength = minLength
    }
}

public enum StringFormat: RawRepresentable {

    case format(StringFormatType)
    case other(String)

    public init(rawValue: String) {
        if let format = StringFormatType(rawValue: rawValue) {
            self = .format(format)
        } else {
            self = .other(rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case let .format(format): return format.rawValue
        case let .other(other): return other
        }
    }

    public enum StringFormatType: String {
        case byte
        case binary
        case base64
        case date
        case dateTime = "date-time"
        case email
        case hostname
        case ipv4
        case ipv6
        case password
        case uri
        case uuid
    }
}

extension StringSchema {

    public init(jsonDictionary: JSONDictionary) {
        format = jsonDictionary.json(atKeyPath: "format")
        maxLength = jsonDictionary.json(atKeyPath: "maxLength")
        minLength = (jsonDictionary.json(atKeyPath: "minLength")) ?? 0
    }
}
