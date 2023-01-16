//
//  TrackResponse.swift
//  Shapify
//
//  Created by Alex on 15/01/2023.
//

import Foundation

struct Images: Codable {
    let background: String
    let coverart: String
}

struct Track: Codable {
    let title: String
    let subtitle: String
    let images: Images?
}

struct TrackResponse: Codable {
    let track: Track
}
