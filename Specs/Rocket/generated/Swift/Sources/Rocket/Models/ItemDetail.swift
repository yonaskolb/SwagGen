//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation
import JSONUtilities

public class ItemDetail: ItemSummary {

    /** Advisory text about this item, related to the classification */
    public var advisoryText: String?

    /** Copyright information about this item */
    public var copyright: String?

    /** A list of credits associated with this item. */
    public var credits: [Credit]?

    /** An ordered list of custom name-value-pair item metadata.

Usually displayed on an item detail page.
 */
    public var customMetadata: [ItemCustomMetadata]?

    /** The description of this item. */
    public var description: String?

    /** The distributor of this item. */
    public var distributor: String?

    /** The full name of an episode. */
    public var episodeName: String?

    /** A list of episodes associated with this item. */
    public var episodes: ItemList?

    /** The optional date of an event.
Specific to a Program item type.
 */
    public var eventDate: Date?

    /** An array of genre paths mapping to the values within the `genres` array from ItemSummary.
 */
    public var genrePaths: [String]?

    /** The optional location (e.g. city) of an event.
Specific to a Program item type.
 */
    public var location: String?

    /** The season associated with this item. */
    public var season: ItemDetail?

    /** A list of seasons associated with this item. */
    public var seasons: ItemList?

    /** The season associated with this item. */
    public var show: ItemDetail?

    /** The total number of users who have rated this item. */
    public var totalUserRatings: Double?

    /** A list of trailers associated with this item. */
    public var trailers: [ItemSummary]?

    /** The optional venue of an event.
Specific to a Program item type.
 */
    public var venue: String?

    public init(id: String, type: ItemType, path: String, title: String, availableEpisodeCount: Int? = nil, availableSeasonCount: Int? = nil, averageUserRating: Double? = nil, badge: String? = nil, classification: ClassificationSummary? = nil, contextualTitle: String? = nil, customFields: [String: Any]? = nil, customId: String? = nil, duration: Int? = nil, episodeCount: Int? = nil, episodeNumber: Int? = nil, genres: [String]? = nil, hasClosedCaptions: Bool? = nil, images: [String: URL]? = nil, offers: [Offer]? = nil, releaseYear: Int? = nil, scopes: [String]? = nil, seasonId: String? = nil, seasonNumber: Int? = nil, shortDescription: String? = nil, showId: String? = nil, tagline: String? = nil, watchPath: String? = nil, advisoryText: String? = nil, copyright: String? = nil, credits: [Credit]? = nil, customMetadata: [ItemCustomMetadata]? = nil, description: String? = nil, distributor: String? = nil, episodeName: String? = nil, episodes: ItemList? = nil, eventDate: Date? = nil, genrePaths: [String]? = nil, location: String? = nil, season: ItemDetail? = nil, seasons: ItemList? = nil, show: ItemDetail? = nil, totalUserRatings: Double? = nil, trailers: [ItemSummary]? = nil, venue: String? = nil) {
        self.advisoryText = advisoryText
        self.copyright = copyright
        self.credits = credits
        self.customMetadata = customMetadata
        self.description = description
        self.distributor = distributor
        self.episodeName = episodeName
        self.episodes = episodes
        self.eventDate = eventDate
        self.genrePaths = genrePaths
        self.location = location
        self.season = season
        self.seasons = seasons
        self.show = show
        self.totalUserRatings = totalUserRatings
        self.trailers = trailers
        self.venue = venue
        super.init(id: id, type: type, path: path, title: title, availableEpisodeCount: availableEpisodeCount, availableSeasonCount: availableSeasonCount, averageUserRating: averageUserRating, badge: badge, classification: classification, contextualTitle: contextualTitle, customFields: customFields, customId: customId, duration: duration, episodeCount: episodeCount, episodeNumber: episodeNumber, genres: genres, hasClosedCaptions: hasClosedCaptions, images: images, offers: offers, releaseYear: releaseYear, scopes: scopes, seasonId: seasonId, seasonNumber: seasonNumber, shortDescription: shortDescription, showId: showId, tagline: tagline, watchPath: watchPath)
    }

    public required init(jsonDictionary: JSONDictionary) throws {
        advisoryText = jsonDictionary.json(atKeyPath: "advisoryText")
        copyright = jsonDictionary.json(atKeyPath: "copyright")
        credits = jsonDictionary.json(atKeyPath: "credits")
        customMetadata = jsonDictionary.json(atKeyPath: "customMetadata")
        description = jsonDictionary.json(atKeyPath: "description")
        distributor = jsonDictionary.json(atKeyPath: "distributor")
        episodeName = jsonDictionary.json(atKeyPath: "episodeName")
        episodes = jsonDictionary.json(atKeyPath: "episodes")
        eventDate = jsonDictionary.json(atKeyPath: "eventDate")
        genrePaths = jsonDictionary.json(atKeyPath: "genrePaths")
        location = jsonDictionary.json(atKeyPath: "location")
        season = jsonDictionary.json(atKeyPath: "season")
        seasons = jsonDictionary.json(atKeyPath: "seasons")
        show = jsonDictionary.json(atKeyPath: "show")
        totalUserRatings = jsonDictionary.json(atKeyPath: "totalUserRatings")
        trailers = jsonDictionary.json(atKeyPath: "trailers")
        venue = jsonDictionary.json(atKeyPath: "venue")
        try super.init(jsonDictionary: jsonDictionary)
    }

    public override func encode() -> JSONDictionary {
        var dictionary: JSONDictionary = [:]
        if let advisoryText = advisoryText {
            dictionary["advisoryText"] = advisoryText
        }
        if let copyright = copyright {
            dictionary["copyright"] = copyright
        }
        if let credits = credits?.encode() {
            dictionary["credits"] = credits
        }
        if let customMetadata = customMetadata?.encode() {
            dictionary["customMetadata"] = customMetadata
        }
        if let description = description {
            dictionary["description"] = description
        }
        if let distributor = distributor {
            dictionary["distributor"] = distributor
        }
        if let episodeName = episodeName {
            dictionary["episodeName"] = episodeName
        }
        if let episodes = episodes?.encode() {
            dictionary["episodes"] = episodes
        }
        if let eventDate = eventDate?.encode() {
            dictionary["eventDate"] = eventDate
        }
        if let genrePaths = genrePaths {
            dictionary["genrePaths"] = genrePaths
        }
        if let location = location {
            dictionary["location"] = location
        }
        if let season = season?.encode() {
            dictionary["season"] = season
        }
        if let seasons = seasons?.encode() {
            dictionary["seasons"] = seasons
        }
        if let show = show?.encode() {
            dictionary["show"] = show
        }
        if let totalUserRatings = totalUserRatings {
            dictionary["totalUserRatings"] = totalUserRatings
        }
        if let trailers = trailers?.encode() {
            dictionary["trailers"] = trailers
        }
        if let venue = venue {
            dictionary["venue"] = venue
        }
        let superDictionary = super.encode()
        for (key, value) in superDictionary {
            dictionary[key] = value
        }
        return dictionary
    }
}
