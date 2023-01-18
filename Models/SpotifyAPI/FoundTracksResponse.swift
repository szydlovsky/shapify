//
//  FoundTracksResponse.swift
//  Shapify
//
//  Created by Alex on 18/01/2023.
//

import Foundation

struct ExternalURL: Codable {
    let spotify: String
}

struct Artist: Codable {
    let name: String
}

struct Image: Codable {
    let url: String
}

struct Album: Codable {
    let images: [Image]
}

struct FoundTrack: Codable {
    let external_urls: ExternalURL
    let artists: [Artist]
    let name: String
    let album: Album
}

struct FoundTracks: Codable {
    let items: [FoundTrack]
}

struct FoundTracksResponse: Codable {
    let tracks: FoundTracks
}

