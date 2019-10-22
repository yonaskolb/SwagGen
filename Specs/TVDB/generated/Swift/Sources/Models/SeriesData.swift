//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public struct SeriesData: APIModel {

    public var data: Series?

    public var errors: JSONErrors?

    public init(data: Series? = nil, errors: JSONErrors? = nil) {
        self.data = data
        self.errors = errors
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeIfPresent("data")
        errors = try container.decodeIfPresent("errors")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(data, forKey: "data")
        try container.encodeIfPresent(errors, forKey: "errors")
    }

}
