import Foundation

public func writeError(_ string: String) {
    writeMessage(string, to: .standardError)
}

public func writeMessage(_ string: String, to fileHandle: FileHandle = .standardOutput) {
    if let data = "\(string)\n".data(using: String.Encoding.utf8) {
        fileHandle.write(data)
    }
}

extension Dictionary {

    public var prettyPrinted: String {
        return recursivePrint()
    }

    func recursivePrint(indentIndex: Int = 0, indentString: String = "  ", arrayIdentifier: String = "- ") -> String {
        let indent = String(repeating: indentString, count: indentIndex)
        let indentNext = String(repeating: indentString, count: indentIndex + 1)
        let newline: String = "\n"
        let arrayWhitespace = String(repeating: " ", count: arrayIdentifier.characters.count)
        var lines: [String] = []
        for (key, value) in self {
            if let dictionary = value as? [String: Any] {
                let valueString = dictionary.recursivePrint(indentIndex: indentIndex + 1, indentString: indentString, arrayIdentifier: arrayIdentifier)
                lines.append("\(key):\(newline)\(valueString)")
            }
            else if let array = value as? [[String: Any]] {
                let arrayLines: [String] = array.map { dictionary in
                    var dictString = dictionary.recursivePrint(indentIndex: indentIndex + 1, indentString: indentString, arrayIdentifier: arrayIdentifier)
                    dictString = dictString.replacingOccurrences(of: indentString, with: "", options: [], range: indentString.startIndex ..< indentString.endIndex)
                    dictString = dictString.replacingOccurrences(of: indentNext, with: "\(indentNext)\(arrayWhitespace)")
                    return "\(indentNext)\(arrayIdentifier)\(dictString)"
                }
                lines.append("\(key):\(newline)\(arrayLines.joined(separator: newline))")
            }
            else if let array = value as? [Any] {
                let valueString = array.map{"\(arrayIdentifier)\($0)"}.joined(separator: "\(newline)\(indentNext)")
                lines.append("\(key):\(newline)\(indentNext)\(valueString)")
            }
            else {
                lines.append("\(key): \(value)")
            }
        }
        return lines.map{"\(indent)\($0)"}.joined(separator: newline)
    }
}
