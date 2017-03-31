//
//  Utilities.swift
//  SwagGen
//
//  Created by Yonas Kolb on 31/3/17.
//
//

import Foundation

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

func +(lhs: [String: Any?], rhs: [String: Any?]) -> [String: Any] {
    var combined = lhs.clean()
    let cleanRight = rhs.clean()
    for (key, value) in cleanRight {
        combined[key] = value
    }
    return combined
}

extension String {

    private func camelCased(seperator: String) -> String {
        return components(separatedBy: seperator).map { $0.mapFirstChar { $0.uppercased() } }.joined(separator: "")
    }

    private func mapFirstChar(transform: (String) -> String) -> String {
        guard !characters.isEmpty else { return self }

        let first = transform(String(characters.prefix(1)))
        let rest = String(characters.dropFirst())
        return first + rest
    }

    private func camelCased() -> String {
        return camelCased(seperator: " ")
            .camelCased(seperator: "_")
            .camelCased(seperator: "-")
    }

    func lowerCamelCased() -> String {

        let string = camelCased()

        if string == string.uppercased() {
            return string.lowercased()
        }

        return string.mapFirstChar { $0.lowercased() }
    }

    func upperCamelCased() -> String {
        return camelCased().mapFirstChar { $0.uppercased() }
    }
}
