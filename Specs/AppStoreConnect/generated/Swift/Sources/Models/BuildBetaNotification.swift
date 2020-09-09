//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BuildBetaNotification: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case buildBetaNotifications = "buildBetaNotifications"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public init(links: ResourceLinks, id: String, type: `Type`) {
        self.links = links
        self.id = id
        self.type = type
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        links = try container.decode("links")
        id = try container.decode("id")
        type = try container.decode("type")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(links, forKey: "links")
        try container.encode(id, forKey: "id")
        try container.encode(type, forKey: "type")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? BuildBetaNotification else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      return true
    }

    public static func == (lhs: BuildBetaNotification, rhs: BuildBetaNotification) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
