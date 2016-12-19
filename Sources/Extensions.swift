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
import Yaml

extension Path: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        if let path = parser.shift() {
            self.init(path)
        } else {
            throw ArgumentError.missingValue(argument: nil)
        }
    }
}

extension Yaml {

    var jsonDictionary: JSONDictionary? {
        guard let dictionary = dictionary else { return nil }
        var jsonDictionary: JSONDictionary = [:]
        for (key, value) in dictionary {
            if case .string(let string) = key {
                jsonDictionary[string] = value.rawValue
            }
        }
        return jsonDictionary
    }

    var rawValue: Any {
        switch self {
        case .array(let array):
            return array.map { $0.rawValue }
        case .bool(let bool): return bool
        case .dictionary: return jsonDictionary!
        case .double(let double): return double
        case .int(let int): return int
        case .null: return 0
        case .string(let string): return string
        }
    }
}
