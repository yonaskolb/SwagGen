//
//  Extensions.swift
//  SwagGen
//
//  Created by Yonas Kolb on 3/12/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//
//

import Foundation
import JSONUtilities
import PathKit
import Commander

extension Path: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        if let path = parser.shift() {
            self.init(path)
        } else {
            throw ArgumentError.missingValue(argument: nil)
        }
    }
}

extension Dictionary where Key: StringProtocol {

    func json<JSONObjectConvertibleType : JSONObjectConvertible>(atKeyPath keyPath: Key) throws -> [String:JSONObjectConvertibleType] {

        guard let jsonValues = self[keyPath] as? JSONDictionary else {
            throw DecodingError.mandatoryKeyNotFound(key: keyPath)
        }

        var result: [String: JSONObjectConvertibleType] = [:]
        for (key, _) in jsonValues {
            result[key] = try jsonValues.json(atKeyPath: key) as JSONObjectConvertibleType
        }

        return result
    }
}
