//
//  AuthManager.swift
//  Shapify

import Foundation

final class AuthManager {
    
    enum AuthManagerError: String, Error {
        case baseTokenURLMissed
        case refreshTokenMissed
        case failedToGetData
        case failedToDecodeToken
    }
    
    struct K {
        static let clientID = "6c0741586b8d40b7a2d56c4c7216c5dc"
        static let clientSecret = Constants.clientSecret
        static let redirectURI = "http://lvh.me"
        static let tokenBaseURL = "https://accounts.spotify.com/api/token"
        static let signInBaseURL = "https://accounts.spotify.com/authorize"
        static let scopes = "user-read-private%20playlist-modify-public%20user-read-email"
    }
    
    var signInURL: String {
        let url = "\(K.signInBaseURL)?scope=\(K.scopes)&redirect_uri=\(K.redirectURI)&client_id=\(K.clientID)&response_type=code&show_dialog=TRUE"
        return url
    }
    
    static let shared = AuthManager()
    
    private var onRefreshBlocks = [(String?) -> ()]()
    
    private init() {}
    
    var isLoggedIn: Bool {
        return accessToken != nil
    }
    
    var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var shouldRefreshToken: Bool {
        let fiveMinutes: TimeInterval = 300
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        return Date().addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private var refreshingToken = false
    
    /// Exchanges code received from Spotify for access token
    public func exchangeCodeForToken(code: String, completion: @escaping (Result<Bool, AuthManagerError>) -> ()) {
        guard let url = URL(string: K.tokenBaseURL) else {
            completion(.failure(.baseTokenURLMissed))
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: K.redirectURI)
        ]
        var request = URLRequest(url: url)
        request.httpBody = components.query?.data(using: .utf8)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let authField = Data("\(K.clientID):\(K.clientSecret)".utf8).base64EncodedString()
        request.setValue("Basic \(authField)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.failedToGetData))
                print(error?.localizedDescription ?? "")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.saveTokens(response: result)
                completion(.success(true))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.failedToDecodeToken))
            }
        }.resume()
    }
    
    /// Completion parameter is a valid access token or nil, ALWAYS use this method when making API calls
    ///
    /// How to use?
    /// ```
    /// func getDataFromAPI() {
    ///     withValidToken { token in
    ///         guard let token = token else {
    ///             print("Failed to get token")
    ///             return
    ///         }
    ///         makeAPICall(with: token)
    ///     }
    /// }
    /// ```
    public func withValidToken(completion: @escaping (String?) -> ()) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshTokenIfNeeded { [weak self] success in
                if success, let token = self?.accessToken {
                    completion(token)
                }else {
                    completion(nil)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
    }
    
    /// Refreshing token if it expires soon, sets completion parameter to true if refreshing succeded otherwise sets it to false
    public func refreshTokenIfNeeded(completion: @escaping (Bool) -> ()) {
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else {
            completion(false)
            return
        }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        guard let url = URL(string: K.tokenBaseURL) else {
            completion(false)
            return
        }
        refreshingToken = true
        var request = URLRequest(url: url)
        request.httpBody = components.query?.data(using: .utf8)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let authField = Data("\(K.clientID):\(K.clientSecret)".utf8).base64EncodedString()
        request.setValue("Basic \(authField)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion(false)
                print(error?.localizedDescription ?? "")
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.saveTokens(response: result)
                
                self?.onRefreshBlocks.forEach { completion in
                    completion(result.access_token)
                }
                self?.onRefreshBlocks.removeAll()
                
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }.resume()
    }
    
    /// Caching tokens and expiration date
    private func saveTokens(response: AuthResponse) {
        UserDefaults.standard.set(response.access_token, forKey: "access_token")
        if let refreshToken = response.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(response.expires_in), forKey: "expiration_date")
    }
    
    public func signOut() {
        UserDefaults.standard.set(nil, forKey: "expiration_date")
        UserDefaults.standard.set(nil, forKey: "access_token")
        UserDefaults.standard.set(nil, forKey: "refresh_token")
    }
}
