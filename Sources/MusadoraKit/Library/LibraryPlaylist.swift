//
//  LibraryPlaylist.swift
//  LibraryPlaylist
//
//  Created by Rudrank Riyam on 14/08/21.
//

import MusicKit

public extension MusadoraKit {

    /// Fetch a playlist from the user's library by using its identifier.
    /// - Parameters:
    ///   - id: The unique identifier for the playlist.
    /// - Returns: `Playlist` matching the given identifier.
    static func libraryPlaylist(id: MusicItemID) async throws -> Playlist {
        let request = MusicLibraryResourceRequest<Playlist>(matching: \.id, equalTo: id)
        let response = try await request.response()

        guard let playlist = response.items.first else {
            throw MusadoraKitError.notFound(for: id.rawValue)
        }
        return playlist
    }

    /// Fetch all playlists from the user's library in alphabetical order.
    /// - Parameters:
    ///   - limit: The number of playlists returned.
    /// - Returns: `Playlists` for the given limit.
    static func libraryPlaylists(limit: Int? = nil) async throws -> Playlists {
        var request = MusicLibraryResourceRequest<Playlist>()
        request.limit = limit
        let response = try await request.response()
        return response.items
    }

    /// Fetch multiple playlists from the user's library by using their identifiers.
    /// - Parameters:
    ///   - ids: The unique identifiers for the playlists.
    /// - Returns: `Playlists` matching the given identifiers.
    static func libraryPlaylists(ids: [MusicItemID]) async throws -> Playlists {
        let request = MusicLibraryResourceRequest<Playlist>(matching: \.id, memberOf: ids)
        let response = try await request.response()
        return response.items
    }
}
