import Foundation
import JSONUtilities

public struct Content {
    public let mediaItems: [String: MediaItem]

    public enum MediaType: String {
        case json = "application/json"
        case form = "application/x-www-form-urlencoded"
        case xml = "application/xml"
        case multipartForm = "multipart/form-data"
        case text = "text/plain"
    }

    public func getMediaItem(_ type: MediaType) -> MediaItem? {
        return mediaItems[type.rawValue] ?? mediaItems.first { type.rawValue.contains($0.key.replacingOccurrences(of: "*", with: "")) }?.value
    }

    public var jsonSchema: Schema? {
        return getMediaItem(.json)?.schema.value
    }

    public var formSchema: Schema? {
        return getMediaItem(.form)?.schema.value
    }

    public var multipartFormSchema: Schema? {
        return getMediaItem(.multipartForm)?.schema.value
    }

    public var xmlSchema: Schema? {
        return getMediaItem(.xml)?.schema.value
    }
}

extension Content: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        var mediaItems: [String: MediaItem] = [:]
        for key in jsonDictionary.keys {
            let mediaItem: MediaItem = try jsonDictionary.json(atKeyPath: .key(key))
            mediaItems[key] = mediaItem
        }
        self.mediaItems = mediaItems
    }
}

public struct MediaItem {
    public let schema: PossibleReference<Schema>
}

extension MediaItem: JSONObjectConvertible {

    public init(jsonDictionary: JSONDictionary) throws {
        schema = try jsonDictionary.json(atKeyPath: "schema")
    }
}
