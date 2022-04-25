//
//  MusicLibraryResourceRequest.swift
//  MusicLibraryResourceRequest
//
//  Created by Rudrank Riyam on 02/04/22.
//

import MusicKit
import Foundation

public enum LibraryMusicItemType: String, Codable {
    case songs
    case playlists
    case albums
    case artists
    case musicVideos = "music-videos"

    public var type: String {
        "ids[\(self.rawValue)]".removingPercentEncoding!
    }
}

/// A request that your app uses to fetch items from the user's library
/// using a filter.
public struct MusicLibraryResourceRequest<MusicItemType: MusicItem & Codable> {

    /// A limit for the number of items to return
    /// in the catalog resource response.
    public var limit: Int?

    /// Creates a request to fetch all the items in alphabetical order.
    public init() {
        setType()
    }

    /// Creates a request to fetch items using a filter that matches
    /// a specific value.
    public init<Value>(matching keyPath: KeyPath<MusicItemType.FilterLibraryType, Value>, equalTo value: Value) where MusicItemType: FilterableLibraryItem {
        setType()

        if let id = value as? MusicItemID {
            self.ids = [id.rawValue]
        }
    }

    public init<Value>(matching keyPath: KeyPath<MusicItemType.FilterLibraryType, Value>,
                       equalTo value: Value,
                       relationship: MusicItemType.Relationship)
    where MusicItemType: FilterableLibraryItem & LibraryRelationshipItem {
        setType()
        
        if let relationship = relationship.rawValue as? String {
            self.relationship = relationship
        }

        if let id = value as? MusicItemID {
            self.id = id.rawValue
        }
    }

    /// Creates a request to fetch items using a filter that matches
    /// any value from an array of possible values.
    public init<Value>(matching keyPath: KeyPath<MusicItemType.FilterLibraryType, Value>, memberOf values: [Value]) where MusicItemType: FilterableLibraryItem {
        setType()

        if let ids = values as? [MusicItemID] {
            self.ids = ids.map { $0.rawValue }
        }
    }

    /// Fetches items from the user's library that match a specific filter.
    public func response() async throws -> MusicLibraryResourceResponse<MusicItemType> where MusicItemType: FilterableLibraryItem & LibraryRelationshipItem {
        let url = try libraryEndpointURL

        print(url)

        
        let request = MusicDataRequest(urlRequest: .init(url: url))
        let response = try await request.response()
        let items = try JSONDecoder().decode(MusicItemCollection<MusicItemType>.self, from: response.data)
        return MusicLibraryResourceResponse(items: items)
    }

    private var type: LibraryMusicItemType?
    private var id: String?
    private var ids: [String]?
    private var relationship: String?
}

extension Array where Element: LibraryRelationshipItem {
  func filtered<Value: Equatable>(by keyPath: KeyPath<Element, Value>, value: Value) -> [Element] {
    return Array(filter { $0[keyPath: keyPath] == value })
  }
}


extension MusicLibraryResourceRequest {
    private mutating func setType() {
        switch MusicItemType.self {
            case is Song.Type: type = .songs
            case is Album.Type: type = .albums
            case is Artist.Type: type = .artists
            case is MusicVideo.Type: type = .musicVideos
            case is Playlist.Type: type = .playlists
            default: type = nil
        }
    }

    private var libraryEndpointURL: URL {
        get throws {
            guard let type = type else { throw URLError(.badURL) }

            var components = URLComponents()
            var queryItems: [URLQueryItem]?

            components.scheme = "https"
            components.host = "api.music.apple.com"
            components.path = "/v1/me/library/"
            components.path += type.rawValue

            if let id = id {
                components.path += "/\(id)"
                if let relationship = relationship {
                    components.path += "/\(relationship)"
                }
            } else if let ids = ids {
                queryItems = [URLQueryItem(name: "ids", value: ids.joined(separator: ","))]
            } else if let limit = limit {
                queryItems = [URLQueryItem(name: "limit", value: "\(limit)")]
            }

            components.queryItems = queryItems
            

            guard let url = components.url else {
                throw URLError(.badURL)
            }

            return url
        }
    }
}
