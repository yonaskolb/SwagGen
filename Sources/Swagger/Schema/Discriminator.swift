//
//  Discriminator.swift
//  Swagger
//
//  Created by Yonas Kolb on 25/2/19.
//

import Foundation
import JSONUtilities

public struct Discriminator {

    public var propertyName: String
    public let mapping: [String: String]
}

extension Discriminator: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        propertyName = try jsonDictionary.json(atKeyPath: "propertyName")
        mapping = jsonDictionary.json(atKeyPath: "mapping") ?? [:]
    }
}
