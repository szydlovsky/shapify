//
//  ProfileManager.swift
//  Shapify
//
//  Created by Alex on 24/01/2023.
//

import Foundation

class ProfileManager {
    
    struct Profile {
        var imageURL: String?
        var username: String
        var email: String
    }
    
    static var shared = ProfileManager()
    
    public var profile: Profile? {
        didSet {
            if let email = profile?.email, let username = profile?.username {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(username, forKey: "username")
            }
            if let imageURL = profile?.imageURL {
                UserDefaults.standard.set(imageURL, forKey: "imageURL")
            }
        }
    }
    
    private init(){}
    
    public func setProfile() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String, let username = UserDefaults.standard.value(forKey: "username") as? String else {
            return
        }
        profile = Profile(imageURL: UserDefaults.standard.value(forKey: "imageURL") as? String, username: username, email: email)
    }
}
