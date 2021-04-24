//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class GameCenterEnabledVersion: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case gameCenterEnabledVersions = "gameCenterEnabledVersions"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public var attributes: Attributes?

    public var relationships: Relationships?

    public class Attributes: APIModel {

        public var iconAsset: ImageAsset?

        public var platform: Platform?

        public var versionString: String?

        public init(iconAsset: ImageAsset? = nil, platform: Platform? = nil, versionString: String? = nil) {
            self.iconAsset = iconAsset
            self.platform = platform
            self.versionString = versionString
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            iconAsset = try container.decodeIfPresent("iconAsset")
            platform = try container.decodeIfPresent("platform")
            versionString = try container.decodeIfPresent("versionString")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(iconAsset, forKey: "iconAsset")
            try container.encodeIfPresent(platform, forKey: "platform")
            try container.encodeIfPresent(versionString, forKey: "versionString")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Attributes else { return false }
          guard self.iconAsset == object.iconAsset else { return false }
          guard self.platform == object.platform else { return false }
          guard self.versionString == object.versionString else { return false }
          return true
        }

        public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public class Relationships: APIModel {

        public var app: App?

        public var compatibleVersions: CompatibleVersions?

        public class App: APIModel {

            public var data: DataType?

            public var links: Links?

            public class DataType: APIModel {

                public enum `Type`: String, Codable, Equatable, CaseIterable {
                    case apps = "apps"
                }

                public var id: String

                public var type: `Type`

                public init(id: String, type: `Type`) {
                    self.id = id
                    self.type = type
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    id = try container.decode("id")
                    type = try container.decode("type")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encode(id, forKey: "id")
                    try container.encode(type, forKey: "type")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? DataType else { return false }
                  guard self.id == object.id else { return false }
                  guard self.type == object.type else { return false }
                  return true
                }

                public static func == (lhs: DataType, rhs: DataType) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public class Links: APIModel {

                public var related: String?

                public var _self: String?

                public init(related: String? = nil, _self: String? = nil) {
                    self.related = related
                    self._self = _self
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    related = try container.decodeIfPresent("related")
                    _self = try container.decodeIfPresent("self")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(related, forKey: "related")
                    try container.encodeIfPresent(_self, forKey: "self")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? Links else { return false }
                  guard self.related == object.related else { return false }
                  guard self._self == object._self else { return false }
                  return true
                }

                public static func == (lhs: Links, rhs: Links) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public init(data: DataType? = nil, links: Links? = nil) {
                self.data = data
                self.links = links
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                data = try container.decodeIfPresent("data")
                links = try container.decodeIfPresent("links")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encodeIfPresent(data, forKey: "data")
                try container.encodeIfPresent(links, forKey: "links")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? App else { return false }
              guard self.data == object.data else { return false }
              guard self.links == object.links else { return false }
              return true
            }

            public static func == (lhs: App, rhs: App) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public class CompatibleVersions: APIModel {

            public var data: [DataType]?

            public var links: Links?

            public var meta: PagingInformation?

            public class DataType: APIModel {

                public enum `Type`: String, Codable, Equatable, CaseIterable {
                    case gameCenterEnabledVersions = "gameCenterEnabledVersions"
                }

                public var id: String

                public var type: `Type`

                public init(id: String, type: `Type`) {
                    self.id = id
                    self.type = type
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    id = try container.decode("id")
                    type = try container.decode("type")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encode(id, forKey: "id")
                    try container.encode(type, forKey: "type")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? DataType else { return false }
                  guard self.id == object.id else { return false }
                  guard self.type == object.type else { return false }
                  return true
                }

                public static func == (lhs: DataType, rhs: DataType) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public class Links: APIModel {

                public var related: String?

                public var _self: String?

                public init(related: String? = nil, _self: String? = nil) {
                    self.related = related
                    self._self = _self
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    related = try container.decodeIfPresent("related")
                    _self = try container.decodeIfPresent("self")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(related, forKey: "related")
                    try container.encodeIfPresent(_self, forKey: "self")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? Links else { return false }
                  guard self.related == object.related else { return false }
                  guard self._self == object._self else { return false }
                  return true
                }

                public static func == (lhs: Links, rhs: Links) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public init(data: [DataType]? = nil, links: Links? = nil, meta: PagingInformation? = nil) {
                self.data = data
                self.links = links
                self.meta = meta
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                data = try container.decodeArrayIfPresent("data")
                links = try container.decodeIfPresent("links")
                meta = try container.decodeIfPresent("meta")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encodeIfPresent(data, forKey: "data")
                try container.encodeIfPresent(links, forKey: "links")
                try container.encodeIfPresent(meta, forKey: "meta")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? CompatibleVersions else { return false }
              guard self.data == object.data else { return false }
              guard self.links == object.links else { return false }
              guard self.meta == object.meta else { return false }
              return true
            }

            public static func == (lhs: CompatibleVersions, rhs: CompatibleVersions) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(app: App? = nil, compatibleVersions: CompatibleVersions? = nil) {
            self.app = app
            self.compatibleVersions = compatibleVersions
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            app = try container.decodeIfPresent("app")
            compatibleVersions = try container.decodeIfPresent("compatibleVersions")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(app, forKey: "app")
            try container.encodeIfPresent(compatibleVersions, forKey: "compatibleVersions")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Relationships else { return false }
          guard self.app == object.app else { return false }
          guard self.compatibleVersions == object.compatibleVersions else { return false }
          return true
        }

        public static func == (lhs: Relationships, rhs: Relationships) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public init(links: ResourceLinks, id: String, type: `Type`, attributes: Attributes? = nil, relationships: Relationships? = nil) {
        self.links = links
        self.id = id
        self.type = type
        self.attributes = attributes
        self.relationships = relationships
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        links = try container.decode("links")
        id = try container.decode("id")
        type = try container.decode("type")
        attributes = try container.decodeIfPresent("attributes")
        relationships = try container.decodeIfPresent("relationships")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(links, forKey: "links")
        try container.encode(id, forKey: "id")
        try container.encode(type, forKey: "type")
        try container.encodeIfPresent(attributes, forKey: "attributes")
        try container.encodeIfPresent(relationships, forKey: "relationships")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? GameCenterEnabledVersion else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      guard self.attributes == object.attributes else { return false }
      guard self.relationships == object.relationships else { return false }
      return true
    }

    public static func == (lhs: GameCenterEnabledVersion, rhs: GameCenterEnabledVersion) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
