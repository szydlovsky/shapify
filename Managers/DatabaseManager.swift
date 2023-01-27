//
//  DatabaseManager.swift
//  Shapify
//
//  Created by Alex on 24/01/2023.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    enum DatabaseError: Error {
        case wrongFormat
        case updatingTracks
        case noNeedToInsert
        case argumentMissed
        case nothingChanged
        
        public var localizedDescription: String {
            switch self {
            case .wrongFormat, .updatingTracks, .noNeedToInsert, .argumentMissed:
                print(self)
                return "Internal error occured."
            default:
                return ""
            }
        }
    }
    
    public var shouldFetch = true
    
    static let shared = DatabaseManager()
    
    private let db = Database.database().reference()
    
    private init(){}
    
    private static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    private func doesUserExist(with email: String, completion: @escaping (Bool) -> ()) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        db.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard let _ = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func add(tracks: [Track], for userEmail: String, completion: @escaping (DatabaseError?) -> ()) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        var tracksToInsert = [[String: Any]]()
        tracks.forEach { track in
            let newSavedTrack = [
                "title": track.title,
                "subtitle": track.subtitle,
                "image": track.images?.coverart ?? (track.images?.background ?? ""),
                "link": track.externalURL ?? "",
                "date": DateFormatter.appFormatter.string(from: Date())
            ]
            tracksToInsert.append(newSavedTrack)
        }

        if tracksToInsert.isEmpty {
            completion(.noNeedToInsert)
            return
        }
        
        doesUserExist(with: safeEmail) { [weak self] exists in
            if exists {
                self?.db.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
                    guard var userTracks = snapshot.value as? [[[String: Any]]] else {
                        completion(.wrongFormat)
                        return
                    }
                    
                    userTracks.append(tracksToInsert)

                    self?.db.child(safeEmail).setValue(userTracks) { error, _ in
                        if error != nil {
                            completion(.updatingTracks)
                        }
                        self?.shouldFetch = true
                        completion(nil)
                    }
                }
            } else {
                self?.db.child(safeEmail).setValue(
                    [tracksToInsert]
                ) { error, _ in
                    if error != nil {
                        completion(.updatingTracks)
                    }
                    self?.shouldFetch = true
                    completion(nil)
                }
            }
        }
    }
    
    
    public func getAllPreviousTracks(for userEmail: String, completion: @escaping (Result<[[Track]], DatabaseError>) -> ()) {
        let safeEmail = DatabaseManager.safeEmail(emailAddress: userEmail)
        doesUserExist(with: safeEmail) { [weak self] exists in
            if exists {
                self?.db.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
                    guard var userTracks = snapshot.value as? [[[String: Any]]] else {
                        completion(.failure(.wrongFormat))
                        return
                    }
                    let tracks: [[Track]] = userTracks.compactMap { trackGroup in
                        return trackGroup.compactMap { track in
                            guard let title = track["title"] as? String, let subtitle = track["subtitle"] as? String, let link = track["link"] as? String, let image = track["image"] as? String, let date = track["date"] as? String else {
                                completion(.failure(.argumentMissed))
                                return nil
                            }
                            let images: Images? = image.isEmpty ? nil : Images(background: image, coverart: image)
                            return Track(title: title, subtitle: subtitle, externalURL: link, images: images, date: date)
                        }
                    }
                    completion(.success(tracks))
                    self?.shouldFetch = false
                }
            } else {
                completion(.success([[Track]]()))
                self?.shouldFetch = false
            }
        }
    }
}
