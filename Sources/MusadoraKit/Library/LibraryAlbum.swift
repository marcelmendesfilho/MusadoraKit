//
//  LibraryAlbum.swift
//  LibraryAlbum
//
//  Created by Rudrank Riyam on 14/08/21.
//

import MusicKit

public extension MusadoraKit {

    /// Fetch an album from the user's library by using its identifier.
    /// - Parameters:
    ///   - id: The unique identifier for the album.
    /// - Returns: `Album` matching the given identifier.
    static func libraryAlbum(id: MusicItemID) async throws -> Album {
        let request = MusicLibraryResourceRequest<Album>(matching: \.id, equalTo: id)
        let response = try await request.response()

        guard let album = response.items.first else {
            throw MusadoraKitError.notFound(for: id.rawValue)
        }
        return album
    }

    /// Fetch all albums from the user's library in alphabetical order.
    /// - Parameters:
    ///   - limit: The number of albums returned.
    /// - Returns: `Albums` for the given limit.
    static func libraryAlbums(limit: Int? = nil) async throws -> Albums {
        var request = MusicLibraryResourceRequest<Album>()
        request.limit = limit
        let response = try await request.response()
        return response.items
    }

    /// Fetch multiple albums from the user's library by using their identifiers.
    /// - Parameters:
    ///   - ids: The unique identifiers for the albums.
    /// - Returns: `Albums` matching the given identifiers.
    static func libraryAlbums(ids: [MusicItemID]) async throws -> Albums {
        let request = MusicLibraryResourceRequest<Album>(matching: \.id, memberOf: ids)
        let response = try await request.response()
        return response.items
    }
    
    /// Add an album to the user's library by using its identifier.
    /// - Parameters:
    ///   - id: The unique identifier for the albums.
    /// - Returns: `Bool` indicating if the insert was successfull or not.
    static func addAlbumToLibrary(id: String) async throws -> Bool{
        let request = MusicAddResourcesRequest(types: [.albums:[MusicItemID(id)]])
        let response = try await request.response()
        
        return response
    }
    
    /// Add multiple albums to the user's library by using their identifiers.
    /// - Parameters:
    ///   - ids: The unique identifiers for the albums.
    /// - Returns: `Bool` indicating if the insert was successfull or not.
    static func addAlbumToLibrary(ids: [String]) async throws -> Bool{
        var musicItemIDs = [MusicItemID]()
        ids.forEach { id in
            musicItemIDs.append(MusicItemID(id))
        }
        let request = MusicAddResourcesRequest(types: [.albums:musicItemIDs])
        let response = try await request.response()
        
        return response
    }

}
