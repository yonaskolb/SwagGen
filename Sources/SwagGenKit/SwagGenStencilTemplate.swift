//
//  SwagGenStencilTemplate.swift
//  SwagGenKit
//
//  Created by Yonas Kolb on 20/2/19.
//

import Foundation
import Stencil

open class SwagGenStencilTemplate: Template {

    let replacementString = "akdjh4rhjdfgkv4nvdfdfg"

    public required init(templateString: String, environment: Environment? = nil, name: String? = nil) {
        let templateStringWithMarkedNewlines = templateString
            .replacingOccurrences(of: "\n([ \t]*)\n", with: "\n$1\(replacementString)\n", options: .regularExpression)
            .replacingOccurrences(of: "\n([ \t]*)\n", with: "\n$1\(replacementString)\n", options: .regularExpression)
        super.init(templateString: templateStringWithMarkedNewlines, environment: environment, name: name)
    }

    // swiftlint:disable:next discouraged_optional_collection
    override open func render(_ dictionary: [String: Any]? = nil) throws -> String {
        return try removeExtraLines(from: super.render(dictionary))
    }

    // Workaround until Stencil fixes https://github.com/stencilproject/Stencil/issues/22
    private func removeExtraLines(from string: String) -> String {
        return string
            .replacingOccurrences(of: "\\n([ \\t]*\\n)+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: "\n([ \t]*)\(replacementString)\n", with: "\n\n", options: .regularExpression)
            .replacingOccurrences(of: "\n([ \t]*)\(replacementString)\n", with: "\n\n", options: .regularExpression)
    }
}
