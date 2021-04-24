//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BundleIdsResponse: APIModel {

    public var data: [BundleId]

    public var links: PagedDocumentLinks

    public var included: [Included]?

    public var meta: PagingInformation?

    public init(data: [BundleId], links: PagedDocumentLinks, included: [Included]? = nil, meta: PagingInformation? = nil) {
        self.data = data
        self.links = links
        self.included = included
        self.meta = meta
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeArray("data")
        links = try container.decode("links")
        included = try container.decodeArrayIfPresent("included")
        meta = try container.decodeIfPresent("meta")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(data, forKey: "data")
        try container.encode(links, forKey: "links")
        try container.encodeIfPresent(included, forKey: "included")
        try container.encodeIfPresent(meta, forKey: "meta")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? BundleIdsResponse else { return false }
      guard self.data == object.data else { return false }
      guard self.links == object.links else { return false }
      guard self.included == object.included else { return false }
      guard self.meta == object.meta else { return false }
      return true
    }

    public static func == (lhs: BundleIdsResponse, rhs: BundleIdsResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
