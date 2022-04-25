//
//  LibraryRelationshipItem.swift
//  LibraryRelationshipItem
//
//  Created by Rudrank Riyam on 25/04/22.
//

import MusicKit
import UniformTypeIdentifiers

public protocol LibraryRelationshipItem {
    associatedtype Relationship: RawRepresentable
}

public enum ArtistLibraryRelationship: String {
    case albums
    case catalog
}

extension Artist: LibraryRelationshipItem {
    public typealias Relationship = ArtistLibraryRelationship
}

public enum AlbumLibraryRelationship: String {
    case artists
    case catalog
    case tracks
}

extension Album: LibraryRelationshipItem {
    public typealias Relationship = AlbumLibraryRelationship
}

public enum SongLibraryRelationship: String {
    case artists
    case catalog
    case albums
}

extension Song: LibraryRelationshipItem {
    public typealias Relationship = SongLibraryRelationship
}

public enum PlaylistLibraryRelationship: String {
    case catalog
    case tracks
}

extension Playlist: LibraryRelationshipItem {
    public typealias Relationship = PlaylistLibraryRelationship
}
