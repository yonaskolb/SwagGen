//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BetaTesterCreateRequest: APIModel {

    public var data: DataType

    public class DataType: APIModel {

        public enum `Type`: String, Codable, Equatable, CaseIterable {
            case betaTesters = "betaTesters"
        }

        public var attributes: Attributes

        public var type: `Type`

        public var relationships: Relationships?

        public class Attributes: APIModel {

            public var email: String

            public var firstName: String?

            public var lastName: String?

            public init(email: String, firstName: String? = nil, lastName: String? = nil) {
                self.email = email
                self.firstName = firstName
                self.lastName = lastName
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                email = try container.decode("email")
                firstName = try container.decodeIfPresent("firstName")
                lastName = try container.decodeIfPresent("lastName")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encode(email, forKey: "email")
                try container.encodeIfPresent(firstName, forKey: "firstName")
                try container.encodeIfPresent(lastName, forKey: "lastName")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Attributes else { return false }
              guard self.email == object.email else { return false }
              guard self.firstName == object.firstName else { return false }
              guard self.lastName == object.lastName else { return false }
              return true
            }

            public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public class Relationships: APIModel {

            public var betaGroups: BetaGroups?

            public var builds: Builds?

            public class BetaGroups: APIModel {

                public var data: [DataType]?

                public class DataType: APIModel {

                    public enum `Type`: String, Codable, Equatable, CaseIterable {
                        case betaGroups = "betaGroups"
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
                  guard let object = object as? BetaGroups else { return false }
                  guard self.data == object.data else { return false }
                  return true
                }

                public static func == (lhs: BetaGroups, rhs: BetaGroups) -> Bool {
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

            public init(betaGroups: BetaGroups? = nil, builds: Builds? = nil) {
                self.betaGroups = betaGroups
                self.builds = builds
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                betaGroups = try container.decodeIfPresent("betaGroups")
                builds = try container.decodeIfPresent("builds")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encodeIfPresent(betaGroups, forKey: "betaGroups")
                try container.encodeIfPresent(builds, forKey: "builds")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Relationships else { return false }
              guard self.betaGroups == object.betaGroups else { return false }
              guard self.builds == object.builds else { return false }
              return true
            }

            public static func == (lhs: Relationships, rhs: Relationships) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(attributes: Attributes, type: `Type`, relationships: Relationships? = nil) {
            self.attributes = attributes
            self.type = type
            self.relationships = relationships
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            attributes = try container.decode("attributes")
            type = try container.decode("type")
            relationships = try container.decodeIfPresent("relationships")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encode(attributes, forKey: "attributes")
            try container.encode(type, forKey: "type")
            try container.encodeIfPresent(relationships, forKey: "relationships")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? DataType else { return false }
          guard self.attributes == object.attributes else { return false }
          guard self.type == object.type else { return false }
          guard self.relationships == object.relationships else { return false }
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
      guard let object = object as? BetaTesterCreateRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: BetaTesterCreateRequest, rhs: BetaTesterCreateRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
