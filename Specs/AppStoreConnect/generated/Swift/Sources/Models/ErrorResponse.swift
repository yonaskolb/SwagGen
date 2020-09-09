//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class ErrorResponse: APIModel {

    public var errors: [Errors]?

    public class Errors: APIModel {

        public var code: String

        public var detail: String

        public var title: String

        public var status: String

        public var id: String?

        public var source: Source?

        public init(code: String, detail: String, title: String, status: String, id: String? = nil, source: Source? = nil) {
            self.code = code
            self.detail = detail
            self.title = title
            self.status = status
            self.id = id
            self.source = source
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: StringCodingKey.self)

            code = try container.decode("code")
            detail = try container.decode("detail")
            title = try container.decode("title")
            status = try container.decode("status")
            id = try container.decodeIfPresent("id")
            source = try container.decodeIfPresent("source")
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: StringCodingKey.self)

            try container.encode(code, forKey: "code")
            try container.encode(detail, forKey: "detail")
            try container.encode(title, forKey: "title")
            try container.encode(status, forKey: "status")
            try container.encodeIfPresent(id, forKey: "id")
            try container.encodeIfPresent(source, forKey: "source")
        }

        public func isEqual(to object: Any?) -> Bool {
          guard let object = object as? Errors else { return false }
          guard self.code == object.code else { return false }
          guard self.detail == object.detail else { return false }
          guard self.title == object.title else { return false }
          guard self.status == object.status else { return false }
          guard self.id == object.id else { return false }
          guard self.source == object.source else { return false }
          return true
        }

        public static func == (lhs: Errors, rhs: Errors) -> Bool {
            return lhs.isEqual(to: rhs)
        }
    }

    public init(errors: [Errors]? = nil) {
        self.errors = errors
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        errors = try container.decodeArrayIfPresent("errors")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encodeIfPresent(errors, forKey: "errors")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? ErrorResponse else { return false }
      guard self.errors == object.errors else { return false }
      return true
    }

    public static func == (lhs: ErrorResponse, rhs: ErrorResponse) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
