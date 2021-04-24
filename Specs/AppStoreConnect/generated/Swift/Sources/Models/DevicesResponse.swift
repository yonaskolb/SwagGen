//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class DevicesResponse: APIModel {

    public var data: [Device]

    public var links: PagedDocumentLinks

    public var meta: PagingInformation?

    public init(data: [Device], links: PagedDocumentLinks, meta: PagingInformation? = nil) {
        self.data = data
        self.links = links
        self.meta = meta
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeArray("data")
        links = try container.decode("links")
        meta = try container.decodeIfPresent("meta")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(data, forKey: "data")
        try container.encode(links, forKey: "links")
        try container.encodeIfPresent(meta, forKey: "meta")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? DevicesResponse else { return false }
      guard self.data == object.data else { return false }
      guard self.links == object.links else { return false }
      guard self.meta == object.meta else { return false }
      return true
    }

    public static func == (lhs: DevicesResponse, rhs: DevicesResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
