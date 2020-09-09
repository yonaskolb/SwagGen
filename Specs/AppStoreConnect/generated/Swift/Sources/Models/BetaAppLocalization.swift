//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BetaAppLocalization: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case betaAppLocalizations = "betaAppLocalizations"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public var attributes: Attributes?

    public var relationships: Relationships?

    public class Attributes: APIModel {

        public var description: String?

        public var feedbackEmail: String?

        public var locale: String?

        public var marketingUrl: String?

        public var privacyPolicyUrl: String?

        public var tvOsPrivacyPolicy: String?

        public init(description: String? = nil, feedbackEmail: String? = nil, locale: String? = nil, marketingUrl: String? = nil, privacyPolicyUrl: String? = nil, tvOsPrivacyPolicy: String? = nil) {
            self.description = description
            self.feedbackEmail = feedbackEmail
            self.locale = locale
            self.marketingUrl = marketingUrl
            self.privacyPolicyUrl = privacyPolicyUrl
            self.tvOsPrivacyPolicy = tvOsPrivacyPolicy
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            description = try container.decodeIfPresent("description")
            feedbackEmail = try container.decodeIfPresent("feedbackEmail")
            locale = try container.decodeIfPresent("locale")
            marketingUrl = try container.decodeIfPresent("marketingUrl")
            privacyPolicyUrl = try container.decodeIfPresent("privacyPolicyUrl")
            tvOsPrivacyPolicy = try container.decodeIfPresent("tvOsPrivacyPolicy")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(description, forKey: "description")
            try container.encodeIfPresent(feedbackEmail, forKey: "feedbackEmail")
            try container.encodeIfPresent(locale, forKey: "locale")
            try container.encodeIfPresent(marketingUrl, forKey: "marketingUrl")
            try container.encodeIfPresent(privacyPolicyUrl, forKey: "privacyPolicyUrl")
            try container.encodeIfPresent(tvOsPrivacyPolicy, forKey: "tvOsPrivacyPolicy")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Attributes else { return false }
          guard self.description == object.description else { return false }
          guard self.feedbackEmail == object.feedbackEmail else { return false }
          guard self.locale == object.locale else { return false }
          guard self.marketingUrl == object.marketingUrl else { return false }
          guard self.privacyPolicyUrl == object.privacyPolicyUrl else { return false }
          guard self.tvOsPrivacyPolicy == object.tvOsPrivacyPolicy else { return false }
          return true
        }

        public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public class Relationships: APIModel {

        public var app: App?

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

                public var `self`: String?

                public init(related: String? = nil, `self`: String? = nil) {
                    self.related = related
                    self.`self` = `self`
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    related = try container.decodeIfPresent("related")
                    `self` = try container.decodeIfPresent("self")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(related, forKey: "related")
                    try container.encodeIfPresent(`self`, forKey: "self")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? Links else { return false }
                  guard self.related == object.related else { return false }
                  guard self.`self` == object.`self` else { return false }
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

        public init(app: App? = nil) {
            self.app = app
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            app = try container.decodeIfPresent("app")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(app, forKey: "app")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Relationships else { return false }
          guard self.app == object.app else { return false }
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
      guard let object = object as? BetaAppLocalization else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      guard self.attributes == object.attributes else { return false }
      guard self.relationships == object.relationships else { return false }
      return true
    }

    public static func == (lhs: BetaAppLocalization, rhs: BetaAppLocalization) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
