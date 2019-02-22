//
//  Component.swift
//  Swagger
//
//  Created by Yonas Kolb on 15/2/19.
//

import Foundation
import JSONUtilities

public struct ComponentObject<T: Component> {
    public let name: String
    public let value: T
}

public protocol Component: JSONObjectConvertible {
    static var componentType: ComponentType { get }
}

public enum ComponentType: String {
    case schema = "schemas"
    case response = "responses"
    case parameter = "parameters"
    case example = "examples"
    case requestBody = "requestBodies"
    case header = "headers"
    case securityScheme = "securitySchemes"
    case link = "links"
    case callback = "callbacks"
}

extension Parameter: Component {
    public static let componentType: ComponentType = .parameter
}

extension Response: Component {
    public static let componentType: ComponentType = .response
}

extension Schema: Component {
    public static let componentType: ComponentType = .schema
}

extension SecurityScheme: Component {
    public static let componentType: ComponentType = .securityScheme
}

extension RequestBody: Component {
    public static let componentType: ComponentType = .requestBody
}

extension Header: Component {
    public static let componentType: ComponentType = .header
}
