//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

/** The base type for both Offer and Entitlement. */
public class OfferRights: APIModel {

    /** The base type for both Offer and Entitlement. */
    #if swift(>=4.2)
    public enum DeliveryType: String, Codable, Equatable, CaseIterable {
    #else
    public enum DeliveryType: String, Codable {
    #endif
        case stream = "Stream"
        case download = "Download"
        case streamOrDownload = "StreamOrDownload"
        case progressiveDownload = "ProgressiveDownload"
        case none = "None"
        #if swift(<4.2)
        public static let cases: [DeliveryType] = [
          .stream,
          .download,
          .streamOrDownload,
          .progressiveDownload,
          .none,
        ]
        #endif
    }

    /** The base type for both Offer and Entitlement. */
    #if swift(>=4.2)
    public enum Resolution: String, Codable, Equatable, CaseIterable {
    #else
    public enum Resolution: String, Codable {
    #endif
        case sd = "SD"
        case hd720 = "HD-720"
        case hd1080 = "HD-1080"
        case unknown = "Unknown"
        #if swift(<4.2)
        public static let cases: [Resolution] = [
          .sd,
          .hd720,
          .hd1080,
          .unknown,
        ]
        #endif
    }

    /** The base type for both Offer and Entitlement. */
    #if swift(>=4.2)
    public enum Ownership: String, Codable, Equatable, CaseIterable {
    #else
    public enum Ownership: String, Codable {
    #endif
        case subscription = "Subscription"
        case free = "Free"
        case rent = "Rent"
        case own = "Own"
        case none = "None"
        #if swift(<4.2)
        public static let cases: [Ownership] = [
          .subscription,
          .free,
          .rent,
          .own,
          .none,
        ]
        #endif
    }

    public var deliveryType: DeliveryType

    public var scopes: [String]

    public var resolution: Resolution

    public var ownership: Ownership

    /** Any specific playback exclusion rules. */
    public var exclusionRules: [ExclusionRule]?

    /** The maximum number of allowed downloads. */
    public var maxDownloads: Int?

    /** The maximum number of allowed plays. */
    public var maxPlays: Int?

    /** The length of time in minutes which the rental will last once played for the first time. */
    public var playPeriod: Int?

    /** The length of time in minutes which the rental will last once purchased. */
    public var rentalPeriod: Int?

    public init(deliveryType: DeliveryType, scopes: [String], resolution: Resolution, ownership: Ownership, exclusionRules: [ExclusionRule]? = nil, maxDownloads: Int? = nil, maxPlays: Int? = nil, playPeriod: Int? = nil, rentalPeriod: Int? = nil) {
        self.deliveryType = deliveryType
        self.scopes = scopes
        self.resolution = resolution
        self.ownership = ownership
        self.exclusionRules = exclusionRules
        self.maxDownloads = maxDownloads
        self.maxPlays = maxPlays
        self.playPeriod = playPeriod
        self.rentalPeriod = rentalPeriod
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StringCodingKey.self)

        deliveryType = try container.decode("deliveryType")
        scopes = try container.decodeArray("scopes")
        resolution = try container.decode("resolution")
        ownership = try container.decode("ownership")
        exclusionRules = try container.decodeArrayIfPresent("exclusionRules")
        maxDownloads = try container.decodeIfPresent("maxDownloads")
        maxPlays = try container.decodeIfPresent("maxPlays")
        playPeriod = try container.decodeIfPresent("playPeriod")
        rentalPeriod = try container.decodeIfPresent("rentalPeriod")
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: StringCodingKey.self)

        try container.encode(deliveryType, forKey: "deliveryType")
        try container.encode(scopes, forKey: "scopes")
        try container.encode(resolution, forKey: "resolution")
        try container.encode(ownership, forKey: "ownership")
        try container.encodeIfPresent(exclusionRules, forKey: "exclusionRules")
        try container.encodeIfPresent(maxDownloads, forKey: "maxDownloads")
        try container.encodeIfPresent(maxPlays, forKey: "maxPlays")
        try container.encodeIfPresent(playPeriod, forKey: "playPeriod")
        try container.encodeIfPresent(rentalPeriod, forKey: "rentalPeriod")
    }

    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? OfferRights else { return false }
      guard self.deliveryType == object.deliveryType else { return false }
      guard self.scopes == object.scopes else { return false }
      guard self.resolution == object.resolution else { return false }
      guard self.ownership == object.ownership else { return false }
      guard self.exclusionRules == object.exclusionRules else { return false }
      guard self.maxDownloads == object.maxDownloads else { return false }
      guard self.maxPlays == object.maxPlays else { return false }
      guard self.playPeriod == object.playPeriod else { return false }
      guard self.rentalPeriod == object.rentalPeriod else { return false }
      return true
    }

    public static func == (lhs: OfferRights, rhs: OfferRights) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
