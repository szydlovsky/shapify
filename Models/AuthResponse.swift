//
//  AuthResponse.swift
//  Shapify

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Double
    let refresh_token: String?
}
