{% include "Includes/Header.stencil" %}

import Foundation

{% if options.modelProtocol %}
public protocol {{ options.modelProtocol }}: Codable, Equatable { }

extension {{ options.modelProtocol }} {
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
{% endif %}
