//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class Device: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case devices = "devices"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public var attributes: Attributes?

    public class Attributes: APIModel {

        public enum DeviceClass: String, Codable, Equatable, CaseIterable {
            case appleWatch = "APPLE_WATCH"
            case ipad = "IPAD"
            case iphone = "IPHONE"
            case ipod = "IPOD"
            case appleTv = "APPLE_TV"
            case mac = "MAC"
        }

        public enum Status: String, Codable, Equatable, CaseIterable {
            case enabled = "ENABLED"
            case disabled = "DISABLED"
        }

        public var addedDate: DateTime?

        public var deviceClass: DeviceClass?

        public var model: String?

        public var name: String?

        public var platform: BundleIdPlatform?

        public var status: Status?

        public var udid: String?

        public init(addedDate: DateTime? = nil, deviceClass: DeviceClass? = nil, model: String? = nil, name: String? = nil, platform: BundleIdPlatform? = nil, status: Status? = nil, udid: String? = nil) {
            self.addedDate = addedDate
            self.deviceClass = deviceClass
            self.model = model
            self.name = name
            self.platform = platform
            self.status = status
            self.udid = udid
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            addedDate = try container.decodeIfPresent("addedDate")
            deviceClass = try container.decodeIfPresent("deviceClass")
            model = try container.decodeIfPresent("model")
            name = try container.decodeIfPresent("name")
            platform = try container.decodeIfPresent("platform")
            status = try container.decodeIfPresent("status")
            udid = try container.decodeIfPresent("udid")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(addedDate, forKey: "addedDate")
            try container.encodeIfPresent(deviceClass, forKey: "deviceClass")
            try container.encodeIfPresent(model, forKey: "model")
            try container.encodeIfPresent(name, forKey: "name")
            try container.encodeIfPresent(platform, forKey: "platform")
            try container.encodeIfPresent(status, forKey: "status")
            try container.encodeIfPresent(udid, forKey: "udid")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Attributes else { return false }
          guard self.addedDate == object.addedDate else { return false }
          guard self.deviceClass == object.deviceClass else { return false }
          guard self.model == object.model else { return false }
          guard self.name == object.name else { return false }
          guard self.platform == object.platform else { return false }
          guard self.status == object.status else { return false }
          guard self.udid == object.udid else { return false }
          return true
        }

        public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public init(links: ResourceLinks, id: String, type: `Type`, attributes: Attributes? = nil) {
        self.links = links
        self.id = id
        self.type = type
        self.attributes = attributes
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        links = try container.decode("links")
        id = try container.decode("id")
        type = try container.decode("type")
        attributes = try container.decodeIfPresent("attributes")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(links, forKey: "links")
        try container.encode(id, forKey: "id")
        try container.encode(type, forKey: "type")
        try container.encodeIfPresent(attributes, forKey: "attributes")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? Device else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      guard self.attributes == object.attributes else { return false }
      return true
    }

    public static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
