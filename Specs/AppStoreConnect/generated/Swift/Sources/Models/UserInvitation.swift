//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class UserInvitation: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case userInvitations = "userInvitations"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public var attributes: Attributes?

    public var relationships: Relationships?

    public class Attributes: APIModel {

        public var allAppsVisible: Bool?

        public var email: String?

        public var expirationDate: DateTime?

        public var firstName: String?

        public var lastName: String?

        public var provisioningAllowed: Bool?

        public var roles: [UserRole]?

        public init(allAppsVisible: Bool? = nil, email: String? = nil, expirationDate: DateTime? = nil, firstName: String? = nil, lastName: String? = nil, provisioningAllowed: Bool? = nil, roles: [UserRole]? = nil) {
            self.allAppsVisible = allAppsVisible
            self.email = email
            self.expirationDate = expirationDate
            self.firstName = firstName
            self.lastName = lastName
            self.provisioningAllowed = provisioningAllowed
            self.roles = roles
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            allAppsVisible = try container.decodeIfPresent("allAppsVisible")
            email = try container.decodeIfPresent("email")
            expirationDate = try container.decodeIfPresent("expirationDate")
            firstName = try container.decodeIfPresent("firstName")
            lastName = try container.decodeIfPresent("lastName")
            provisioningAllowed = try container.decodeIfPresent("provisioningAllowed")
            roles = try container.decodeArrayIfPresent("roles")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(allAppsVisible, forKey: "allAppsVisible")
            try container.encodeIfPresent(email, forKey: "email")
            try container.encodeIfPresent(expirationDate, forKey: "expirationDate")
            try container.encodeIfPresent(firstName, forKey: "firstName")
            try container.encodeIfPresent(lastName, forKey: "lastName")
            try container.encodeIfPresent(provisioningAllowed, forKey: "provisioningAllowed")
            try container.encodeIfPresent(roles, forKey: "roles")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Attributes else { return false }
          guard self.allAppsVisible == object.allAppsVisible else { return false }
          guard self.email == object.email else { return false }
          guard self.expirationDate == object.expirationDate else { return false }
          guard self.firstName == object.firstName else { return false }
          guard self.lastName == object.lastName else { return false }
          guard self.provisioningAllowed == object.provisioningAllowed else { return false }
          guard self.roles == object.roles else { return false }
          return true
        }

        public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public class Relationships: APIModel {

        public var visibleApps: VisibleApps?

        public class VisibleApps: APIModel {

            public var data: [DataType]?

            public var links: Links?

            public var meta: PagingInformation?

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
              guard let object = object as? VisibleApps else { return false }
              guard self.data == object.data else { return false }
              guard self.links == object.links else { return false }
              guard self.meta == object.meta else { return false }
              return true
            }

            public static func == (lhs: VisibleApps, rhs: VisibleApps) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(visibleApps: VisibleApps? = nil) {
            self.visibleApps = visibleApps
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            visibleApps = try container.decodeIfPresent("visibleApps")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(visibleApps, forKey: "visibleApps")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Relationships else { return false }
          guard self.visibleApps == object.visibleApps else { return false }
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
      guard let object = object as? UserInvitation else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      guard self.attributes == object.attributes else { return false }
      guard self.relationships == object.relationships else { return false }
      return true
    }

    public static func == (lhs: UserInvitation, rhs: UserInvitation) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
