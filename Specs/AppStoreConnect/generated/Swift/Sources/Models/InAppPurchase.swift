//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class InAppPurchase: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case inAppPurchases = "inAppPurchases"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public var attributes: Attributes?

    public var relationships: Relationships?

    public class Attributes: APIModel {

        public enum InAppPurchaseType: String, Codable, Equatable, CaseIterable {
            case automaticallyRenewableSubscription = "AUTOMATICALLY_RENEWABLE_SUBSCRIPTION"
            case nonConsumable = "NON_CONSUMABLE"
            case consumable = "CONSUMABLE"
            case nonRenewingSubscription = "NON_RENEWING_SUBSCRIPTION"
            case freeSubscription = "FREE_SUBSCRIPTION"
        }

        public enum State: String, Codable, Equatable, CaseIterable {
            case created = "CREATED"
            case developerSignedOff = "DEVELOPER_SIGNED_OFF"
            case developerActionNeeded = "DEVELOPER_ACTION_NEEDED"
            case deletionInProgress = "DELETION_IN_PROGRESS"
            case approved = "APPROVED"
            case deleted = "DELETED"
            case removedFromSale = "REMOVED_FROM_SALE"
            case developerRemovedFromSale = "DEVELOPER_REMOVED_FROM_SALE"
            case waitingForUpload = "WAITING_FOR_UPLOAD"
            case processingContent = "PROCESSING_CONTENT"
            case replaced = "REPLACED"
            case rejected = "REJECTED"
            case waitingForScreenshot = "WAITING_FOR_SCREENSHOT"
            case prepareForSubmission = "PREPARE_FOR_SUBMISSION"
            case missingMetadata = "MISSING_METADATA"
            case readyToSubmit = "READY_TO_SUBMIT"
            case waitingForReview = "WAITING_FOR_REVIEW"
            case inReview = "IN_REVIEW"
            case pendingDeveloperRelease = "PENDING_DEVELOPER_RELEASE"
        }

        public var inAppPurchaseType: InAppPurchaseType?

        public var productId: String?

        public var referenceName: String?

        public var state: State?

        public init(inAppPurchaseType: InAppPurchaseType? = nil, productId: String? = nil, referenceName: String? = nil, state: State? = nil) {
            self.inAppPurchaseType = inAppPurchaseType
            self.productId = productId
            self.referenceName = referenceName
            self.state = state
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            inAppPurchaseType = try container.decodeIfPresent("inAppPurchaseType")
            productId = try container.decodeIfPresent("productId")
            referenceName = try container.decodeIfPresent("referenceName")
            state = try container.decodeIfPresent("state")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(inAppPurchaseType, forKey: "inAppPurchaseType")
            try container.encodeIfPresent(productId, forKey: "productId")
            try container.encodeIfPresent(referenceName, forKey: "referenceName")
            try container.encodeIfPresent(state, forKey: "state")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Attributes else { return false }
          guard self.inAppPurchaseType == object.inAppPurchaseType else { return false }
          guard self.productId == object.productId else { return false }
          guard self.referenceName == object.referenceName else { return false }
          guard self.state == object.state else { return false }
          return true
        }

        public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public class Relationships: APIModel {

        public var apps: Apps?

        public class Apps: APIModel {

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
              guard let object = object as? Apps else { return false }
              guard self.data == object.data else { return false }
              guard self.links == object.links else { return false }
              guard self.meta == object.meta else { return false }
              return true
            }

            public static func == (lhs: Apps, rhs: Apps) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(apps: Apps? = nil) {
            self.apps = apps
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            apps = try container.decodeIfPresent("apps")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(apps, forKey: "apps")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Relationships else { return false }
          guard self.apps == object.apps else { return false }
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
      guard let object = object as? InAppPurchase else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      guard self.attributes == object.attributes else { return false }
      guard self.relationships == object.relationships else { return false }
      return true
    }

    public static func == (lhs: InAppPurchase, rhs: InAppPurchase) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
