//
//  Utilities.swift
//  SwagGen
//
//  Created by Yonas Kolb on 31/3/17.
//
//

import Foundation


fileprivate func cleanDictionary(_ dictionary: [String: Any?]) -> [String: Any] {
    var clean: [String: Any] = [:]
    for (key, value) in dictionary {
        if let value = value {
            clean[key] = value
            if let dictionary = value as? [String: Any?] {
                clean[key] = cleanDictionary(dictionary)
            } else if let array = value as? [[String: Any?]] {
                clean[key] = array.map { cleanDictionary($0) }
            }
        }
    }
    return clean
}

func +(lhs: [String: Any?], rhs: [String: Any?]) -> [String: Any] {
    var combined = cleanDictionary(lhs)
    for (key, value) in rhs {
        if let value = value {
            combined[key] = value
        }
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
