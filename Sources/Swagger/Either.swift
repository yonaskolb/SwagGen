//
//  Either.swift
//  SwagGen
//
//  Created by Yonas Kolb on 8/5/17.
//
//

import Foundation
import JSONUtilities

public enum Either<A, B> {
    case a(A)
    case b(B)
}

extension Either where A: JSONObjectConvertible {

    init(jsonDictionary: JSONDictionary, key: String, b: B) {
        if let a: A = jsonDictionary.json(atKeyPath: key) as A? {
            self = .a(a)
        }
        else {
            self = .b(b)
        }
    }
}
