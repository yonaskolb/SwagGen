{% include "Includes/Header.stencil" %}

import Foundation
import JSONUtilities

struct JSONDecoder {

    static func decodeJSON<T>(data: Data) throws -> T {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) else {
            throw JSONUtilsError.fileDeserializationFailed
        }
        guard let jsonType = json as? T else {
            throw JSONUtilsError.fileDeserializationFailed
        }
        return jsonType
    }

    static func decode(data: Data) throws -> [String: Any] {
        return try decodeJSON(data: data)
    }

    static func decode<T: JSONRawType>(data: Data) throws -> T {
        return try decodeJSON(data: data)
    }

    static func decode<T: JSONDecodable>(data: Data) throws -> T {
        let jsonDictionary: JSONDictionary = try decodeJSON(data: data)
        return try T(jsonDictionary: jsonDictionary)
    }

    static func decode<T: JSONRawType>(data: Data) throws -> [T] {
        return try decodeJSON(data: data)
    }

    static func decode<T: JSONDecodable>(data: Data) throws -> [T] {
        let jsonArray: [JSONDictionary] = try decodeJSON(data: data)
        return try jsonArray.map { json in
            try T(json: json)
        }
    }

    static func decode<T: RawRepresentable>(data: Data) throws -> [T] where T.RawValue: JSONRawType {
        let jsonArray: [T.RawValue] = try decodeJSON(data: data)
        return try jsonArray.map { rawValue in
            guard let value = T(rawValue: rawValue) else {
                throw JSONUtilsError.fileDeserializationFailed
            }
            return value
        }
    }

    static func decode<T: JSONRawType>(data: Data) throws -> [String: T] {
        let jsonDictionary: JSONDictionary = try decodeJSON(data: data)
        var dictionary: [String: T] = [:]
        for key in jsonDictionary.keys {
            dictionary[key] = try jsonDictionary.json(atKeyPath: .key(key)) as T
        }
        return dictionary
    }

    static func decode<T: JSONDecodable>(data: Data) throws -> [String: T] {
        let jsonDictionary: JSONDictionary = try decodeJSON(data: data)
        var dictionary: [String: T] = [:]
        for key in jsonDictionary.keys {
            dictionary[key] = try jsonDictionary.json(atKeyPath: .key(key)) as T
        }
        return dictionary
    }

    static func decode<T: JSONPrimitiveConvertible>(data: Data) throws -> [String: T] {
        let jsonDictionary: JSONDictionary = try decodeJSON(data: data)
        var dictionary: [String: T] = [:]
        for key in jsonDictionary.keys {
            dictionary[key] = try jsonDictionary.json(atKeyPath: .key(key)) as T
        }
        return dictionary
    }

    static func decode<T: RawRepresentable>(data: Data) throws -> [String: T] where T.RawValue: JSONRawType {
        let jsonDictionary: JSONDictionary = try decodeJSON(data: data)
        var dictionary: [String: T] = [:]
        for key in jsonDictionary.keys {
            dictionary[key] = try jsonDictionary.json(atKeyPath: .key(key)) as T
        }
        return dictionary
    }
}

// Decoding

public typealias JSONDecodable = JSONObjectConvertible

