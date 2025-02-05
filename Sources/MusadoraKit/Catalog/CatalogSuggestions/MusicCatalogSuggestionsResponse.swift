//
//  MusicCatalogSuggestionsResponse.swift
//  MusicCatalogSuggestionsResponse
//
//  Created by Rudrank Riyam on 09/04/22.
//

import MusicKit
import Foundation

/// An object that contains results for a catalog suggestions request.
@available(iOS 15.4, macOS 12.3, tvOS 15.4, *)
@available(watchOS, unavailable)
public struct MusicCatalogSuggestionsResponse {

    /// A collection of search and display terms.
    public var terms: [TermSuggestion] = []

    /// A collection of different top results.
    public var topResults: [TopResultsSuggestion] = []
}

@available(iOS 15.4, macOS 12.3, tvOS 15.4, *)
@available(watchOS, unavailable)
extension MusicCatalogSuggestionsResponse: Codable {
    private enum CodingKeys: String, CodingKey {
        case suggestions
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let suggestions = try container.decode([SuggestionKind].self, forKey: .suggestions)

        for suggestion in suggestions {
            switch suggestion {
                case .terms(let term):
                    terms.append(term)

                case .topResults(let topResult):
                    topResults.append(topResult)
            }
        }
    }

    public func encode(to encoder: Encoder) throws {}
}
