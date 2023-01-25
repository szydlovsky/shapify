//
//  ProfileManager.swift
//  Shapify
//
//  Created by Alex on 24/01/2023.
//

import Foundation

class ProfileManager {
    
    struct Profile {
        let imageURL: String?
        let username: String
        let email: String
    }
    
    static var shared = ProfileManager()
    
    public var profile: Profile?
    
    private init(){}
    
    public func signOut() {
        profile = nil
        UserDefaults.standard.set(nil, forKey: "expiration_date")
        UserDefaults.standard.set(nil, forKey: "access_token")
        UserDefaults.standard.set(nil, forKey: "refresh_token")
    }
}