let dateFormatters: [DateFormatter] = {
    return ["yyyy-MM-dd",
    "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
    "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
    "yyyy-MM-dd'T'HH:mm:ss'Z'",
    ].map { (format: String) -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
}()

extension JSONDecodable {

    public init(json: Any) throws {
        guard let jsonDictionary = json as? JSONDictionary else { throw JSONUtilsError.fileNotAJSONDictionary }
        try self.init(jsonDictionary: jsonDictionary)
    }
}

extension Date: JSONPrimitiveConvertible {

    public typealias JSONType = String

    public static func from(jsonValue: String) -> Date? {

        for formatter in dateFormatters {
            if let date = formatter.date(from: jsonValue) {
                return self.init(timeIntervalSince1970: date.timeIntervalSince1970)
            }
        }
        return nil
    }
}


// Encoding

protocol JSONEncodable {
    func encode() -> JSONDictionary
}

protocol JSONValueEncodable {
    func encode() -> Any
}

extension JSONRawType {
    func encode() -> Any {
        return self
    }
}

extension RawRepresentable where RawValue: JSONRawType {
    func encode() -> Any {
        return rawValue.encode()
    }
}

extension Array where Element: RawRepresentable, Element.RawValue: JSONRawType {
    func encode() -> [Any] {
        return map{$0.encode()}
    }
}

extension Array where Element: JSONRawType {
    func encode() -> [Any] {
        return map{$0.encode()}
    }
}

extension Array where Element: JSONEncodable {
    func encode() -> [Any] {
        return map{$0.encode()}
    }
}

extension Array where Element: JSONValueEncodable {
    func encode() -> [Any] {
        return map{$0.encode()}
    }
}

extension Dictionary where Value: RawRepresentable, Value.RawValue: JSONRawType {
    func encode() -> Any {
        var dictionary: [Key: Any] = [:]
        for (key, value) in self {
            dictionary[key] = value.encode()
        }
        return dictionary
    }
}

extension Dictionary where Value: JSONRawType {
    func encode() -> Any {
        var dictionary: [Key: Any] = [:]
        for (key, value) in self {
            dictionary[key] = value.encode()
        }
        return dictionary
    }
}

extension Dictionary where Value: JSONEncodable {
    func encode() -> Any {
        var dictionary: [Key: Any] = [:]
        for (key, value) in self {
            dictionary[key] = value.encode()
        }
        return dictionary
    }
}

extension Dictionary where Value: JSONValueEncodable {
    func encode() -> Any {
        var dictionary: [Key: Any] = [:]
        for (key, value) in self {
            dictionary[key] = value.encode()
        }
        return dictionary
    }
}

extension Dictionary {
    func mapValues<T>(_ closure: (Value) -> T) -> [Key: T] {
        var dictionary: [Key: T] = [:]
        for (key, value) in self {
            dictionary[key] = closure(value)
        }
        return dictionary
    }
}

extension URL: JSONValueEncodable {
    func encode() -> Any {
        return absoluteString
    }
}

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = {{ options.name }}.dateEncodingFormat
    return dateFormatter
}()

extension Date: JSONValueEncodable {

    func encode() -> Any {
        dateFormatter.dateFormat = {{ options.name }}.dateEncodingFormat
        return dateFormatter.string(from: self)
    }
}

protocol PrettyPrintable {
    var prettyPrinted: String { get }
}

extension Dictionary {

    public var prettyPrinted: String {
        return recursivePrint()
    }

    public func recursivePrint(indentIndex: Int = 0, indentString: String = "  ", arrayIdentifier: String = "• ") -> String {
        let indent = String(repeating: indentString, count: indentIndex)
        let indentNext = String(repeating: indentString, count: indentIndex + 1)
        let newline: String = "\n"
        let arrayWhitespace = String(repeating: " ", count: arrayIdentifier.characters.count)
        var lines: [String] = []
        for (key, value) in self {
            if let dictionary = value as? [String: Any] {
                let valueString = dictionary.recursivePrint(indentIndex: indentIndex + 1, indentString: indentString, arrayIdentifier: arrayIdentifier)
                lines.append("\(key):\(newline)\(valueString)")
            } else if let array = value as? [[String: Any]] {
                if !array.isEmpty {
                    let arrayLines: [String] = array.map { dictionary in
                        var dictString = dictionary.recursivePrint(indentIndex: indentIndex + 1, indentString: indentString, arrayIdentifier: arrayIdentifier)
                        if let rangeOfIndent = dictString.range(of: indentNext) {
                            dictString = dictString.replacingCharacters(in: rangeOfIndent, with: "")
                        }
                        dictString = dictString.replacingOccurrences(of: indentNext, with: indentNext + arrayWhitespace)

                        return "\(indentNext)\(arrayIdentifier)\(dictString)"
                    }
                    lines.append("\(key):\(newline)\(arrayLines.joined(separator: newline))")
                }
            } else if let array = value as? [Any] {
                if !array.isEmpty {
                    let valueString = array.map { "\(arrayIdentifier)\($0)" }.joined(separator: "\(newline)\(indentNext)")
                    lines.append("\(key):\(newline)\(indentNext)\(valueString)")
                }
            } else {
                lines.append("\(key): \(value)")
            }
        }
        return lines.map { "\(indent)\($0)" }.joined(separator: newline)
    }
}
