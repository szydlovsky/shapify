//
//  ProfileResponse.swift
//  Shapify
//
//  Created by Alex on 24/01/2023.
//

import Foundation

struct ProfileResponse: Codable {
    let email: String
    let display_name: String
    let images: [Image]
}
