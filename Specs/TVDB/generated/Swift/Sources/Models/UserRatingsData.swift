//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public struct UserRatingsData: APIModel {

    public var data: [UserRatings]?

    public var errors: JSONErrors?

    public var links: Links?

    public init(data: [UserRatings]? = nil, errors: JSONErrors? = nil, links: Links? = nil) {
        self.data = data
        self.errors = errors
        self.links = links
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeArrayIfPresent("data")
        errors = try container.decodeIfPresent("errors")
        links = try container.decodeIfPresent("links")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(data, forKey: "data")
        try container.encodeIfPresent(errors, forKey: "errors")
        try container.encodeIfPresent(links, forKey: "links")
    }

}
