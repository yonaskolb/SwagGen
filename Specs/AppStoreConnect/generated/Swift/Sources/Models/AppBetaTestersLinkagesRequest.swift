//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class AppBetaTestersLinkagesRequest: APIModel {

    public var data: [DataType]

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

    public init(data: [DataType]) {
        self.data = data
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        data = try container.decodeArray("data")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(data, forKey: "data")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? AppBetaTestersLinkagesRequest else { return false }
      guard self.data == object.data else { return false }
      return true
    }

    public static func == (lhs: AppBetaTestersLinkagesRequest, rhs: AppBetaTestersLinkagesRequest) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
