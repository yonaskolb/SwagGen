//
//  Definition.swift
//  SwagGen
//
//  Created by Yonas Kolb on 18/2/17.
//
//

import Foundation
import JSONUtilities

public class Schema: JSONObjectConvertible {

    public var name: String?
    public let type: String?
    public let description: String?
    public let reference: String?
    public var parentReference: String?
    public var parent: Schema?
    public var propertiesByName: [String: Property]
    public let requiredProperties: [Property]
    public let optionalProperties: [Property]
    public let properties: [Property]
    public let json: JSONDictionary
    public var anonymous: Bool = false

    required public init(jsonDictionary: JSONDictionary) throws {
        self.json = jsonDictionary
        var json = jsonDictionary
        if let allOf = json.json(atKeyPath: "allOf") as [JSONDictionary]? {
            parentReference = allOf[0].json(atKeyPath: "$ref")
            json = allOf[1]
        }
        type = json.json(atKeyPath: "type")
        reference = json.json(atKeyPath: "$ref")
        description = json.json(atKeyPath: "description")
        propertiesByName = json.json(atKeyPath: "properties") ?? [:]
        propertiesByName.forEach { name, property in
            property.name = name
        }

        var requiredProperties: [Property] = []
        if let required = json.json(atKeyPath: "required") as [String]? {
            for propertyName in required {
                if let property = propertiesByName[propertyName] {
                    property.required = true
                    requiredProperties.append(property)
                }
            }
        }
        self.requiredProperties = requiredProperties
        optionalProperties = Array(propertiesByName.values).filter { !$0.required }.sorted{$0.name < $1.name}
        properties = requiredProperties + optionalProperties
    }

    public var allProperties: [Property] {
        return (parent?.allProperties ?? []) + properties
    }

    func deepDescription(prefix: String) -> String {
        return "\(prefix)\(name ?? "")\n\(prefix)\(properties.map { $0.deepDescription(prefix: prefix) }.joined(separator: "\n\(prefix)"))"
    }

    public var enums: [Value] {
        return properties.filter { $0.enumValues != nil || $0.arrayValue?.enumValues != nil }
    }
}

public class Property: Value {
}
