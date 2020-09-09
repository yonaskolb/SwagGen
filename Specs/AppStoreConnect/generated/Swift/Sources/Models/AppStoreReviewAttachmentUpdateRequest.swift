//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class AppStoreReviewAttachmentUpdateRequest: APIModel {

    public var data: DataType

    public class DataType: APIModel {

        public enum `Type`: String, Codable, Equatable, CaseIterable {
            case appStoreReviewAttachments = "appStoreReviewAttachments"
        }

        public var id: String

        public var type: `Type`

        public var attributes: Attributes?

        public class Attributes: APIModel {

            public var sourceFileChecksum: String?

            public var uploaded: Bool?

            public init(sourceFileChecksum: String? = nil, uploaded: Bool? = nil) {
                self.sourceFileChecksum = sourceFileChecksum
                self.uploaded = uploaded
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                sourceFileChecksum = try container.decodeIfPresent("sourceFileChecksum")
                uploaded = try container.decodeIfPresent("uploaded")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encodeIfPresent(sourceFileChecksum, forKey: "sourceFileChecksum")
                try container.encodeIfPresent(uploaded, forKey: "uploaded")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Attributes else { return false }
              guard self.sourceFileChecksum == object.sourceFileChecksum else { return false }
              guard self.uploaded == object.uploaded else { return false }
              return true
            }

            public static func == (lhs: Attributes, rhs: Attributes) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public init(id: String, type: `Type`, attributes: Attributes? = nil) {
            self.id = id
            self.type = type
            self.attributes = attributes
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            id = try container.decode("id")
            type = try container.decode("type")
            attributes = try container.decodeIfPresent("attributes")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encode(id, forKey: "id")
            try container.encode(type, forKey: "type")
            try container.encodeIfPresent(attributes, forKey: "attributes")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? DataType else { return false }
          guard self.id == object.id else { return false }
          guard self.type == object.type else { return false }
          guard self.attributes == object.attributes else { return false }
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
      guard let object = object as? AppStoreReviewAttachmentUpdateRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: AppStoreReviewAttachmentUpdateRequest, rhs: AppStoreReviewAttachmentUpdateRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
