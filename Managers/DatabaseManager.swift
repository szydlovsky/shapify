//
//  DatabaseManager.swift
//  Shapify
//
//  Created by Alex on 24/01/2023.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let db = Database.database().reference()
    
    private init(){}
    
    private static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    // TODO
    public func add(track: Track, for userEmail: String) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
    }
}
