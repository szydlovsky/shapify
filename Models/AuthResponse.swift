//
//  AuthResponse.swift
//  Shapify
//
//  Created by Alex on 25/12/2022.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Double
    let refresh_token: String?
}
