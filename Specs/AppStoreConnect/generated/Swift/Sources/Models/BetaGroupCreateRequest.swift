//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BetaGroupCreateRequest: APIModel {

    public var data: DataType

    public class DataType: APIModel {

        public enum `Type`: String, Codable, Equatable, CaseIterable {
            case betaGroups = "betaGroups"
        }

        public var relationships: Relationships

        public var attributes: Attributes

        public var type: `Type`

        public class Relationships: APIModel {

            public var app: App

            public var betaTesters: BetaTesters?

            public var builds: Builds?

            public class App: APIModel {

                public var data: DataType

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

                public init(data: DataType) {
                    self.data = data
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    data = try container.decode("data")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encode(data, forKey: "data")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? App else { return false }
                  guard self.data == object.data else { return false }
                  return true
                }

                public static func == (lhs: App, rhs: App) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public class BetaTesters: APIModel {

                public var data: [DataType]?

                public class DataType: APIModel {

                    public enum `Type`: String, Codable, Equatable, CaseIterable {
                        case betaTesters = "betaTesters"
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

                public init(data: [DataType]? = nil) {
                    self.data = data
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    data = try container.decodeArrayIfPresent("data")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(data, forKey: "data")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? BetaTesters else { return false }
                  guard self.data == object.data else { return false }
                  return true
                }

                public static func == (lhs: BetaTesters, rhs: BetaTesters) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public class Builds: APIModel {

                public var data: [DataType]?

                public class DataType: APIModel {

                    public enum `Type`: String, Codable, Equatable, CaseIterable {
                        case builds = "builds"
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

                public init(data: [DataType]? = nil) {
                    self.data = data
                }

                public required init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: StringCodingKey.self)

                    data = try container.decodeArrayIfPresent("data")
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: StringCodingKey.self)

                    try container.encodeIfPresent(data, forKey: "data")
                }

                public func isEqual(to object: Any?) -> Bool {
                  guard let object = object as? Builds else { return false }
                  guard self.data == object.data else { return false }
                  return true
                }

                public static func == (lhs: Builds, rhs: Builds) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public init(app: App, betaTesters: BetaTesters? = nil, builds: Builds? = nil) {
                self.app = app
                self.betaTesters = betaTesters
                self.builds = builds
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                app = try container.decode("app")
                betaTesters = try container.decodeIfPresent("betaTesters")
                builds = try container.decodeIfPresent("builds")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encode(app, forKey: "app")
                try container.encodeIfPresent(betaTesters, forKey: "betaTesters")
                try container.encodeIfPresent(builds, forKey: "builds")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Relationships else { return false }
              guard self.app == object.app else { return false }
              guard self.betaTesters == object.betaTesters else { return false }
              guard self.builds == object.builds else { return false }
              return true
            }

            public static func == (lhs: Relationships, rhs: Relationships) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public class Attributes: APIModel {

            public var name: String

            public var feedbackEnabled: Bool?

            public var publicLinkEnabled: Bool?

            public var publicLinkLimit: Int?

            public var publicLinkLimitEnabled: Bool?

            public init(name: String, feedbackEnabled: Bool? = nil, publicLinkEnabled: Bool? = nil, publicLinkLimit: Int? = nil, publicLinkLimitEnabled: Bool? = nil) {
                self.name = name
                self.feedbackEnabled = feedbackEnabled
                self.publicLinkEnabled = publicLinkEnabled
                self.publicLinkLimit = publicLinkLimit
                self.publicLinkLimitEnabled = publicLinkLimitEnabled
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                name = try container.decode("name")
                feedbackEnabled = try container.decodeIfPresent("feedbackEnabled")
                publicLinkEnabled = try container.decodeIfPresent("publicLinkEnabled")
                publicLinkLimit = try container.decodeIfPresent("publicLinkLimit")
                publicLinkLimitEnabled = try container.decodeIfPresent("publicLinkLimitEnabled")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encode(name, forKey: "name")
                try container.encodeIfPresent(feedbackEnabled, forKey: "feedbackEnabled")
                try container.encodeIfPresent(publicLinkEnabled, forKey: "publicLinkEnabled")
                try container.encodeIfPresent(publicLinkLimit, forKey: "publicLinkLimit")
                try container.encodeIfPresent(publicLinkLimitEnabled, forKey: "publicLinkLimitEnabled")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Attributes else { return false }
              guard self.name == object.name else { return false }
              guard self.feedbackEnabled == object.feedbackEnabled else { return false }
              guard self.publicLinkEnabled == object.publicLinkEnabled else { return false }
              guard self.publicLinkLimit == object.publicLinkLimit else { return false }
              guard self.publicLinkLimitEnabled == object.publicLinkLimitEnabled else { return false }
              return true
            }

            public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(relationships: Relationships, attributes: Attributes, type: `Type`) {
            self.relationships = relationships
            self.attributes = attributes
            self.type = type
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            relationships = try container.decode("relationships")
            attributes = try container.decode("attributes")
            type = try container.decode("type")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encode(relationships, forKey: "relationships")
            try container.encode(attributes, forKey: "attributes")
            try container.encode(type, forKey: "type")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? DataType else { return false }
          guard self.relationships == object.relationships else { return false }
          guard self.attributes == object.attributes else { return false }
          guard self.type == object.type else { return false }
          return true
        }

        public static func == (lhs: DataType, rhs: DataType) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public init(data: DataType) {
        self.data = data
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decode("data")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(data, forKey: "data")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? BetaGroupCreateRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: BetaGroupCreateRequest, rhs: BetaGroupCreateRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
