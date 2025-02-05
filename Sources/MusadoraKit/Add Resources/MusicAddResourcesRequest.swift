//
//  MusicAddResourcesRequest.swift
//  MusicAddResourcesRequest
//
//  Created by Rudrank Riyam on 23/04/22.
//

import Foundation
import MusicKit

/// A request that your app uses to add one or more catalog resources to a user’s iCloud Music Library.
/// You can add multiple types in the same request.
public struct MusicAddResourcesRequest {
    private var types: [LibraryMusicItemType: [MusicItemID]]

    /// Creates a request to add multiple resources to the user's iCloud Music Library using their identifiers.
    public init(types: [LibraryMusicItemType: [MusicItemID]]) {
        self.types = types
    }

    /// Adds the given types to the user's iCloud Music Library and returns a successful/failure response.
    public func response() async throws -> Bool {
        let url = try addResourcesEndpointURL
        let request = MusicDataPostRequest(url: url)
        let response = try await request.response()
        return response.urlResponse.statusCode == 202
    }
}

extension MusicAddResourcesRequest {
    internal var addResourcesEndpointURL: URL {
        get throws {
            var components = URLComponents()
            var queryItems: [URLQueryItem] = []

            components.scheme = "https"
            components.host = "api.music.apple.com"
            components.path = "/v1/me/library"

            for (key, value) in types {
                let values = value.map { $0.rawValue }.joined(separator: ",")
                queryItems.append(URLQueryItem(name: key.type, value: values))
            }

            components.queryItems = queryItems

            guard let url = components.url else {
                throw URLError(.badURL)
            }
            return url
        }
    }
}
