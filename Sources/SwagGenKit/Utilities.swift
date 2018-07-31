import Foundation
import JSONUtilities
import PathKit

extension Path: JSONPrimitiveConvertible {

    public typealias JSONType = String

    public static func from(jsonValue: String) -> Path? {
        return Path(jsonValue)
    }
}

extension String {

    static func getFirstDifferentLine(_ string1: String, _ string2: String) -> (string1: String, string2: String, line: Int)? {
        guard string1 != string2 else { return nil }

        let commonPrefix = string1.commonPrefix(with: string2)
        let startOfLine = commonPrefix.range(of: "\n", options: .backwards, range: commonPrefix.startIndex ..< commonPrefix.endIndex, locale: nil)

        let startIndex = startOfLine?.upperBound ?? commonPrefix.startIndex

        let endOfLine1 = string1.range(of: "\n", options: [], range: commonPrefix.endIndex ..< string1.endIndex, locale: nil)?.lowerBound ?? string1.endIndex
        let endOfLine2 = string2.range(of: "\n", options: [], range: commonPrefix.endIndex ..< string2.endIndex, locale: nil)?.lowerBound ?? string2.endIndex

        let diff1 = String(string1[startIndex ..< endOfLine1])
        let diff2 = String(string2[startIndex ..< endOfLine2])

        let line = commonPrefix.components(separatedBy: "\n").count + 1
        return (diff1, diff2, line)
    }
}

extension Dictionary where Key == String, Value == Any? {

    func clean() -> [String: Any] {
        var clean: [String: Any] = [:]
        for (key, value) in self {
            if let value = value {
                clean[key] = value
                if let dictionary = value as? [String: Any?] {
                    clean[key] = dictionary.clean()
                } else if let array = value as? [[String: Any?]] {
                    clean[key] = array.map { $0.clean() }
                }
            }
        }
        return clean
    }
}

func + (lhs: [String: Any?], rhs: [String: Any?]) -> [String: Any] {
    var combined = lhs.clean()
    let cleanRight = rhs.clean()
    for (key, value) in cleanRight {
        combined[key] = value
    }
    return combined
}

fileprivate let separators = [" ", "_", "-", "."]
fileprivate let acronymStrings = ["URL"]

extension String {

    private func camelCased(seperator: String) -> String {

        var index = 0
        let components = self.components(separatedBy: seperator)
        if uppercased() == self {
            return components.map { $0.lowercased().mapFirstChar { $0.uppercased()} }.joined(separator: "")
        }
        return components
            .map { string in
                defer {
                    index += 1
                }
                if index > 0 && string.isAcronym {
                    return string.uppercased()
                } else if string.count == 1 {
                    return string
                } else {
                    return string.upperCamelCased()
                }
            }
            .joined(separator: "")
    }

    private func mapFirstChar(transform: (String) -> String) -> String {
        guard !isEmpty else { return self }

        let first = transform(String(prefix(1)))
        let rest = String(dropFirst())
        return first + rest
    }

    private func camelCaseSeperators() -> String {
        var string = self
        for separator in separators {
            if string.contains(separator) {
                string = string.camelCased(seperator: separator)
            }
        }
        return string
    }

    private var hasSeparator: Bool {
        return separators.contains(where: { contains($0)})
    }

    private var isAcronym: Bool {
        return acronymStrings.contains(uppercased())
    }

    func lowerCamelCased() -> String {

        let string = camelCaseSeperators()

        if string == string.uppercased() && !hasSeparator {
            return string.lowercased()
        }

        return string.mapFirstChar { $0.lowercased() }
    }

    func upperCamelCased() -> String {
        if acronymStrings.contains(uppercased()) && !hasSeparator {
            return uppercased()
        }
        return camelCaseSeperators().mapFirstChar { $0.uppercased() }
    }
}

extension Dictionary {

    public var prettyPrinted: String {
        return recursivePrint()
    }

    public func recursivePrint(indentIndex: Int = 0, indentString: String = "  ", arrayIdentifier: String = "- ") -> String {
        let indent = String(repeating: indentString, count: indentIndex)
        let indentNext = String(repeating: indentString, count: indentIndex + 1)
        let newline: String = "\n"
        let arrayWhitespace = String(repeating: " ", count: arrayIdentifier.count)
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

public func getCountString(counts: [(type: String, count: Int)], pluralise: Bool) -> String {
    return counts.filter { $0.count > 0 }.map { "\($0.count) \($0.count == 1 || !pluralise ? $0.type : "\($0.type)s")" }.joined(separator: ", ")
}
