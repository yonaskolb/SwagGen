//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class BundleIdCreateRequest: APIModel {

    public var data: DataType

    public class DataType: APIModel {

        public enum `Type`: String, Codable, Equatable, CaseIterable {
            case bundleIds = "bundleIds"
        }

        public var attributes: Attributes

        public var type: `Type`

        public class Attributes: APIModel {

            public var identifier: String

            public var name: String

            public var platform: BundleIdPlatform

            public var seedId: String?

            public init(identifier: String, name: String, platform: BundleIdPlatform, seedId: String? = nil) {
                self.identifier = identifier
                self.name = name
                self.platform = platform
                self.seedId = seedId
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                identifier = try container.decode("identifier")
                name = try container.decode("name")
                platform = try container.decode("platform")
                seedId = try container.decodeIfPresent("seedId")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encode(identifier, forKey: "identifier")
                try container.encode(name, forKey: "name")
                try container.encode(platform, forKey: "platform")
                try container.encodeIfPresent(seedId, forKey: "seedId")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Attributes else { return false }
              guard self.identifier == object.identifier else { return false }
              guard self.name == object.name else { return false }
              guard self.platform == object.platform else { return false }
              guard self.seedId == object.seedId else { return false }
              return true
            }

            public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(attributes: Attributes, type: `Type`) {
            self.attributes = attributes
            self.type = type
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            attributes = try container.decode("attributes")
            type = try container.decode("type")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encode(attributes, forKey: "attributes")
            try container.encode(type, forKey: "type")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? DataType else { return false }
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
      guard let object = object as? BundleIdCreateRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: BundleIdCreateRequest, rhs: BundleIdCreateRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
