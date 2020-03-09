{% include "Includes/Header.stencil" %}

import Foundation

public protocol APIModel: Codable, Equatable { }

extension APIModel {
    func encode() -> [String: Any] {
        guard
            let jsonData = try? JSONEncoder().encode(self),
            let jsonValue = try? JSONSerialization.jsonObject(with: jsonData),
            let jsonDictionary = jsonValue as? [String: Any] else {
                return [:]
        }
        return jsonDictionary
    }
}
