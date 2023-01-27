//
//  APICaller.swift
//  Shapify
//
//  Created by Alex on 18/01/2023.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init(){}
    
    struct K {
        static let baseURL = "https://api.spotify.com/v1/"
    }
    
    enum NetworkingError: Error {
        case invalidURL
        case gettingData
        case decoding
        case encodingParameters
        case requestInit
        case trackNotFound
        
        public var localizedDescription: String {
            switch self {
            case .invalidURL, .decoding, .encodingParameters, .requestInit:
                print(self)
                return "Internal error occured."
            case .gettingData:
                return "Connection error occured."
            case .trackNotFound:
                return "No track(s) found."
            }
        }
    }
    
    public func recognizeTrack(using input: Data, completion: @escaping (Result<Track, NetworkingError>) -> ()) {
        let headers = [
            "content-type": "text/plain",
            "X-RapidAPI-Key": Constants.rapidAPIKey,
            "X-RapidAPI-Host": "shazam.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://shazam.p.rapidapi.com/songs/v2/detect?timezone=America%2FChicago&locale=en-US") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 5.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = input.base64EncodedString().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.gettingData))
                return
            }
            do {
                let result = try JSONDecoder().decode(TrackResponse.self, from: data)
                guard let foundTrack = result.track else {
                    completion(.failure(.trackNotFound))
                    return
                }
                completion(.success(foundTrack))
            } catch {
                completion(.failure(.decoding))
            }
        }).resume()
    }
    
    public func searchForTrack(with artist: String, and trackName: String, completion: @escaping (Result<[FoundTrack], NetworkingError>) -> ()) {
        guard let trackName = trackName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let artist = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.encodingParameters))
            return
        }
        let urlString = K.baseURL + "search?q=track:\(trackName)%20artist:\(artist)&type=track&limit=3"
        createRequest(with: urlString) { request in
            guard let request = request else {
                completion(.failure(.requestInit))
                return
            }
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(.gettingData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FoundTracksResponse.self, from: data)
                    completion(.success(result.tracks.items))
                } catch {
                    completion(.failure(.decoding))
                }
            }.resume()
        }
    }
    
    public func getProfile(completion: @escaping (NetworkingError?) -> () = {_ in }) {
        let urlString = K.baseURL + "me"
        createRequest(with: urlString) { request in
            guard let request = request else {
                completion(.requestInit)
                return
            }
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.gettingData)
                    return
                }
                do {
                    let result = try JSONDecoder().decode(ProfileResponse.self, from: data)
                    ProfileManager.shared.profile = ProfileManager.Profile(imageURL: result.images.first?.url, username: result.display_name, email: result.email)
                    completion(nil)
                } catch {
                    completion(.decoding)
                }
            }.resume()
        }
    }
    
    private func createRequest(with urlString: String, completion: @escaping (URLRequest?) -> ()) {
        AuthManager.shared.withValidToken { token in
            guard let url = URL(string: urlString), let token = token else {
                completion(nil)
                return
            }
            var request = URLRequest(url: url)
            let fullToken = "Bearer \(token)"
            request.addValue(fullToken, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            completion(request)
        }
    }
}
