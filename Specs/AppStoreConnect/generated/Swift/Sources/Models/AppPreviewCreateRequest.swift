//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class AppPreviewCreateRequest: APIModel {

    public var data: DataType

    public class DataType: APIModel {

        public enum `Type`: String, Codable, Equatable, CaseIterable {
            case appPreviews = "appPreviews"
        }

        public var relationships: Relationships

        public var attributes: Attributes

        public var type: `Type`

        public class Relationships: APIModel {

            public var appPreviewSet: AppPreviewSet

            public class AppPreviewSet: APIModel {

                public var data: DataType

                public class DataType: APIModel {

                    public enum `Type`: String, Codable, Equatable, CaseIterable {
                        case appPreviewSets = "appPreviewSets"
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
                  guard let object = object as? AppPreviewSet else { return false }
                  guard self.data == object.data else { return false }
                  return true
                }

                public static func == (lhs: AppPreviewSet, rhs: AppPreviewSet) -> Bool {
                    return lhs.isEqual(to: rhs)
                }
            }

            public init(appPreviewSet: AppPreviewSet) {
                self.appPreviewSet = appPreviewSet
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                appPreviewSet = try container.decode("appPreviewSet")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encode(appPreviewSet, forKey: "appPreviewSet")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Relationships else { return false }
              guard self.appPreviewSet == object.appPreviewSet else { return false }
              return true
            }

            public static func == (lhs: Relationships, rhs: Relationships) -> Bool {
                return lhs.isEqual(to: rhs)
            }
        }

        public class Attributes: APIModel {

            public var fileName: String

            public var fileSize: Int

            public var mimeType: String?

            public var previewFrameTimeCode: String?

            public init(fileName: String, fileSize: Int, mimeType: String? = nil, previewFrameTimeCode: String? = nil) {
                self.fileName = fileName
                self.fileSize = fileSize
                self.mimeType = mimeType
                self.previewFrameTimeCode = previewFrameTimeCode
            }

            public required init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: StringCodingKey.self)

                fileName = try container.decode("fileName")
                fileSize = try container.decode("fileSize")
                mimeType = try container.decodeIfPresent("mimeType")
                previewFrameTimeCode = try container.decodeIfPresent("previewFrameTimeCode")
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: StringCodingKey.self)

                try container.encode(fileName, forKey: "fileName")
                try container.encode(fileSize, forKey: "fileSize")
                try container.encodeIfPresent(mimeType, forKey: "mimeType")
                try container.encodeIfPresent(previewFrameTimeCode, forKey: "previewFrameTimeCode")
            }

            public func isEqual(to object: Any?) -> Bool {
              guard let object = object as? Attributes else { return false }
              guard self.fileName == object.fileName else { return false }
              guard self.fileSize == object.fileSize else { return false }
              guard self.mimeType == object.mimeType else { return false }
              guard self.previewFrameTimeCode == object.previewFrameTimeCode else { return false }
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
      guard let object = object as? AppPreviewCreateRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: AppPreviewCreateRequest, rhs: AppPreviewCreateRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
