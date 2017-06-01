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
    public let json: JSONDictionary

    public init(path: String, pathParameters: [Parameter], method: Method, jsonDictionary: JSONDictionary) throws {
        self.json = jsonDictionary
        self.method = method
        self.path = path
        operationId = jsonDictionary.json(atKeyPath: "operationId")
        description = jsonDictionary.json(atKeyPath: "description")
        tags = jsonDictionary.json(atKeyPath: "tags") ?? []
        parameters = jsonDictionary.json(atKeyPath: "parameters") ?? []
        parameters.append(contentsOf: pathParameters)
        securityRequirements = jsonDictionary.json(atKeyPath: "security") ?? []
        let responseDictionary: JSONDictionary = try jsonDictionary.json(atKeyPath: "responses")
        var responses: [Response] = []
        for (key, value) in responseDictionary {
            if let jsonDictionary = value as? JSONDictionary {
                responses.append(Response(statusCode: key, jsonDictionary: jsonDictionary))
            }
        }
        self.responses = responses.sorted {
            let code1 = $0.statusCode
            let code2 = $1.statusCode
            switch (code1, code2) {
            case (.some(let code1), .some(let code2)): return code1 < code2
            case (.some, .none): return true
            case (.none, .some): return false
            default: return false
            }
        }
    }

    public func getParameters(type: Parameter.ParamaterType) -> [Parameter] {
        return parameters.filter { $0.parameterType == type }
    }

    public var enums: [Parameter] {
        return parameters.filter { $0.enumValues != nil || $0.arrayValue?.enumValues != nil }
    }
}

public class Response {

    public let statusCode: Int?
    public let description: String?
    public var schema: Value?
    public var success: Bool

    init(statusCode: String, jsonDictionary: JSONDictionary) {
        self.statusCode = Int(statusCode)
        description = jsonDictionary.json(atKeyPath: "description")
        schema = jsonDictionary.json(atKeyPath: "schema")
        success = statusCode.hasPrefix("2")
    }
}

public struct SecurityRequirement: JSONObjectConvertible {
    public let name: String
    public let scopes: [String]

    public init(jsonDictionary: JSONDictionary) throws {
        name = jsonDictionary.keys.first ?? ""
        scopes = try jsonDictionary.json(atKeyPath: .key(name))
    }
}

public class Parameter: Value {

    public var parameterType: ParamaterType?
    public var isFile: Bool { return type == "file" }

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
