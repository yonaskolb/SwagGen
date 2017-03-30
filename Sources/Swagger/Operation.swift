//
//  Operation.swift
//  SwagGen
//
//  Created by Yonas Kolb on 18/2/17.
//
//

import Foundation
import JSONUtilities

public class Operation {

    public enum Method: String {
        case get
        case put
        case post
        case delete
        case options
        case head
        case patch
    }

    public let operationId: String?
    public let description: String?
    public let tags: [String]
    public var parameters: [Parameter]
    public let method: Method
    public let path: String
    public let responses: [Response]
    public var securityRequirements: [SecurityRequirement]

    public init(path: String, method: Method, jsonDictionary: JSONDictionary) throws {
        self.method = method
        self.path = path
        operationId = jsonDictionary.json(atKeyPath: "operationId")
        description = jsonDictionary.json(atKeyPath: "description")
        tags = jsonDictionary.json(atKeyPath: "tags") ?? []
        parameters = jsonDictionary.json(atKeyPath: "parameters") ?? []
        securityRequirements = jsonDictionary.json(atKeyPath: "security") ?? []
        let responseDictionary: JSONDictionary = try jsonDictionary.json(atKeyPath: "responses")
        var responses: [Response] = []
        for (key, value) in responseDictionary {
            if let statusCode = Int(key), let jsonDictionary = value as? JSONDictionary {
                responses.append(Response(statusCode: statusCode, jsonDictionary: jsonDictionary))
            }
        }
        self.responses = responses
    }

    public func getParameters(type: Parameter.ParamaterType) -> [Parameter] {
        return parameters.filter { $0.parameterType == type }
    }

    public var enums: [Parameter] {
        return parameters.filter { $0.enumValues != nil || $0.arrayValue?.enumValues != nil }
    }
}

public class Response {

    public let statusCode: Int
    public let description: String?
    public var schema: Value?

    init(statusCode: Int, jsonDictionary: JSONDictionary) {
        self.statusCode = statusCode
        description = jsonDictionary.json(atKeyPath: "description")
        schema = jsonDictionary.json(atKeyPath: "schema")
    }
}

public struct SecurityRequirement: JSONObjectConvertible {
    public let name: String
    public let scopes: [String]

    public init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.keys.first ?? ""
        scopes = try jsonDictionary.json(atKeyPath: "\(name).scopes")
    }
}

public class Parameter: Value {

    public var parameterType: ParamaterType?

    public enum ParamaterType: String {
        case body
        case path
        case query
        case form = "formData"
        case header
    }

    required public init(jsonDictionary: JSONDictionary) throws {
        parameterType = (try? jsonDictionary.json(atKeyPath: "in") as String).flatMap { ParamaterType(rawValue: $0) }
        try super.init(jsonDictionary: jsonDictionary)
    }
}
