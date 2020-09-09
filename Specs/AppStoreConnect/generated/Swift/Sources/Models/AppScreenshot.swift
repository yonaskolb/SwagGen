//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class AppScreenshot: APIModel {

    public enum `Type`: String, Codable, Equatable, CaseIterable {
        case appScreenshots = "appScreenshots"
    }

    public var links: ResourceLinks

    public var id: String

    public var type: `Type`

    public var attributes: Attributes?

    public var relationships: Relationships?

    public class Attributes: APIModel {

        public var assetDeliveryState: AppMediaAssetState?

        public var assetToken: String?

        public var assetType: String?

        public var fileName: String?

        public var fileSize: Int?

        public var imageAsset: ImageAsset?

        public var sourceFileChecksum: String?

        public var uploadOperations: [UploadOperation]?

        public init(assetDeliveryState: AppMediaAssetState? = nil, assetToken: String? = nil, assetType: String? = nil, fileName: String? = nil, fileSize: Int? = nil, imageAsset: ImageAsset? = nil, sourceFileChecksum: String? = nil, uploadOperations: [UploadOperation]? = nil) {
            self.assetDeliveryState = assetDeliveryState
            self.assetToken = assetToken
            self.assetType = assetType
            self.fileName = fileName
            self.fileSize = fileSize
            self.imageAsset = imageAsset
            self.sourceFileChecksum = sourceFileChecksum
            self.uploadOperations = uploadOperations
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            assetDeliveryState = try container.decodeIfPresent("assetDeliveryState")
            assetToken = try container.decodeIfPresent("assetToken")
            assetType = try container.decodeIfPresent("assetType")
            fileName = try container.decodeIfPresent("fileName")
            fileSize = try container.decodeIfPresent("fileSize")
            imageAsset = try container.decodeIfPresent("imageAsset")
            sourceFileChecksum = try container.decodeIfPresent("sourceFileChecksum")
            uploadOperations = try container.decodeArrayIfPresent("uploadOperations")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(assetDeliveryState, forKey: "assetDeliveryState")
            try container.encodeIfPresent(assetToken, forKey: "assetToken")
            try container.encodeIfPresent(assetType, forKey: "assetType")
            try container.encodeIfPresent(fileName, forKey: "fileName")
            try container.encodeIfPresent(fileSize, forKey: "fileSize")
            try container.encodeIfPresent(imageAsset, forKey: "imageAsset")
            try container.encodeIfPresent(sourceFileChecksum, forKey: "sourceFileChecksum")
            try container.encodeIfPresent(uploadOperations, forKey: "uploadOperations")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Attributes else { return false }
          guard self.assetDeliveryState == object.assetDeliveryState else { return false }
          guard self.assetToken == object.assetToken else { return false }
          guard self.assetType == object.assetType else { return false }
          guard self.fileName == object.fileName else { return false }
          guard self.fileSize == object.fileSize else { return false }
          guard self.imageAsset == object.imageAsset else { return false }
          guard self.sourceFileChecksum == object.sourceFileChecksum else { return false }
          guard self.uploadOperations == object.uploadOperations else { return false }
          return true
        }

        public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public class Relationships: APIModel {

        public var appScreenshotSet: AppScreenshotSet?

        public class AppScreenshotSet: APIModel {

            public var data: DataType?

            public var links: Links?

            public class DataType: APIModel {

                public enum `Type`: String, Codable, Equatable, CaseIterable {
                    case appScreenshotSets = "appScreenshotSets"
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
              guard let object = object as? AppScreenshotSet else { return false }
              guard self.data == object.data else { return false }
              guard self.links == object.links else { return false }
              return true
            }

            public static func == (lhs: AppScreenshotSet, rhs: AppScreenshotSet) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(appScreenshotSet: AppScreenshotSet? = nil) {
            self.appScreenshotSet = appScreenshotSet
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            appScreenshotSet = try container.decodeIfPresent("appScreenshotSet")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encodeIfPresent(appScreenshotSet, forKey: "appScreenshotSet")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Relationships else { return false }
          guard self.appScreenshotSet == object.appScreenshotSet else { return false }
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
      guard let object = object as? AppScreenshot else { return false }
      guard self.links == object.links else { return false }
      guard self.id == object.id else { return false }
      guard self.type == object.type else { return false }
      guard self.attributes == object.attributes else { return false }
      guard self.relationships == object.relationships else { return false }
      return true
    }

    public static func == (lhs: AppScreenshot, rhs: AppScreenshot) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
