//
// Generated by SwagGen
// https://github.com/yonaskolb/SwagGen
//

import Foundation

public class Disambiguation: Codable {

    public var disambiguationOptions: [DisambiguationOption]?

    public init(disambiguationOptions: [DisambiguationOption]? = nil) {
        self.disambiguationOptions = disambiguationOptions
    }

    private enum CodingKeys: String, CodingKey {
        case disambiguationOptions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        disambiguationOptions = try container.decodeIfPresent(.disambiguationOptions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(disambiguationOptions, forKey: .disambiguationOptions)
    }
}